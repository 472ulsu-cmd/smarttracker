import 'package:flutter/material.dart';

/// Градиентный shimmer-эффект для skeleton-загрузки.
///
/// Не требует внешних пакетов — реализован на [ShaderMask] с линейным
/// градиентом, который анимируется по горизонтали. Reduce Motion:
/// shimmer-эффект отключается — плейсхолдеры отображаются статично.
///
/// Использование: обернуть любой виджет (серые плашки, контейнеры) в
/// [Shimmer] — и он начнёт «блестеть».
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1400),
  });

  /// Виджет-потомок (обычно серые плашки-плейсхолдеры).
  final Widget child;

  /// Базовый цвет (фон shimmer).
  /// По умолчанию — [BrandColors.grayLighter].
  final Color? baseColor;

  /// Цвет «блика».
  /// По умолчанию — [BrandColors.white].
  final Color? highlightColor;

  /// Длительность одного цикла анимации.
  final Duration duration;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      // Reduce Motion: без анимации — статичные плашки.
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final base = widget.baseColor ?? const Color(0xFFDAE0E5);
            final highlight = widget.highlightColor ?? const Color(0xFFFFFFFF);
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              // Градиент движется слева направо и обратно.
              colors: [base, highlight, base],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}

/// Одна серая плашка-плейсхолдер для строки текста.
///
/// Ширина задана как [widthFraction] от родительского контейнера.
/// Высота — фиксированная [height]. Скругление — 4px.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({
    super.key,
    this.widthFraction = 1.0,
    this.height = 14,
  });

  /// Доля ширины родителя (0.0–1.0).
  final double widthFraction;

  /// Высота плашки в пикселях.
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFraction.clamp(0.0, 1.0),
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFDAE0E5),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
