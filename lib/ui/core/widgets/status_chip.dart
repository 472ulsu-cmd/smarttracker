import 'package:flutter/material.dart';

import '../../../domain/models/order_status.dart';
import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Цветной «чип» статуса заявки.
///
/// При смене статуса чип морфится: фон и текст плавно перекрашиваются,
/// а метка сменяется через AnimatedSwitcher с лёгкой spring-посадкой —
/// переход ощущается как щелчок переключателя, а не как мгновенная замена.
/// Reduce Motion honoured: при `disableAnimations` смена мгновенная.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.statusId});

  final int statusId;

  @override
  Widget build(BuildContext context) {
    final label = _labelFor(statusId);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final backgroundColor = statusBackgroundColorFor(statusId);
    final foregroundColor = _foregroundColorFor(statusId);

    return Semantics(
      label: 'Статус заявки: $label',
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          child: AnimatedSwitcher(
            // easeOutBack даёт «приземление» с лёгким перелётом — физика
            // переключателя. При reduceMotion Duration.zero → мгновенно.
            duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) {
              if (reduceMotion) return child;
              // Лёгкая вертикальная посадка + фейд: метка «опускается» на место.
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
            // Key по статусу — триггер смены при переходе.
            child: _ChipBody(
              key: ValueKey(statusId),
              label: label,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Внутреннее тело чипа: плавный перекрос фона/текста при смене статуса.
class _ChipBody extends StatelessWidget {
  const _ChipBody({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(BrandRadius.pill),
      ),
      child: ExcludeSemantics(
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}

/// Короткая метка чипа статуса (в списках и деталях — краткая форма).
String _labelFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return 'Новая';
    case OrderStatus.inProgress:
      return 'В работе';
    case OrderStatus.rejected:
      return 'Отказ';
    case OrderStatus.completed:
      return 'Завершена';
    case OrderStatus.loaded:
      return 'Погружен';
    case null:
      return 'Неизвестно';
  }
}

/// Фон чипа статуса — светлый оттенок статусного цвета, доступный для текста.
///
/// Публичная, чтобы карточка заявки ([OrderListTile]) использовала тот же
/// маппинг для тонкой статус-полосы на левом крае — единый источник статусов.
Color statusBackgroundColorFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return BrandColors.statusNewBackground;
    case OrderStatus.inProgress:
      return BrandColors.statusInProgressBackground;
    case OrderStatus.loaded:
      return BrandColors.statusLoadedBackground;
    case OrderStatus.rejected:
      return BrandColors.statusRejectedBackground;
    case OrderStatus.completed:
      return BrandColors.statusCompletedBackground;
    case null:
      return BrandColors.grayLighter;
  }
}

/// Цвет текста чипа статуса — тёмный оттенок статусного цвета с контрастом ≥4.5:1.
Color _foregroundColorFor(int statusId) {
  switch (OrderStatus.fromId(statusId)) {
    case OrderStatus.newRequest:
      return BrandColors.statusNewForeground;
    case OrderStatus.inProgress:
      return BrandColors.statusInProgressForeground;
    case OrderStatus.loaded:
      return BrandColors.statusLoadedForeground;
    case OrderStatus.rejected:
      return BrandColors.statusRejectedForeground;
    case OrderStatus.completed:
      return BrandColors.statusCompletedForeground;
    case null:
      return BrandColors.grayDark;
  }
}
