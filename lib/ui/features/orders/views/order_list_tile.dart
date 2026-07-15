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
  });

  final OrderListItem order;
  final VoidCallback? onTap;

  bool get _hasRouteDates =>
      order.loadingDate.isNotEmpty || order.unloadingDate.isNotEmpty;

  String get _dateRangeText {
    final loading = DateFormatUtil.date(order.loadingDate);
    final unloading = DateFormatUtil.date(order.unloadingDate);
    if (loading.isNotEmpty && unloading.isNotEmpty) {
      return 'Погрузка: $loading — разгрузка: $unloading';
    }
    if (loading.isNotEmpty) {
      return 'Погрузка: $loading';
    }
    return 'Разгрузка: $unloading';
  }

  @override
  Widget build(BuildContext context) {
    final routeText = order.route.isEmpty
        ? (order.routeFrom.isEmpty && order.routeTo.isEmpty
            ? 'Маршрут не указан'
            : '${order.routeFrom} → ${order.routeTo}')
        : order.route;
    final statusLabel = OrderStatus.listLabelForId(order.status);

    return Container(
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BrandRadius.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                          routeText,
                          style: AppTextStyles.bodyLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_hasRouteDates) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.event_outlined,
                            size: 18,
                            color: BrandColors.grayMid,
                            semanticLabel: 'Даты'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _dateRangeText,
                            style: AppTextStyles.bodySmall
                                .copyWith(color: BrandColors.grayDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (order.client.org.isNotEmpty) ...[
              const Divider(height: 1, color: BrandColors.grayLighter),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.business_outlined,
                      size: 20,
                      color: BrandColors.grayMid,
                      semanticLabel: 'Заказчик',
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Заказчик: ${order.client.org}',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: BrandColors.graphite),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
