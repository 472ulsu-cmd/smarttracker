import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';

/// Контекстный coach mark: затемняет экран и оставляет активным только
/// реальный элемент, которому посвящена подсказка.
class SpotlightCoach extends StatefulWidget {
  const SpotlightCoach({
    super.key,
    required this.child,
    required this.visible,
    required this.targetKey,
    required this.message,
    required this.onDismiss,
    this.targetPadding = const EdgeInsets.all(6),
  });

  final Widget child;
  final bool visible;
  final GlobalKey targetKey;
  final String message;
  final VoidCallback onDismiss;
  final EdgeInsets targetPadding;

  @override
  State<SpotlightCoach> createState() => _SpotlightCoachState();
}

class _SpotlightCoachState extends State<SpotlightCoach> {
  final GlobalKey _containerKey = GlobalKey();
  final List<Timer> _measurementTimers = [];
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    _queueMeasurements();
  }

  @override
  void didUpdateWidget(covariant SpotlightCoach oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.visible) {
      _cancelMeasurements();
      _targetRect = null;
      return;
    }
    if (oldWidget.targetKey != widget.targetKey) {
      _targetRect = null;
    }
    // Контент и прокрутка могут измениться при том же targetKey, поэтому
    // измеряем при каждой перестройке видимого шага.
    _queueMeasurements();
  }

  void _queueMeasurements() {
    _cancelMeasurements();
    if (!widget.visible) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTarget());
    for (final delay in const [
      Duration(milliseconds: 90),
      Duration(milliseconds: 220),
      Duration(milliseconds: 420),
    ]) {
      _measurementTimers.add(Timer(delay, _measureTarget));
    }
  }

  void _cancelMeasurements() {
    for (final timer in _measurementTimers) {
      timer.cancel();
    }
    _measurementTimers.clear();
  }

  void _measureTarget() {
    if (!mounted || !widget.visible) return;
    final containerObject = _containerKey.currentContext?.findRenderObject();
    final targetObject = widget.targetKey.currentContext?.findRenderObject();
    if (containerObject is! RenderBox ||
        targetObject is! RenderBox ||
        !containerObject.hasSize ||
        !targetObject.hasSize) {
      return;
    }

    final offset = targetObject.localToGlobal(
      Offset.zero,
      ancestor: containerObject,
    );
    final padding = widget.targetPadding;
    final bounds = Offset.zero & containerObject.size;
    final measured = Rect.fromLTRB(
      offset.dx - padding.left,
      offset.dy - padding.top,
      offset.dx + targetObject.size.width + padding.right,
      offset.dy + targetObject.size.height + padding.bottom,
    ).intersect(bounds);
    if (measured.isEmpty || _rectsAreClose(_targetRect, measured)) return;
    setState(() => _targetRect = measured);
  }

  bool _rectsAreClose(Rect? a, Rect b) {
    if (a == null) return false;
    const tolerance = 0.5;
    return (a.left - b.left).abs() < tolerance &&
        (a.top - b.top).abs() < tolerance &&
        (a.right - b.right).abs() < tolerance &&
        (a.bottom - b.bottom).abs() < tolerance;
  }

  @override
  void dispose() {
    _cancelMeasurements();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _containerKey,
      fit: StackFit.expand,
      children: [
        widget.child,
        if (widget.visible && _targetRect != null)
          Positioned.fill(
            child: _SpotlightOverlay(
              targetRect: _targetRect!,
              message: widget.message,
              onDismiss: widget.onDismiss,
            ),
          ),
      ],
    );
  }
}

class _SpotlightOverlay extends StatelessWidget {
  const _SpotlightOverlay({
    required this.targetRect,
    required this.message,
    required this.onDismiss,
  });

  final Rect targetRect;
  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final bubbleWidth = math.min(360.0, size.width - 32);
        final bubbleLeft = (size.width - bubbleWidth) / 2;
        final spaceBelow = size.height - targetRect.bottom;
        final placeBelow = spaceBelow >= 132 || targetRect.top < 132;

        return Semantics(
          container: true,
          liveRegion: true,
          label: message,
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _SpotlightPainter(targetRect)),
                ),
              ),
              if (targetRect.top > 0)
                _DismissArea(
                  left: 0,
                  top: 0,
                  width: size.width,
                  height: targetRect.top,
                  onDismiss: onDismiss,
                ),
              if (targetRect.bottom < size.height)
                _DismissArea(
                  left: 0,
                  top: targetRect.bottom,
                  width: size.width,
                  height: size.height - targetRect.bottom,
                  onDismiss: onDismiss,
                ),
              if (targetRect.left > 0)
                _DismissArea(
                  left: 0,
                  top: targetRect.top,
                  width: targetRect.left,
                  height: targetRect.height,
                  onDismiss: onDismiss,
                ),
              if (targetRect.right < size.width)
                _DismissArea(
                  left: targetRect.right,
                  top: targetRect.top,
                  width: size.width - targetRect.right,
                  height: targetRect.height,
                  onDismiss: onDismiss,
                ),
              Positioned(
                left: bubbleLeft,
                width: bubbleWidth,
                top: placeBelow ? targetRect.bottom + 16 : 16,
                bottom: placeBelow ? 16 : size.height - targetRect.top + 16,
                child: Align(
                  alignment: placeBelow
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    reverse: !placeBelow,
                    child: _CoachBubble(message: message, onDismiss: onDismiss),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DismissArea extends StatelessWidget {
  const _DismissArea({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onDismiss,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
      ),
    );
  }
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BrandColors.graphite,
      borderRadius: BorderRadius.circular(BrandRadius.md),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: BrandColors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onDismiss,
              style: TextButton.styleFrom(
                foregroundColor: BrandColors.primaryLight2,
                minimumSize: const Size(48, 48),
              ),
              child: const Text('Понятно'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter(this.targetRect);

  final Rect targetRect;

  @override
  void paint(Canvas canvas, Size size) {
    final mask = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(
        RRect.fromRectAndRadius(
          targetRect,
          const Radius.circular(BrandRadius.md),
        ),
      );
    canvas.drawPath(mask, Paint()..color = const Color(0xB825252A));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        targetRect,
        const Radius.circular(BrandRadius.md),
      ),
      Paint()
        ..color = BrandColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect;
  }
}
