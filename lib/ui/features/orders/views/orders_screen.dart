import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_order_tile.dart';
import '../../../core/widgets/swipeable_order_tile.dart';
import '../view_models/orders_view_model.dart';

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

class _OrdersTabBody extends StatefulWidget {
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
  State<_OrdersTabBody> createState() => _OrdersTabBodyState();
}

class _OrdersTabBodyState extends State<_OrdersTabBody> {
  /// Каскад запускается один раз — при первом показе списка с данными.
  /// При pull-to-refresh и последующих перестройках карточки появляются
  /// мгновенно: анимация показа на каждом refresh была бы шумом и
  /// конфликтовала с самим смыслом «обновить и увидеть свежие данные».
  ///
  /// Исключение: смена направления сортировки — каскад перезапускается,
  /// чтобы водитель увидел переупорядочивание как тактильное событие,
  /// а не мгновенную смену позиций.
  bool _didCascade = false;

  /// Текущий режим сортировки — для отслеживания смены направления.
  OrdersSortMode? _lastSortMode;

  /// Обработчик свайп-действия: смена статуса заявки со snack-баром.
  ///
  /// Вызывается из [SwipeableOrderTile.onAccept] / [onReject].
  /// Меняет статус через репозиторий, обновляет список через шину и
  /// показывает snack-бар с результатом. Ошибки показываются как snack-бар
  /// с кнопкой «Повторить» — UI списка при этом не дёргается.
  void _onSwipeStatusChange({
    required BuildContext context,
    required int orderId,
    required OrderStatus nextStatus,
  }) {
    final repository = getIt<OrdersRepository>();
    final label = nextStatus == OrderStatus.inProgress
        ? 'Заявка принята в работу'
        : 'Заявка отклонена';

    // Optimistic: сразу обновляем список — водитель видит мгновенный отклик.
    getIt<OrdersRefreshBus>().notifyChanged();

    // Фоновый вызов API. При ошибке — показываем snack-бар с возможностью
    // повторить и перезагружаем список (статус на бэкенде не поменялся).
    repository.changeStatus(orderId, nextStatus.id).then((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(label),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Не удалось изменить статус. Проверьте соединение.',
          ),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Повторить',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              _onSwipeStatusChange(
                context: context,
                orderId: orderId,
                nextStatus: nextStatus,
              );
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      // Перезагружаем список — статус на сервере не изменился.
      widget.viewModel.loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final tab = widget.tab;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoadingOf(tab) && viewModel.ordersOf(tab).isEmpty) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: 4,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SkeletonOrderTile(),
            ),
          );
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
            text: widget.emptyText,
            hint: widget.emptyHint,
            actionLabel: 'Обновить',
            onAction: () => viewModel.loadTab(tab),
          );
        }
        // Каскад — только при первом показе непустого списка.
        // Исключение: смена направления сортировки перезапускает каскад,
        // чтобы переупорядочивание карточек было видно как событие.
        final currentSort = viewModel.sortMode;
        final sortChanged = _lastSortMode != null && _lastSortMode != currentSort;
        final shouldCascade = !_didCascade || sortChanged;
        _didCascade = true;
        _lastSortMode = currentSort;
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
                    return _CascadeTile(
                      key: ValueKey('cascade-${order.id}'),
                      index: index,
                      animate: shouldCascade,
                      child: SwipeableOrderTile(
                        order: order,
                        onTap: () =>
                            context.push('/main/orders/${order.id}'),
                        onAccept: order.status == OrderStatus.newRequest.id
                            ? () => _onSwipeStatusChange(
                                  context: context,
                                  orderId: order.id,
                                  nextStatus: OrderStatus.inProgress,
                                )
                            : null,
                        onReject: order.status == OrderStatus.newRequest.id
                            ? () => _onSwipeStatusChange(
                                  context: context,
                                  orderId: order.id,
                                  nextStatus: OrderStatus.rejected,
                                )
                            : null,
                      ),
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

/// Карточка заявки с каскадным появлением: slide-up + fade со staggered-
/// задержкой по индексу. Только при первом показе списка; при refresh и
/// последующих перестройках — показ без анимации (animate=false).
/// Reduce Motion honoured: при disableAnimations — мгновенно.
class _CascadeTile extends StatefulWidget {
  const _CascadeTile({
    super.key,
    required this.index,
    required this.animate,
    required this.child,
  });

  final int index;
  final bool animate;
  final Widget child;

  @override
  State<_CascadeTile> createState() => _CascadeTileState();
}

class _CascadeTileState extends State<_CascadeTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Длительность одной карточки; задержка задаётся через startOffset.
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    // Перезапуск каскада при смене сортировки: animate пришёл true,
    // хотя контроллер уже в 1.0 (предыдущий показ закончился).
    if (widget.animate &&
        _controller.value == 1.0 &&
        _lastAnimateSeen == false &&
        !reduceMotion) {
      _controller.value = 0.0;
      _scheduleCascade(reduceMotion);
      _lastAnimateSeen = widget.animate;
      return;
    }
    if (_controller.value > 0 && _lastAnimateSeen == widget.animate) {
      return; // уже запущен/завершён, состояние не поменялось.
    }
    _lastAnimateSeen = widget.animate;
    if (!widget.animate || reduceMotion) {
      // Без анимации — сразу в конечной позиции (refresh, reduce-motion).
      _controller.value = 1.0;
      return;
    }
    _scheduleCascade(reduceMotion);
  }

  bool _lastAnimateSeen = false;

  void _scheduleCascade(bool reduceMotion) {
    if (reduceMotion) {
      _controller.value = 1.0;
      return;
    }
    // Staggered: +60ms за каждую карточку, потолок ~8 — длинные хвосты
    // не ждут появления последних элементов.
    final stagger = Duration(milliseconds: 60 * widget.index.clamp(0, 8));
    Future<void>.delayed(stagger, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Reduce Motion: значение контроллера уже 1.0 (выше), либо animate=false
    // → FadeTransition/SlideTransition нейтральны.
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
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
      tooltip: 'Сортировать по дате погрузки',
      icon: const Icon(Icons.sort_rounded),
      // Дефолтный padding PopupMenuButton уже даёт touch target ≥48dp
      // по Material/HIG — критично в поле и в перчатках.
      onSelected: (mode) {
        HapticFeedback.selectionClick();
        viewModel.setSortMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: OrdersSortMode.loadingSoonest,
          child: _SortMenuLabel(
            label: '▲ Дата погрузки',
            selected: viewModel.sortMode == OrdersSortMode.loadingSoonest,
          ),
        ),
        PopupMenuItem(
          value: OrdersSortMode.loadingLatest,
          child: _SortMenuLabel(
            label: '▼ Дата погрузки',
            selected: viewModel.sortMode == OrdersSortMode.loadingLatest,
          ),
        ),
      ],
    );
  }
}

/// Строка пункта меню сортировки: активный отмечен только цветом.
class _SortMenuLabel extends StatelessWidget {
  const _SortMenuLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.bodyLarge.copyWith(
        color: selected ? BrandColors.primary : BrandColors.graphite,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
