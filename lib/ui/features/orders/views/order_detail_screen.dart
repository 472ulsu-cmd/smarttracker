import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/status_chip.dart';
import '../view_models/order_detail_view_model.dart';

/// Подсказка о следующем шаге для текущего статуса заявки.
String? _statusHintFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return 'Примите заявку, чтобы начать маршрут.';
    case OrderStatus.inProgress:
      return 'Следующий шаг — погрузка груза и фото.';
    case OrderStatus.loaded:
      return 'Доставьте груз и завершите заявку.';
    case OrderStatus.completed:
      return 'Заявка завершена. Спасибо за работу!';
    case OrderStatus.rejected:
      return 'Вы отказались от этой заявки.';
    default:
      return null;
  }
}

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
      return 'Заявка будет перемещена в «В работе».';
    case OrderStatus.loaded:
      return 'Подтвердите, что груз погружён. Далее потребуется загрузить фото.';
    case OrderStatus.completed:
      return 'Заявка будет переведена в статус «Завершена». Убедитесь, что груз доставлен.';
    case OrderStatus.rejected:
      return 'Заявка будет удалена из вашего списка. Это действие нельзя отменить.';
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
            return _CenterMessage(
              icon: Icons.error_outline_rounded,
              text: _viewModel.loadErrorMessage ??
                  'Не удалось загрузить заявку. Проверьте соединение и повторите.',
              action: _CenterMessageAction(
                label: 'Повторить',
                onPressed: _viewModel.load,
              ),
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
                    child: _ErrorBanner(
                      message: _viewModel.loadErrorMessage!,
                      onRetry: _viewModel.isLoading
                          ? null
                          : _viewModel.load,
                    ),
                  ),
                if (_viewModel.successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SuccessBanner(viewModel: _viewModel),
                  ),
                _Summary(order: order),
                const SizedBox(height: 16),
                _ClientCard(order: order),
                const SizedBox(height: 16),
                _RouteCard(order: order),
                const SizedBox(height: 16),
                if (order.status != OrderStatus.newRequest.id) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.photo_camera_outlined,
                        color: BrandColors.primary),
                    title: const Text('Фотографии'),
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
          Builder(
            builder: (context) {
              final hint = _statusHintFor(order.status);
              if (hint == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 18, color: BrandColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hint,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: BrandColors.grayDark),
                      ),
                    ),
                  ],
                ),
              );
            },
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
              child: _TappablePhoneRow(phone: c.phone),
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

class _TappablePhoneRow extends StatefulWidget {
  const _TappablePhoneRow({required this.phone});
  final String phone;

  @override
  State<_TappablePhoneRow> createState() => _TappablePhoneRowState();
}

class _TappablePhoneRowState extends State<_TappablePhoneRow> {
  bool _isCalling = false;

  Future<void> _call(BuildContext context) async {
    if (_isCalling) return;
    HapticFeedback.lightImpact();
    final normalized = normalizePhone(widget.phone);
    if (normalized.isEmpty) return;
    final uri = Uri.parse('tel:$normalized');

    setState(() => _isCalling = true);
    try {
      if (await canLaunchUrl(uri)) {
        try {
          await launchUrl(uri);
          return;
        } catch (_) {
          // Падение целевого приложения — показываем fallback ниже.
        }
      }
    } finally {
      if (mounted) setState(() => _isCalling = false);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось позвонить. Попробуйте позже.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: _isCalling ? null : () => _call(context),
        borderRadius: BorderRadius.circular(BrandRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 18,
                  color: BrandColors.primary,
                  semanticLabel: 'Позвонить'),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.phone,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: BrandColors.graphite,
                    decoration: TextDecoration.underline,
                    decorationColor: BrandColors.graphite,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
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
          child: Text(
            '${point.isLoading ? "Погрузка" : "Разгрузка"} — ${point.city}',
            style: AppTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                    child: _ErrorBanner(
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
      builder: (ctx) => AlertDialog(
        title: Text(_statusActionLabel(status)),
        content: Text(_statusActionConsequence(status)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          if (isDestructive)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: BrandColors.error,
                side: const BorderSide(color: BrandColors.error),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Отказаться'),
            )
          else
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Подтвердить'),
            ),
        ],
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

class _CenterMessageAction {
  const _CenterMessageAction({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
}

/// Баннер ошибки с кнопкой повтора. Контрастный — читаем на ярком солнце.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.errorBackground,
        borderRadius: BorderRadius.circular(BrandRadius.sm),
        border: Border.all(color: BrandColors.error.withValues(alpha: 0.35)),
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
                  .copyWith(color: BrandColors.error),
            ),
          ),
          if (onRetry != null)
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

/// Проминентный баннер успешной смены статуса с подсказкой и отменой.
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.viewModel});

  final OrderDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final message = viewModel.successMessage;
    if (message == null) return const SizedBox.shrink();

    final canUndo = viewModel.previousStatusId != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.successBackground,
        borderRadius: BorderRadius.circular(BrandRadius.sm),
        border: Border.all(color: BrandColors.greenWeb.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: BrandColors.greenWeb,
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
          if (canUndo)
            TextButton(
              onPressed: () async {
                final undone = await viewModel.undoLastStatusChange();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      undone
                          ? 'Действие отменено'
                          : 'Не удалось отменить действие',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: EdgeInsets.zero,
              ),
              child: const Text('Отменить'),
            ),
        ],
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({
    required this.icon,
    required this.text,
    this.action,
  });

  final IconData icon;
  final String text;
  final _CenterMessageAction? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: BrandColors.grayMid),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: action!.onPressed,
                child: Text(action!.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
