import 'package:flutter/material.dart';

import '../../features/orders/view_models/order_status_styles.dart';
import '../theme/app_text_styles.dart';
import '../theme/brand_radius.dart';

/// Цветной «чип» статуса заявки.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.statusId});

  final int statusId;

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusStyle.forStatus(statusId);
    return Semantics(
      label: 'Статус заявки: ${style.label}',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: OrderStatusStyle.backgroundColorFor(statusId),
              borderRadius: BorderRadius.circular(BrandRadius.pill),
            ),
            child: ExcludeSemantics(
              child: Text(
                style.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: OrderStatusStyle.foregroundColorFor(statusId),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
