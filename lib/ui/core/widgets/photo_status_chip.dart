import 'package:flutter/material.dart';

import '../../../domain/models/order_photo.dart';
import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Чип статуса фото заявки (одобрено / отклонено / на рассмотрении).
///
/// Использует те же контрастные пары токенов, что и [StatusChip]
/// статуса заявки: текст никогда не бывает цветом статуса (≥4.5:1),
/// статус не зависит только от цвета.
class PhotoStatusChip extends StatelessWidget {
  const PhotoStatusChip({super.key, required this.status});

  final OrderPhotoStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      OrderPhotoStatus.approved => (
          BrandColors.statusCompletedBackground,
          BrandColors.statusCompletedForeground,
        ),
      OrderPhotoStatus.rejected => (
          BrandColors.statusRejectedBackground,
          BrandColors.statusRejectedForeground,
        ),
      OrderPhotoStatus.pending => (
          BrandColors.grayLighter,
          BrandColors.grayDark,
        ),
    };
    return Semantics(
      label: 'Статус: ${status.label}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BrandRadius.pill),
        ),
        child: Text(
          status.label,
          style: AppTextStyles.labelMedium.copyWith(color: fg),
        ),
      ),
    );
  }
}
