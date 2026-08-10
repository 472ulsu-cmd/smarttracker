import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';
import 'shimmer.dart';

/// Skeleton-карточка, зеркально повторяющая [OrderListTile].
///
/// Структура:
///   Row: [номер заявки (titleMedium ~16px)] — [status chip (pill)]
///   Row: [route icon 22px] [маршрут — 2 строки]
///   Row: [date icon 18px] [дата]
///   Divider
///   Row: [client icon 20px] [заказчик]
class SkeletonOrderTile extends StatelessWidget {
  const SkeletonOrderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: BrandColors.white,
          border: Border.all(color: BrandColors.grayLighter),
          borderRadius: BorderRadius.circular(BrandRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Номер + чип статуса
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Номер заявки — titleMedium ≈ 16px, 50% ширины
                      const SkeletonLine(widthFraction: 0.35, height: 16),
                      // Status chip — pill, ~60px × 24px
                      Container(
                        width: 64,
                        height: 24,
                        decoration: BoxDecoration(
                          color: BrandColors.grayLighter,
                          borderRadius: BorderRadius.circular(BrandRadius.pill),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Маршрут — 2 строки, bodyLarge ≈ 16px
                  Row(
                    children: [
                      // Route icon placeholder — 22px circle
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: BrandColors.grayLighter,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(height: 16),
                            SizedBox(height: 4),
                            SkeletonLine(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Дата — bodySmall ≈ 13px
                  Row(
                    children: [
                      // Date icon placeholder — 18px circle
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: BrandColors.grayLighter,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: SkeletonLine(height: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Клиентский раздел (divider + row)
            const Divider(height: 1, color: BrandColors.grayLighter),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Business icon placeholder — 20px circle
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: BrandColors.grayLighter,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: SkeletonLine(height: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
