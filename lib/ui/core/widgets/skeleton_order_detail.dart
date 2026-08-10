import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';
import 'shimmer.dart';

/// Skeleton-экран деталей заявки, зеркально повторяющий структуру
/// [_Summary], [_ClientCard], [_RouteCard] на экране [OrderDetailScreen].
///
/// Вместо одного [CircularProgressIndicator] показывается реалистичный
/// layout-скелет, чтобы водитель видит «форму» будущих данных.
class SkeletonOrderDetail extends StatelessWidget {
  const SkeletonOrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SkeletonSummary(),
          SizedBox(height: 16),
          _SkeletonClientCard(),
          SizedBox(height: 16),
          _SkeletonRouteCard(),
          SizedBox(height: 16),
          _SkeletonPhotoRow(),
        ],
      ),
    );
  }
}

/// Skeleton для [_Summary]: номер, чип, маршрут, info-поля.
class _SkeletonSummary extends StatelessWidget {
  const _SkeletonSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Номер (titleLarge ~20px) + status chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLine(height: 20, widthFraction: 0.4),
              Container(
                width: 72,
                height: 26,
                decoration: BoxDecoration(
                  color: BrandColors.grayLighter,
                  borderRadius: BorderRadius.circular(BrandRadius.pill),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Маршрут — route icon + 2 строки
          Row(
            children: [
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
          const SizedBox(height: 12),
          // Info items: Груз / Масса / Объём
          Row(
            children: [
              const Expanded(child: SkeletonLine(height: 11)),
              const SizedBox(width: 12),
              const Expanded(child: SkeletonLine(height: 15)),
              const SizedBox(width: 12),
              const Expanded(child: SkeletonLine(height: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton для [_ClientCard]: заголовок + строки org/manager/phone.
class _SkeletonClientCard extends StatelessWidget {
  const _SkeletonClientCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок «Заказчик» — titleMedium ~16px
          const SkeletonLine(height: 16, widthFraction: 0.25),
          const SizedBox(height: 8),
          // Org row
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: BrandColors.grayLighter,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SkeletonLine(height: 15)),
            ],
          ),
          const SizedBox(height: 4),
          // Manager row
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: BrandColors.grayLighter,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SkeletonLine(height: 15)),
            ],
          ),
          const SizedBox(height: 4),
          // Phone row
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: BrandColors.grayLighter,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SkeletonLine(height: 15, widthFraction: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton для [_RouteCard]: заголовок + 2 route points.
class _SkeletonRouteCard extends StatelessWidget {
  const _SkeletonRouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок + кнопка «Подробнее»
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLine(height: 16, widthFraction: 0.2),
              Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  color: BrandColors.grayLighter,
                  borderRadius: BorderRadius.circular(BrandRadius.sm),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Route point 1 — loading
          _buildRoutePoint(),
          const Divider(height: 1, color: BrandColors.grayLighter),
          // Route point 2 — unloading
          _buildRoutePoint(),
        ],
      ),
    );
  }

  Widget _buildRoutePoint() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot — 12px circle
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: BrandColors.grayLighter,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(height: 15),
                SizedBox(height: 2),
                SkeletonLine(height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton для строки «Фото по заявке» (ListTile-подобная).
class _SkeletonPhotoRow extends StatelessWidget {
  const _SkeletonPhotoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Camera icon placeholder — 24px circle
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: BrandColors.grayLighter,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(child: SkeletonLine(height: 16)),
        // Chevron placeholder
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: BrandColors.grayLighter,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
