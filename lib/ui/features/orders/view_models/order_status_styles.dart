import 'package:flutter/material.dart';

import '../../../core/theme/brand_colors.dart';
import '../../../../domain/models/order_status.dart';

/// Цветовое оформление статуса заявки для UI.
class OrderStatusStyle {
  const OrderStatusStyle({required this.label, required this.color});

  final String label;
  final Color color;

  static OrderStatusStyle forStatus(int statusId) {
    switch (OrderStatus.fromId(statusId)) {
      case OrderStatus.newRequest:
        return const OrderStatusStyle(label: 'Новая', color: BrandColors.blue);
      case OrderStatus.inProgress:
        return const OrderStatusStyle(
            label: 'В работе', color: BrandColors.primary);
      case OrderStatus.rejected:
        return const OrderStatusStyle(
            label: 'Отказ', color: BrandColors.error);
      case OrderStatus.completed:
        return const OrderStatusStyle(
            label: 'Завершена', color: BrandColors.greenWeb);
      case OrderStatus.loaded:
        return const OrderStatusStyle(
            label: 'Погружен', color: BrandColors.primaryLight1);
      case null:
        return const OrderStatusStyle(
            label: 'Неизвестно', color: BrandColors.grayMid);
    }
  }

  /// Фон чипа статуса — светлый оттенок статусного цвета, доступный для текста.
  static Color backgroundColorFor(int statusId) {
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
  static Color foregroundColorFor(int statusId) {
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
}
