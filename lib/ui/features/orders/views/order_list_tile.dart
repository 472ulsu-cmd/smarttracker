import 'package:flutter/material.dart';

import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/status_chip.dart';

/// Карточка одной заявки в списке.
class OrderListTile extends StatelessWidget {
  const OrderListTile({
    super.key,
    required this.order,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.isLoading = false,
  });

  final OrderListItem order;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final routeText = order.route.isEmpty
        ? (order.routeFrom.isEmpty && order.routeTo.isEmpty
            ? 'Маршрут не указан'
            : '${order.routeFrom} → ${order.routeTo}')
        : order.route;
    final statusLabel = OrderStatus.listLabelForId(order.status);
    final showActions = onAccept != null && onReject != null;

    final content = Padding(
      padding: const EdgeInsets.all(16),
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
    );

    return Container(
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showActions)
            InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(BrandRadius.md),
              ),
              child: content,
            )
          else
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(BrandRadius.md),
              child: content,
            ),
          if (showActions) ...[
            const Divider(height: 1, color: BrandColors.grayLighter),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: isLoading ? null : onReject,
                      child: const Text('Отказаться'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: isLoading ? null : onAccept,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: BrandColors.white,
                              ),
                            )
                          : const Text('Принять'),
                    ),
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
