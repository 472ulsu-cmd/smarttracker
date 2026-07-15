import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: _viewModel.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: _viewModel.searchScope ==
                                OrdersSearchScope.number
                            ? 'Поиск по номеру'
                            : 'Поиск по маршруту',
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
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _SearchScopeChip(
                          label: 'По номеру',
                          selected: _viewModel.searchScope ==
                              OrdersSearchScope.number,
                          onSelected: () => _viewModel.setSearchScope(
                              OrdersSearchScope.number),
                        ),
                        _SearchScopeChip(
                          label: 'По маршруту',
                          selected: _viewModel.searchScope ==
                              OrdersSearchScope.route,
                          onSelected: () => _viewModel.setSearchScope(
                              OrdersSearchScope.route),
                        ),
                      ],
                    ),
                  ],
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
                  onAcceptOrder: _acceptOrder,
                  onRejectOrder: _rejectOrder,
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

  Future<void> _acceptOrder(int id) async {
    final ok = await _viewModel.acceptOrder(id);
    if (!mounted) return;
    if (ok) {
      context.push('/main/orders/$id');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось принять заявку')),
      );
    }
  }

  Future<void> _rejectOrder(int id) async {
    final ok = await _viewModel.rejectOrder(id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось отказаться от заявки')),
      );
    }
  }
}

class _OrdersTabBody extends StatelessWidget {
  const _OrdersTabBody({
    required this.viewModel,
    required this.tab,
    required this.emptyText,
    this.emptyHint,
    this.onAcceptOrder,
    this.onRejectOrder,
  });

  final OrdersViewModel viewModel;
  final OrdersTab tab;
  final String emptyText;
  final String? emptyHint;
  final Future<void> Function(int)? onAcceptOrder;
  final Future<void> Function(int)? onRejectOrder;

  @override
  Widget build(BuildContext context) {
    final showActions =
        onAcceptOrder != null && onRejectOrder != null;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoadingOf(tab) && viewModel.ordersOf(tab).isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = viewModel.errorOf(tab);
        if (error != null && viewModel.ordersOf(tab).isEmpty) {
          return _ErrorState(
              message: error, onRetry: () => viewModel.loadTab(tab));
        }
        final orders = viewModel.ordersOf(tab);
        if (orders.isEmpty) {
          return _EmptyState(
            text: emptyText,
            hint: emptyHint,
            onRefresh: () => viewModel.loadTab(tab),
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
                color: BrandColors.primary,
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
                      onAccept: showActions
                          ? () => onAcceptOrder!(order.id)
                          : null,
                      onReject: showActions
                          ? () => onRejectOrder!(order.id)
                          : null,
                      isLoading: viewModel.isOrderLoading(order.id),
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

class _SearchScopeChip extends StatelessWidget {
  const _SearchScopeChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BrandRadius.pill),
      ),
      side: const BorderSide(color: BrandColors.grayLight),
      backgroundColor: BrandColors.white,
      selectedColor: BrandColors.primary,
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: selected ? BrandColors.white : BrandColors.graphite,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text, this.hint, this.onRefresh});
  final String text;
  final String? hint;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_shipping_outlined,
                size: 56, color: BrandColors.grayMid),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: BrandColors.grayDark)),
            if (hint != null) ...[
              const SizedBox(height: 8),
              Text(hint!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: BrandColors.grayDark)),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: onRefresh,
                child: const Text('Обновить'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 56, color: BrandColors.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
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
          bottom: BorderSide(color: BrandColors.error.withOpacity(0.35)),
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
              style:
                  AppTextStyles.bodyMedium.copyWith(color: BrandColors.error),
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
