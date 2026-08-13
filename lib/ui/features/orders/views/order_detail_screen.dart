import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../../data/services/settings_service.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/transitions/app_transitions.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/onboarding_hint.dart';
import '../../../core/widgets/phone_call_row.dart';
import '../../../core/widgets/skeleton_order_detail.dart';
import '../../../core/widgets/status_chip.dart';
import '../view_models/order_detail_view_model.dart';

/// Человекочитаемая метка действия по статусу.
String _statusActionLabel(OrderStatus s) {
  switch (s) {
    case OrderStatus.inProgress:
      return 'Принять в работу';
    case OrderStatus.loaded:
      return 'Подтвердить погрузку';
    case OrderStatus.completed:
      return 'Завершить заявку';
    case OrderStatus.rejected:
      return 'Отказаться от заявки';
    default:
      return s.label;
  }
}

/// Пояснение последствий действия для диалога подтверждения.
String _statusActionConsequence(OrderStatus s) {
  switch (s) {
    case OrderStatus.inProgress:
      return 'Статус заявки будет изменен на "В работе".';
    case OrderStatus.loaded:
      return 'Подтвердите, что груз погружен.';
    case OrderStatus.completed:
      return 'Заявка будет переведена в статус «Завершена». Убедитесь, что груз доставлен.';
    case OrderStatus.rejected:
      return 'Заявка будет отменена и перемещена в архив. Это действие нельзя отменить.';
    default:
      return '';
  }
}

