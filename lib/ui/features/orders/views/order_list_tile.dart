import 'package:flutter/material.dart';

import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/status_chip.dart';

/// Карточка одной заявки в списке.
class OrderListTile extends StatelessWidget {
  const OrderListTile({super.key, required this.order, this.onTap});

  final OrderListItem order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final routeText = order.route.isEmpty
        ? (order.routeFrom.isEmpty && order.routeTo.isEmpty
            ? 'Маршрут не указан'
            : '${order.routeFrom} → ${order.routeTo}')
        : order.route;
    final statusLabel = OrderStatus.listLabelForId(order.status);

    return MergeSemantics(
      child: Material(
        color: BrandColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: BrandColors.grayLighter),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('№ ${order.num}', style: AppTextStyles.titleMedium),
                    if (statusLabel != null)
                      StatusChip(statusId: order.status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.route_rounded,
                        size: 22,
                        color: BrandColors.primary,
                        semanticLabel: 'Маршрут'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        routeText,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _DateChip(
                        icon: Icons.event_outlined,
                        text: DateFormatUtil.date(order.loadingDate),
                        label: 'Погрузка',
                        semanticLabel: 'Дата погрузки'),
                    const SizedBox(width: 12),
                    _DateChip(
                        icon: Icons.flag_outlined,
                        text: DateFormatUtil.date(order.unloadingDate),
                        label: 'Разгрузка',
                        semanticLabel: 'Дата разгрузки'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.icon,
    required this.text,
    required this.label,
    this.semanticLabel,
  });

  final IconData icon;
  final String text;
  final String label;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 15, color: BrandColors.grayMid, semanticLabel: semanticLabel),
        const SizedBox(width: 4),
        Text('$label: $text',
            style:
                AppTextStyles.bodySmall.copyWith(color: BrandColors.grayDark)),
      ],
    );
  }
}
