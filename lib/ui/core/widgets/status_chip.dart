import 'package:flutter/material.dart';

import '../../../domain/models/order_status.dart';
import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Цветной «чип» статуса заявки.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.statusId});

  final int statusId;

  @override
  Widget build(BuildContext context) {
    final label = _labelFor(statusId);
    return Semantics(
      label: 'Статус заявки: $label',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _backgroundColorFor(statusId),
              borderRadius: BorderRadius.circular(BrandRadius.pill),
            ),
            child: ExcludeSemantics(
              child: Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: _foregroundColorFor(statusId),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Короткая метка чипа статуса (в списках и деталях — краткая форма).
String _labelFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return 'Новая';
    case OrderStatus.inProgress:
      return 'В работе';
    case OrderStatus.rejected:
      return 'Отказ';
    case OrderStatus.completed:
      return 'Завершена';
    case OrderStatus.loaded:
      return 'Погружен';
    case null:
      return 'Неизвестно';
  }
}

/// Фон чипа статуса — светлый оттенок статусного цвета, доступный для текста.
Color _backgroundColorFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return BrandColors.statusNewBackground;
    case OrderStatus.inProgress:
    case OrderStatus.loaded:
      return BrandColors.statusInProgressBackground;
    case OrderStatus.rejected:
      return BrandColors.statusRejectedBackground;
    case OrderStatus.completed:
      return BrandColors.statusCompletedBackground;
    case null:
      return BrandColors.grayLighter;
  }
}

/// Цвет текста чипа статуса — тёмный оттенок статусного цвета с контрастом ≥4.5:1.
Color _foregroundColorFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return BrandColors.statusNewForeground;
    case OrderStatus.inProgress:
    case OrderStatus.loaded:
      return BrandColors.statusInProgressForeground;
    case OrderStatus.rejected:
      return BrandColors.statusRejectedForeground;
    case OrderStatus.completed:
      return BrandColors.statusCompletedForeground;
    case null:
      return BrandColors.grayDark;
  }
}
