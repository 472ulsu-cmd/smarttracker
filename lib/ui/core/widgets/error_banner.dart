import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Баннер ошибки: иконка + тонированный фон + текст + опциональный повтор.
///
/// Ошибка считывается «не только цветом» (иконка и фон дублируют смысл) —
/// важно при работе на ярком солнце. Текст — [BrandColors.errorText]:
/// пара с [BrandColors.errorBackground] даёт контраст ≥4.5:1 (WCAG AA).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onRetry});

  final String message;

  /// Кнопка «Повторить» (если действие можно перезапустить).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Ошибка. $message',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: BrandColors.errorBackground,
          borderRadius: BorderRadius.circular(BrandRadius.sm),
          border: Border.all(color: BrandColors.error.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: BrandColors.error, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: BrandColors.errorText),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Повторить'),
              ),
          ],
        ),
      ),
    );
  }
}
