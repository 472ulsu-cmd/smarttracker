import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_banner.dart';
import '../../../core/widgets/phone_call_row.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = OrderDetailViewModel(widget.orderId, getIt<OrdersRepository>());
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (_viewModel.isLoading && _viewModel.order == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.order == null) {
            return EmptyState(
              icon: Icons.error_outline_rounded,
              text: _viewModel.loadErrorMessage ??
                  'Не удалось загрузить заявку. Проверьте соединение и повторите.',
              actionLabel: 'Повторить',
              onAction: _viewModel.load,
            );
          }
          final order = _viewModel.order!;
          return RefreshIndicator(
            onRefresh: _viewModel.load,
            color: BrandColors.primary,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_viewModel.loadErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ErrorBanner(
                      message: _viewModel.loadErrorMessage!,
                      onRetry: _viewModel.isLoading
                          ? null
                          : _viewModel.load,
                    ),
                  ),
                if (_viewModel.successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SuccessBanner(
                      message: _viewModel.successMessage!,
                      isRejection: _viewModel.lastAttemptedStatus ==
                          OrderStatus.rejected,
                    ),
                  ),
                _Summary(order: order),
                const SizedBox(height: 16),
                _ClientCard(order: order),
                const SizedBox(height: 16),
                _RouteCard(order: order),
                const SizedBox(height: 16),
                // Фото доступно для заявок, принятых в работу.
                // Скрыто для «Новой заявки» (ещё не принято) и «Отказа».
                if (order.status != OrderStatus.newRequest.id &&
                    order.status != OrderStatus.rejected.id) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.photo_camera_outlined,
                        color: BrandColors.primary),
                    title: const Text('Фото по заявке'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push('/main/orders/${order.id}/photos'),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _viewModel.order == null
          ? null
          : _ActionsBar(viewModel: _viewModel),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.order});
  final OrderDetail order;

  @override
  Widget build(BuildContext context) {
    return BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    '№ ${order.num}',
                    style: AppTextStyles.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              StatusChip(statusId: order.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.route_rounded,
                  color: BrandColors.primary,
                  size: 20,
                  semanticLabel: 'Маршрут'),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.route,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (order.cargoType.isNotEmpty)
                _InfoItem(label: 'Груз', value: order.cargoType),
              if (order.mass.isNotEmpty)
                _InfoItem(label: 'Масса', value: '${order.mass} т'),
              if (order.volume.isNotEmpty)
                _InfoItem(label: 'Объём', value: '${order.volume} м³'),
            ],
          ),
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
        Text(label,
            style: AppTextStyles.caption.copyWith(color: BrandColors.grayDark)),
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

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.order});
  final OrderDetail order;

  @override
  Widget build(BuildContext context) {
    final c = order.client;
    if (c.org.isEmpty && c.manager.isEmpty && c.phone.isEmpty) {
      return const SizedBox.shrink();
    }
    return BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
              header: true,
              child: Text('Заказчик', style: AppTextStyles.titleMedium),
            ),
          const SizedBox(height: 8),
          if (c.org.isNotEmpty)
            _Row(
                icon: Icons.business_outlined,
                text: c.org,
                semanticLabel: 'Организация'),
          if (c.manager.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _Row(
                  icon: Icons.person_outline,
                  text: c.manager,
                  semanticLabel: 'Контактное лицо'),
            ),
          if (c.phone.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: PhoneCallRow(phone: c.phone),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.text, this.semanticLabel});
  final IconData icon;
  final String text;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            size: 18, color: BrandColors.grayMid, semanticLabel: semanticLabel),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.order});
  final OrderDetail order;

  @override
  Widget build(BuildContext context) {
    if (order.routeDetails.isEmpty) return const SizedBox.shrink();
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
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () =>
                    context.push('/main/orders/${order.id}/route'),
                child: const Text('Подробнее'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final point in order.routeDetails) ...[
            _RoutePoint(point: point),
            if (point != order.routeDetails.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Divider(height: 1),
              ),
          ],
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
    final dotColor =
        point.isLoading ? BrandColors.primary : BrandColors.grayMid;
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
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 15, height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (point.date.isNotEmpty)
                Text(
                  '${DateFormatUtil.date(point.date)}  '
                  '${DateFormatUtil.time(point.timeFrom)}–'
                  '${DateFormatUtil.time(point.timeTo)}',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: BrandColors.grayDark, height: 1.2),
                  maxLines: 1,
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

    final progressActions = actions.where((s) => s != OrderStatus.rejected).toList();
    final destructiveActions = actions.where((s) => s == OrderStatus.rejected).toList();

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
                  Text(
                    'Отправляем статус…',
                    style: AppTextStyles.bodyMedium,
                  ),
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
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: () => _confirm(context),
      child: Text(label),
    );
  }

  Future<void> _confirm(BuildContext context) async {
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
              // Заголовок вверху слева, крестик закрытия — вверху справа
              // на той же строке.
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
                style: AppTextStyles.bodyMedium
                    .copyWith(color: BrandColors.grayDark),
              ),
              const SizedBox(height: 20),
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
      final success = await viewModel.changeStatus(status);
      if (success && context.mounted) {
        HapticFeedback.mediumImpact();
      }
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
    final accentColor =
        isRejection ? BrandColors.statusRejectedForeground : BrandColors.greenWeb;
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
                color: BrandColors.graphite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
