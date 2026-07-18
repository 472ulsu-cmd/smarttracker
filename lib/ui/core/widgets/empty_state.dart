import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';

/// Центрированное состояние пустого списка/экрана:
/// иконка, текст, опциональная подсказка и кнопка действия.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.text,
    this.icon,
    this.iconColor = BrandColors.grayMid,
    this.hint,
    this.actionLabel,
    this.onAction,
  });

  /// Иконка сверху; null — без иконки.
  final IconData? icon;

  /// Цвет иконки.
  final Color iconColor;

  /// Основной текст состояния.
  final String text;

  /// Дополнительная подсказка под основным текстом.
  final String? hint;

  /// Подпись кнопки действия (показывается вместе с [onAction]).
  final String? actionLabel;

  /// Обработчик кнопки действия.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 56, color: iconColor),
              const SizedBox(height: 12),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            if (hint != null) ...[
              const SizedBox(height: 8),
              Text(
                hint!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall
                    .copyWith(color: BrandColors.grayDark),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
