import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/models/order.dart';
import '../../../domain/models/order_status.dart';
import '../../core/theme/brand_colors.dart';
import '../../core/theme/brand_radius.dart';
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
      confirmDismiss: (direction) {
        // Тактильное подтверждение намерения — водитель «чувствует» порог.
        HapticFeedback.mediumImpact();
        return Future.value(direction == DismissDirection.startToEnd
            ? onAccept != null
            : onReject != null);
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
