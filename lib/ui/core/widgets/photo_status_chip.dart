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
///
/// При смене статуса фон плавно перекрашивается ([AnimatedContainer]),
/// а метка сменяется через [AnimatedSwitcher] с лёгкой spring-посадкой —
/// симметрично с [StatusChip]. Reduce Motion honoured.
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
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'Статус: ${status.label}',
      child: AnimatedContainer(
        duration: reduceMotion
            ? Duration.zero
            : const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BrandRadius.pill),
        ),
        child: AnimatedSwitcher(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) {
            if (reduceMotion) return child;
            return FadeTransition(
              opacity: anim,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            key: ValueKey(status),
            status.label,
            style: AppTextStyles.labelMedium.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}