/// Экран деталей заявки.
class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late final OrderDetailViewModel _viewModel;
  late final SettingsService _settings;
  late final bool _routeHintPending;
  late final bool _photoHintPending;
  late bool _routeHintResolved;
  late bool _photoHintResolved;
  final GlobalKey _routeTargetKey = GlobalKey();
  final GlobalKey _photoTargetKey = GlobalKey();
  bool _routeHintVisible = false;
  bool _photoHintVisible = false;
  bool _photoHintScheduled = false;
  bool _routeScreenOpen = false;

  /// Таймер авто-затухания баннера успеха: держим ~3.5с, затем чистим
  /// successMessage → баннер slide-fade-out.
  Timer? _successDismissTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderDetailViewModel(
      widget.orderId,
      getIt<OrdersRepository>(),
    );
    _settings = getIt<SettingsService>();
    _routeHintPending = !_settings.hasSeenOnboardingHint(
      OnboardingHint.orderRouteEntry,
    );
    _photoHintPending = !_settings.hasSeenOnboardingHint(
      OnboardingHint.orderPhotoEntry,
    );
    _routeHintResolved = !_routeHintPending;
    _photoHintResolved = !_photoHintPending;
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  @override
  void dispose() {
    _successDismissTimer?.cancel();
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    // При появлении сообщения об успехе — планируем авто-затухание.
    if (_viewModel.successMessage != null) {
      _successDismissTimer?.cancel();
      _successDismissTimer = Timer(const Duration(milliseconds: 3500), () {
        if (mounted) _viewModel.clearSuccessMessage();
      });
    } else {
      _successDismissTimer?.cancel();
    }
    _activateNextHint();
    setState(() {});
  }

  void _activateNextHint() {
    final order = _viewModel.order;
    if (order == null) return;

    if (_routeHintPending &&
        !_routeHintResolved &&
        !_routeHintVisible &&
        order.routeDetails.isNotEmpty) {
      _routeHintVisible = true;
      unawaited(
        _settings.markOnboardingHintSeen(OnboardingHint.orderRouteEntry),
      );
      return;
    }

    final routeBlocksPhoto =
        _routeHintPending &&
        !_routeHintResolved &&
        order.routeDetails.isNotEmpty;
    final photosAvailable =
        order.status != OrderStatus.newRequest.id &&
        order.status != OrderStatus.rejected.id;
    if (_photoHintPending &&
        !_photoHintResolved &&
        !_photoHintVisible &&
        !_photoHintScheduled &&
        !_routeScreenOpen &&
        !routeBlocksPhoto &&
        photosAvailable) {
      _photoHintScheduled = true;
      unawaited(_revealPhotoHintAfterScroll());
    }
  }

  Future<void> _revealPhotoHintAfterScroll() async {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    BuildContext? targetContext;
    // После возврата с маршрута Navigator сначала восстанавливает экран, а
    // после принятия заявки одновременно раскрывается баннер успеха. Ждём
    // готовую раскладку, иначе ссылка успевает сместиться уже после прокрутки.
    for (var attempt = 0; attempt < 3 && targetContext == null; attempt++) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || _photoHintResolved || _routeScreenOpen) {
        _photoHintScheduled = false;
        return;
      }
      targetContext = _photoTargetKey.currentContext;
    }

    if (!reduceMotion && _viewModel.successMessage != null) {
      // Совпадает с длительностью появления success-баннера: после его
      // раскладки цель уже стабильна, дополнительная пауза не нужна.
      await Future<void>.delayed(const Duration(milliseconds: 280));
      await WidgetsBinding.instance.endOfFrame;
      targetContext = _photoTargetKey.currentContext;
    }

    if (!mounted || targetContext == null || !targetContext.mounted) {
      _photoHintScheduled = false;
      return;
    }

    await Scrollable.ensureVisible(
      targetContext,
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      // Оставляем под ссылкой место для реплики spotlight и не прижимаем её
      // к нижней панели действий.
      alignment: 0.38,
    );
    await WidgetsBinding.instance.endOfFrame;
    targetContext = _photoTargetKey.currentContext;
    if (mounted && targetContext != null && targetContext.mounted) {
      // Финальная коррекция нужна для динамического сценария принятия:
      // первый проход анимирует список, второй фиксирует точное положение.
      await Scrollable.ensureVisible(
        targetContext,
        duration: Duration.zero,
        alignment: 0.38,
      );
      await WidgetsBinding.instance.endOfFrame;
    }
    if (!mounted || _photoHintResolved || _routeScreenOpen) {
      _photoHintScheduled = false;
      return;
    }

    setState(() {
      _photoHintScheduled = false;
      _photoHintVisible = true;
    });
    unawaited(_settings.markOnboardingHintSeen(OnboardingHint.orderPhotoEntry));
  }

  void _resolveRouteHint() {
    _completeRouteHint(activateNext: true);
  }

  void _completeRouteHint({required bool activateNext}) {
    if (_routeHintResolved) return;
    setState(() {
      _routeHintVisible = false;
      _routeHintResolved = true;
    });
    if (activateNext) _activateNextHint();
  }

  void _dismissPhotoHint() {
    if (_photoHintResolved) return;
    setState(() {
      _photoHintVisible = false;
      _photoHintResolved = true;
    });
  }

  Future<void> _openRoute(OrderDetail order) async {
    _routeScreenOpen = true;
    // Фото не показываем на странице, которая прямо сейчас уходит назад.
    _completeRouteHint(activateNext: false);
    await context.push('/main/orders/${order.id}/route');
    if (!mounted) return;
    _routeScreenOpen = false;
    _activateNextHint();
  }

  void _openPhotos(OrderDetail order) {
    _dismissPhotoHint();
    context.push('/main/orders/${order.id}/photos');
  }

  @override
  Widget build(BuildContext context) {
    final showCoach = _routeHintVisible || _photoHintVisible;
    final targetKey = _routeHintVisible ? _routeTargetKey : _photoTargetKey;
    final message = _routeHintVisible
        ? 'Нажмите «Подробнее», чтобы открыть весь маршрут'
        : 'Нажмите «Фото по заявке», чтобы добавить снимки';
    return SpotlightCoach(
      visible: showCoach,
      targetKey: targetKey,
      message: message,
      onDismiss: _routeHintVisible ? _resolveRouteHint : _dismissPhotoHint,
      child: Scaffold(
        appBar: AppBar(
          title: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final order = _viewModel.order;
              return Text(
                order == null ? 'Заявка' : 'Заявка №${order.num}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final reduceMotion = MediaQuery.disableAnimationsOf(context);
            final Widget body;
            final String phase;
            if (_viewModel.isLoading && _viewModel.order == null) {
              phase = 'loading';
              body = const SkeletonOrderDetail();
            } else if (_viewModel.order == null) {
              phase = 'error';
              body = EmptyState(
                icon: Icons.error_outline_rounded,
                iconColor: BrandColors.error,
                text:
                    _viewModel.loadErrorMessage ??
                    'Не удалось загрузить заявку. Проверьте соединение и повторите.',
                actionLabel: 'Повторить',
                onAction: _viewModel.load,
              );
            } else {
              phase = 'content';
              final order = _viewModel.order!;
              body = RefreshIndicator(
                onRefresh: _viewModel.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (_viewModel.loadErrorMessage != null)
                      // AnimatedSize: появление/исчезновение баннера плавно
                      // сдвигает контент, а не скачком — без этого вставка
                      // баннера дёргает _Summary (с чипом) и статус-морф.
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ErrorBanner(
                            message: _viewModel.loadErrorMessage!,
                            onRetry: _viewModel.isLoading
                                ? null
                                : _viewModel.load,
                          ),
                        ),
                      ),
                    // Баннер успеха: всплывает (slide-up + fade), держится ~3.5с,
                    // затем растворяется и авто-скрывается (таймер в _onChanged →
                    // clearSuccessMessage). AnimatedSwitcher даёт вход/выход,
                    // AnimatedSize — плавный сдвиг контента под высоту баннера.
                    AnimatedSize(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                      child: AnimatedSwitcher(
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, anim) {
                          if (MediaQuery.disableAnimationsOf(context)) {
                            return child;
                          }
                          // Slide-up + fade: баннер «подъезжает» снизу.
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.4),
                              end: Offset.zero,
                            ).animate(anim),
                            child: FadeTransition(opacity: anim, child: child),
                          );
                        },
                        child: _viewModel.successMessage != null
                            ? Padding(
                                key: const ValueKey('success-banner'),
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _SuccessBanner(
                                  message: _viewModel.successMessage!,
                                  isRejection:
                                      _viewModel.lastAttemptedStatus ==
                                      OrderStatus.rejected,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    _OrderDetailsCard(order: order),
                    const SizedBox(height: 16),
                    _RouteCard(
                      order: order,
                      targetKey: _routeTargetKey,
                      onOpen: () => _openRoute(order),
                    ),
                    const SizedBox(height: 16),
                    // Фото доступно для заявок, принятых в работу.
                    // Скрыто для «Новой заявки» (ещё не принято) и «Отказа».
                    if (order.status != OrderStatus.newRequest.id &&
                        order.status != OrderStatus.rejected.id)
                      Column(
                        children: [
                          ListTile(
                            key: _photoTargetKey,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            leading: const Icon(
                              Icons.photo_camera_outlined,
                              color: BrandColors.primary,
                            ),
                            title: const Text('Фото по заявке'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => _openPhotos(order),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                  ],
                ),
              );
            }
            // Crossfade skeleton→content: 150мс fade-only, Reduce Motion → мгновенно.
            return AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 150),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: KeyedSubtree(key: ValueKey(phase), child: body),
            );
          },
        ),
        bottomNavigationBar: _viewModel.order == null
            ? null
            : _ActionsBar(viewModel: _viewModel),
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard({required this.order});
  final OrderDetail order;

  @override
  Widget build(BuildContext context) {
    final client = order.client;
    final hasCargo =
        order.cargoType.isNotEmpty ||
        order.mass.isNotEmpty ||
        order.volume.isNotEmpty;
    final hasClient =
        client.org.isNotEmpty ||
        client.manager.isNotEmpty ||
        client.phone.isNotEmpty;

    return BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasCargo)
            Semantics(
              key: const ValueKey('order-detail-cargo'),
              container: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text('Груз', style: AppTextStyles.labelMedium),
                        ),
                      ),
                      const SizedBox(width: 12),
                      KeyedSubtree(
                        key: const ValueKey('order-detail-status'),
                        child: AppTransitions.heroStatusChip(
                          orderId: order.id,
                          statusId: order.status,
                          chip: StatusChip(statusId: order.status),
                        ),
                      ),
                    ],
                  ),
                  if (order.cargoType.isNotEmpty) ...[
                    Text(
                      order.cargoType,
                      style: AppTextStyles.labelLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (order.mass.isNotEmpty || order.volume.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        if (order.mass.isNotEmpty)
                          _InfoItem(label: 'Масса', value: '${order.mass} т'),
                        if (order.volume.isNotEmpty)
                          _InfoItem(
                            label: 'Объём',
                            value: '${order.volume} м³',
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            )
          else
            Row(
              children: [
                KeyedSubtree(
                  key: const ValueKey('order-detail-status'),
                  child: AppTransitions.heroStatusChip(
                    orderId: order.id,
                    statusId: order.status,
                    chip: StatusChip(statusId: order.status),
                  ),
                ),
              ],
            ),
          if (hasClient) ...[
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 16),
              child: Divider(height: 1),
            ),
            Semantics(
              key: const ValueKey('order-detail-client'),
              container: true,
              explicitChildNodes: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Заказчик',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: BrandColors.grayDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (client.org.isNotEmpty)
                    _Row(
                      icon: Icons.business_outlined,
                      text: client.org,
                      semanticLabel: 'Организация',
                      textStyle: AppTextStyles.labelLarge,
                    ),
                  if (client.manager.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _Row(
                        icon: Icons.person_outline,
                        text: client.manager,
                        semanticLabel: 'Контактное лицо',
                      ),
                    ),
                  if (client.phone.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: PhoneCallRow(phone: client.phone),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        Text(
          value,
          style: AppTextStyles.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.text,
    this.semanticLabel,
    this.textStyle,
  });
  final IconData icon;
  final String text;
  final String? semanticLabel;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: BrandColors.grayMid,
          semanticLabel: semanticLabel,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: textStyle ?? AppTextStyles.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.order,
    required this.targetKey,
    required this.onOpen,
  });

  final OrderDetail order;
  final GlobalKey targetKey;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (order.routeDetails.isEmpty) return const SizedBox.shrink();
    final points = order.routeDetails;
    final visiblePoints = points.length <= 2
        ? points
        : [points.first, points.last];
    final hiddenPointCount = points.length - visiblePoints.length;
    return BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Semantics(
                header: true,
                child: Text('Маршрут', style: AppTextStyles.titleMedium),
              ),
              const Spacer(),
              TextButton(
                key: targetKey,
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: onOpen,
                child: const Text('Подробнее'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final point in visiblePoints) ...[
            _RoutePoint(point: point),
            if (point != visiblePoints.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(height: 1),
              ),
          ],
          if (hiddenPointCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Промежуточные точки: $hiddenPointCount',
                style: AppTextStyles.bodySmall.copyWith(
                  color: BrandColors.grayDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({required this.point});
  final OrderRouteDetail point;

  @override
  Widget build(BuildContext context) {
    final dotColor = point.isLoading
        ? BrandColors.primary
        : BrandColors.grayMid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 12, color: dotColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${point.isLoading ? "Погрузка" : "Разгрузка"} — ${point.city}',
                style: AppTextStyles.labelLarge.copyWith(height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (point.date.isNotEmpty)
                Text(
                  '${DateFormatUtil.date(point.date)}  '
                  '${DateFormatUtil.time(point.timeFrom)}–'
                  '${DateFormatUtil.time(point.timeTo)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: BrandColors.grayDark,
                    height: 1.2,
                  ),
                  // Окно времени погрузки/разгрузки не должно теряться при
                  // крупном масштабе шрифта — поднимаем с 1 до 2 строк.
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({required this.viewModel});
  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final actions = viewModel.availableActions;
    if (actions.isEmpty) return const SizedBox.shrink();

    final progressActions = actions
        .where((s) => s != OrderStatus.rejected)
        .toList();
    final destructiveActions = actions
        .where((s) => s == OrderStatus.rejected)
        .toList();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: BrandColors.white,
          border: Border(top: BorderSide(color: BrandColors.grayLighter)),
        ),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.isActionInProgress) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                  const SizedBox(width: 12),
                  Text('Отправляем статус…', style: AppTextStyles.bodyMedium),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ErrorBanner(
                      message: viewModel.errorMessage!,
                      onRetry: viewModel.retryLastAction,
                    ),
                  ),
                ...progressActions.map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ActionButton(
                      viewModel: viewModel,
                      status: status,
                      isDestructive: false,
                    ),
                  ),
                ),
                if (destructiveActions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  for (final status in destructiveActions)
                    _ActionButton(
                      viewModel: viewModel,
                      status: status,
                      isDestructive: true,
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.viewModel,
    required this.status,
    required this.isDestructive,
  });

  final OrderDetailViewModel viewModel;
  final OrderStatus status;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final label = _statusActionLabel(status);
    final style = OutlinedButton.styleFrom(
      foregroundColor: BrandColors.error,
      side: const BorderSide(color: BrandColors.error),
      minimumSize: const Size.fromHeight(52),
    );

    if (isDestructive) {
      return OutlinedButton(
        style: style,
        onPressed: () => _confirm(context),
        child: Text(label),
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
      onPressed: () => _confirm(context),
      child: Text(label),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    // Брендовый диалог: те же кнопки, что и во всём приложении —
    // ElevatedButton/OutlinedButton во всю ширину (52dp, 12px radius).
    // showDialog + Dialog работает идентично на обеих платформах без
    // платформенных сюрпризов adaptive-вариантов.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: BrandColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BrandRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _statusActionLabel(status),
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Закрыть',
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => Navigator.pop(ctx, false),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _statusActionConsequence(status),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: BrandColors.grayDark,
                ),
              ),
              const SizedBox(height: 20),
              // Кнопка подтверждения — во всю ширину, как во всём приложении.
              // Деструктивное действие (отказ) — красный OutlinedButton,
              // обычное — оранжевый ElevatedButton.
              if (isDestructive)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrandColors.error,
                    side: const BorderSide(color: BrandColors.error),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Отказаться'),
                )
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Подтвердить'),
                ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true && context.mounted) {
      // Тактиль — НЕ после ответа бэкенда (там сетевой round-trip 0.5–2 с,
      // водитель уже не связывает вибрацию со своим тапом), а мгновенно
      // при подтверждении действия. Визуальное подтверждение результата
      // (морф чипа при смене статуса) играет отдельно — это два разных
      // события: «действие принято» и «стус изменился».
      HapticFeedback.mediumImpact();
      await viewModel.changeStatus(status);
    }
  }
}

/// Баннер успешной смены статуса (без возможности отмены).
///
/// При отклонении заявки [isRejection] = true — используется красная палитра
/// вместо зелёной, чтобы визуально подчеркнуть негативный исход.
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.message, this.isRejection = false});

  final String message;
  final bool isRejection;

  @override
  Widget build(BuildContext context) {
    final accentColor = isRejection
        ? BrandColors.statusRejectedForeground
        : BrandColors.greenWeb;
    final backgroundColor = isRejection
        ? BrandColors.statusRejectedBackground
        : BrandColors.successBackground;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(BrandRadius.sm),
        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isRejection
                ? Icons.highlight_off_rounded
                : Icons.check_circle_outline_rounded,
            color: accentColor,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
