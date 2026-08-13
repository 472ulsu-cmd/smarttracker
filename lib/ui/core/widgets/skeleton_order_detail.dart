import 'package:flutter/material.dart';

import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';
import 'shimmer.dart';

/// Skeleton-экран деталей заявки, зеркально повторяющий структуру
/// информационной карточки, маршрута и фото на экране [OrderDetailScreen].
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
          _SkeletonOrderDetailsCard(),
          SizedBox(height: 16),
          _SkeletonRouteCard(),
          SizedBox(height: 16),
          _SkeletonPhotoRow(),
        ],
      ),
    );
  }
}

/// Skeleton общей карточки: груз со статусом и заказчик.
class _SkeletonOrderDetailsCard extends StatelessWidget {
  const _SkeletonOrderDetailsCard();

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
          // Заголовок груза и статус используют одну строку без пустой шапки.
          Row(
            children: [
              const Expanded(
                child: SkeletonLine(height: 11, widthFraction: 0.2),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: Center(
                  child: Container(
                    width: 96,
                    height: 32,
                    decoration: BoxDecoration(
                      color: BrandColors.grayLighter,
                      borderRadius: BorderRadius.circular(BrandRadius.pill),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Наименование и характеристики груза.
          const SkeletonLine(height: 15, widthFraction: 0.7),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(child: SkeletonLine(height: 13)),
              const SizedBox(width: 20),
              const Expanded(child: SkeletonLine(height: 13)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 16),
            child: Divider(height: 1, color: BrandColors.grayLighter),
          ),
          // Заказчик — последняя, более спокойная группа.
          const SkeletonLine(height: 14, widthFraction: 0.25),
          const SizedBox(height: 8),
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
              const Expanded(
                child: SkeletonLine(height: 15, widthFraction: 0.5),
              ),
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
              const Expanded(
                child: SkeletonLine(height: 16, widthFraction: 0.2),
              ),
              const SizedBox(width: 12),
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
