import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../view_models/orders_view_model.dart';
import 'order_list_tile.dart';

/// Экран списка заявок с вкладками: Новые / В работе / Архив.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final OrdersViewModel _viewModel;
  late final OrdersRefreshBus _refreshBus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _viewModel = getIt<OrdersViewModel>();
    _viewModel.addListener(_onChanged);
    // Обновление списка при смене статуса заявки или новом уведомлении.
    _refreshBus = getIt<OrdersRefreshBus>();
    _refreshBus.addListener(_onExternalRefresh);
    _viewModel.loadAll();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _refreshBus.removeListener(_onExternalRefresh);
    _viewModel.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onExternalRefresh() {
    if (mounted) _viewModel.loadAll();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заявки'),
        actions: [
          // Сортировка — стандартное место вторичного действия списка в
          // Material/HIG: верхний app bar. Не сжимает поле поиска внизу.
          // PopupMenuButton с двумя пунктами; активный отмечен галочкой.
          _SortMenu(viewModel: _viewModel),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: BrandColors.primary,
          unselectedLabelColor: BrandColors.grayDark,
          indicatorColor: BrandColors.primary,
          labelStyle: AppTextStyles.titleMedium,
          tabs: const [
            Tab(text: 'Новые'),
            Tab(text: 'В работе'),
            Tab(text: 'Архив'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                return TextField(
                  onChanged: _viewModel.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Поиск заявок',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Очистить',
                            onPressed: () {
                              _viewModel.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OrdersTabBody(
                  viewModel: _viewModel,
                  tab: OrdersTab.newOrders,
                  emptyText: 'Нет новых заявок',
                  emptyHint: 'Новые заявки появятся здесь автоматически.',
                ),
                _OrdersTabBody(
                  viewModel: _viewModel,
                  tab: OrdersTab.inProgress,
                  emptyText: 'Нет заявок в работе',
                  emptyHint:
                      'Примите заявку из вкладки «Новые», чтобы начать работу.',
                ),
                _OrdersTabBody(
                  viewModel: _viewModel,
                  tab: OrdersTab.archive,
                  emptyText: 'В архиве нет заявок',
                  emptyHint:
                      'Завершённые и отклонённые заявки будут отображаться здесь.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _OrdersTabBody extends StatelessWidget {
  const _OrdersTabBody({
    required this.viewModel,
    required this.tab,
    required this.emptyText,
    this.emptyHint,
  });

  final OrdersViewModel viewModel;
  final OrdersTab tab;
  final String emptyText;
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoadingOf(tab) && viewModel.ordersOf(tab).isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = viewModel.errorOf(tab);
        if (error != null && viewModel.ordersOf(tab).isEmpty) {
          return ErrorState(
              message: error, onRetry: () => viewModel.loadTab(tab));
        }
        final orders = viewModel.ordersOf(tab);
        if (orders.isEmpty) {
          return EmptyState(
            icon: Icons.local_shipping_outlined,
            text: emptyText,
            hint: emptyHint,
            actionLabel: 'Обновить',
            onAction: () => viewModel.loadTab(tab),
          );
        }
        return Column(
          children: [
            if (error != null)
              _UpdateErrorBanner(
                message: error,
                onRetry: () => viewModel.loadTab(tab),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.loadTab(tab),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderListTile(
                      order: order,
                      onTap: () => context.push('/main/orders/${order.id}'),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Меню сортировки заявок в AppBar.
///
/// Стандартное платформенное место для вторичного действия списка: верхний
/// app bar (Material/HIG). PopupMenuButton с двумя пунктами; активное
/// направление отмечено галочкой, что делает текущее состояние видимым без
/// необходимости открывать меню повторно. Тактильная отдача подтверждает
/// смену состояния — водитель в перчатках может не видеть подсветки.
class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.viewModel});

  final OrdersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OrdersSortMode>(
      tooltip: 'Сортировка',
      icon: const Icon(Icons.sort_rounded),
      // Дефолтный padding PopupMenuButton уже даёт touch target ≥48dp
      // по Material/HIG — критично в поле и в перчатках.
      onSelected: (mode) {
        HapticFeedback.selectionClick();
        viewModel.setSortMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: OrdersSortMode.newestFirst,
          child: _SortMenuLabel(
            label: 'Сначала новые',
            selected: viewModel.sortMode == OrdersSortMode.newestFirst,
          ),
        ),
        PopupMenuItem(
          value: OrdersSortMode.oldestFirst,
          child: _SortMenuLabel(
            label: 'Сначала старые',
            selected: viewModel.sortMode == OrdersSortMode.oldestFirst,
          ),
        ),
      ],
    );
  }
}

/// Строка пункта меню сортировки: текст + галочка у активного.
class _SortMenuLabel extends StatelessWidget {
  const _SortMenuLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Зарезервированное место под галочку — чтобы тексты обоих пунктов
        // стояли по одной вертикали независимо от выбранного.
        SizedBox(
          width: 24,
          child: selected
              ? const Icon(Icons.check_rounded,
                  size: 20, color: BrandColors.primary)
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color:
                selected ? BrandColors.primary : BrandColors.graphite,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Баннер ошибки обновления списка, когда кэш уже есть.
class _UpdateErrorBanner extends StatelessWidget {
  const _UpdateErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.errorBackground,
        border: Border(
          bottom: BorderSide(color: BrandColors.error.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: BrandColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.errorText),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
