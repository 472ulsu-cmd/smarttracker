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
                    Expanded(
                      child: Text(
                        '№ ${order.num}',
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (statusLabel != null)
                      StatusChip(statusId: order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.route_rounded,
                        size: 22,
                        color: BrandColors.primary,
                        semanticLabel: 'Маршрут'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$routeText · ${DateFormatUtil.date(order.loadingDate)} — ${DateFormatUtil.date(order.unloadingDate)}',
                        style: AppTextStyles.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
