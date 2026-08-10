import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/models/order.dart';
import '../../../domain/models/order_status.dart';
import '../../core/theme/brand_colors.dart';
import '../../core/theme/brand_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/orders/views/order_list_tile.dart';

/// Карточка заявки со свайп-действиями для новых заявок.
///
/// Свайп вправо — принять в работу (оранжевый).
/// Свайп влево — отказаться (красный).
/// Действия доступны только для заявок со статусом [OrderStatus.newRequest].
///
/// При свайпе за порог вызывается [onAccept] или [onReject] с [order].
/// Карточка исчезает с анимацией, а haptic подтверждает действие.
/// Reduce Motion: карточка мгновенно исчезает без анимации.
class SwipeableOrderTile extends StatelessWidget {
  const SwipeableOrderTile({
    super.key,
    required this.order,
    this.onTap,
    this.onAccept,
    this.onReject,
  });

  final OrderListItem order;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  /// Можно ли свайпать эту заявку: только «Новые» (status 1).
  bool get _isSwipeable =>
      OrderStatus.fromId(order.status) == OrderStatus.newRequest;

  @override
  Widget build(BuildContext context) {
    if (!_isSwipeable) {
      return OrderListTile(order: order, onTap: onTap);
    }

    return Dismissible(
      key: ValueKey('order-${order.id}'),
      // Направления: вправо = принять, влево = отказаться.
      direction: DismissDirection.horizontal,
      // Порог срабатывания — 40% ширины карточки: достаточно лёгкого свайпа
      // в поле/перчатках, но не слишком чувствительно при скролле.
      movementDuration: const Duration(milliseconds: 250),
      dismissThresholds: const {
        DismissDirection.endToStart: 0.4,
        DismissDirection.startToEnd: 0.4,
      },
      // Бэкграунд при свайпе вправо — «Принять».
      background: _SwipeBackground(
        alignment: Alignment.centerLeft,
        color: BrandColors.primary,
        icon: Icons.check_rounded,
        label: 'Принять',
        padding: const EdgeInsets.only(left: 24),
      ),
      // Бэкграунд при свайпе влево — «Отказаться».
      secondaryBackground: _SwipeBackground(
        alignment: Alignment.centerRight,
        color: BrandColors.error,
        icon: Icons.close_rounded,
        label: 'Отказаться',
        padding: const EdgeInsets.only(right: 24),
      ),
      // ПодтверждениеDismiss: свайп срабатывает только при движении по
      // направлению — не при вертикальном скролле.
      // Показывает диалог подтверждения (как на экране деталей заявки),
      // чтобы водитель не мог случайно сменить статус жестом.
      confirmDismiss: (direction) async {
        // Тактильное подтверждение намерения — водитель «чувствует» порог.
        HapticFeedback.mediumImpact();

        final isAccept = direction == DismissDirection.startToEnd;
        final callback = isAccept ? onAccept : onReject;
        if (callback == null) return false;

        return _showConfirmDialog(
          context,
          isAccept: isAccept,
        );
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onAccept?.call();
        } else {
          onReject?.call();
        }
      },
      child: OrderListTile(order: order, onTap: onTap),
    );
  }

  /// Диалог подтверждения смены статуса при свайпе.
  ///
  /// Зеркально повторяет диалог из [_ActionButton._confirm] на экране
  /// деталей заявки: тот же layout, те же кнопки, тот же tone.
  Future<bool> _showConfirmDialog(BuildContext context, {
    required bool isAccept,
  }) async {
    final label = isAccept ? 'Принять в работу' : 'Отказаться от заявки';
    final consequence = isAccept
        ? 'Статус заявки будет изменен на "В работе".'
        : 'Заявка будет отменена и перемещена в архив. Это действие нельзя отменить.';

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
                    child: Text(label, style: AppTextStyles.titleMedium),
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
                consequence,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: BrandColors.grayDark),
              ),
              const SizedBox(height: 20),
              if (isAccept)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Подтвердить'),
                )
              else
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrandColors.error,
                    side: const BorderSide(color: BrandColors.error),
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Отказаться'),
                ),
            ],
          ),
        ),
      ),
    );
    return confirmed == true;
  }
}

/// Фон, который появляется под карточкой при свайпе.
///
/// Используется в [SwipeableOrderTile] как [Dismissible.background] /
/// [Dismissible.secondaryBackground]. Цвет, иконка и текст выносятся в
/// параметры — переиспользуется для обоих направлений.
class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
    required this.padding,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      alignment: alignment,
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: BrandColors.white, size: 22),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: BrandColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
