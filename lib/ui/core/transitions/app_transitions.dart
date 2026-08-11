import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Утилиты для создания единообразных переходов между экранами.
///
/// Все переходы уважают [MediaQuery.disableAnimationsOf]: при включённом
/// Reduce Motion вместо анимации используется мгновенная смена (crossfade
/// с нулевой длительностью).
///
/// Стиль переходов выстроен по Material Motion:
/// - **Container transform** (Hero) — карточка → детали: контент «переезжает».
/// - **Shared axis** — навигация вперёд/назад по стеку: слайд по оси X.
/// - **Fade through** — переключение между равноправными экранами.
class AppTransitions {
  AppTransitions._();

  // --- Длительности и кривые ---

  /// Длительность основного page transition (вход + выход).
  static const Duration duration = Duration(milliseconds: 300);

  /// Длительность fade-through (переключение равноправных экранов).
  static const Duration fadeThroughDuration = Duration(milliseconds: 200);

  /// Длительность Hero-перелёта (длиннее — чтобы глаз успел «поехать»).
  static const Duration heroFlightDuration = Duration(milliseconds: 350);

  /// Основная кривая: ease-out — быстрый старт, мягкая посадка.
  static const Curve standardCurve = Curves.easeOutCubic;

  /// Обратная кривая: ease-in — мягкий старт, быстрый уход.
  static const Curve reverseCurve = Curves.easeInCubic;

  // --- CustomTransitionPage ---

  /// Стандартный page transition: вперёд — слайд справа, назад — слайд влево.
  /// Поверх стандартного Material Cupertino-style, но с нашими кривыми.
  ///
  /// Используется для навигации по стеку: список → детали → маршрут → фото.
  static CustomTransitionPage<void> slide({
    required Widget child,
    bool reverse = false,
  }) {
    return CustomTransitionPage<void>(
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      barrierDismissible: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        if (reduceMotion) return child;

        // Основная анимация: слайд по горизонтали + fade.
        final slide = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: standardCurve));

        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: standardCurve));

        // Фоновый экран: слегка сдвигается влево и приглушается.
        final secondarySlide = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.05, 0),
        ).chain(CurveTween(curve: standardCurve));

        final secondaryFade = Tween<double>(
          begin: 1.0,
          end: 0.85,
        ).chain(CurveTween(curve: standardCurve));

        return SlideTransition(
          position: slide.animate(animation),
          child: FadeTransition(
            opacity: fade.animate(animation),
            child: SlideTransition(
              position: secondarySlide.animate(secondaryAnimation),
              child: FadeTransition(
                opacity: secondaryFade.animate(secondaryAnimation),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Fade-through: используется для переходов между «равноправными»
  /// экранами (редко — в нашем приложении большинство переходов иерархические).
  static CustomTransitionPage<void> fadeThrough({
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      child: child,
      transitionDuration: fadeThroughDuration,
      reverseTransitionDuration: fadeThroughDuration,
      barrierDismissible: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        if (reduceMotion) return child;

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: standardCurve,
          ),
          child: child,
        );
      },
    );
  }

  // --- Hero-обёртки ---

  /// Обёртка для Hero-элемента «номер заявки».
  ///
  /// Используется в [OrderListTile] и [_Summary] на экране деталей.
  /// Номер заказа «переезжает» из карточки списка в заголовок деталей.
  static Widget heroOrderNumber({
    required int orderId,
    required String orderNum,
    required TextStyle style,
    Key? key,
  }) {
    return Hero(
      tag: 'order-num-$orderId',
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return _OrderNumberShuttle(
          animation: animation,
          fromContext: fromHeroContext,
          toContext: toHeroContext,
        );
      },
      child: Text(
        '№ $orderNum',
        key: key,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Обёртка для Hero-элемента «чип статуса».
  ///
  /// StatusChip внутри Hero не анимируется через AnimatedSwitcher во время
  /// полёта — используется [_StatusChipShuttle], который подменяет виджет
  /// на простой Container с текущим цветом статуса.
  static Widget heroStatusChip({
    required int orderId,
    required int statusId,
    required Widget chip,
  }) {
    return Hero(
      tag: 'order-status-$orderId',
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return _StatusChipShuttle(
          toContext: toHeroContext,
        );
      },
      child: KeyedSubtree(key: ValueKey('status-$statusId'), child: chip),
    );
  }
}

// --- Кастомные shuttles для Hero ---

/// Shuttle для номера заявки: плавно масштабирует текст между
/// titleMedium (список) и titleLarge (детали), добавляя fade.
class _OrderNumberShuttle extends StatelessWidget {
  const _OrderNumberShuttle({
    required this.animation,
    required this.fromContext,
    required this.toContext,
  });

  final Animation<double> animation;
  final BuildContext fromContext;
  final BuildContext toContext;

  @override
  Widget build(BuildContext context) {
    // Выбираем стили исходного и целевого виджетов.
    final from = fromContext.widget as Text;
    final to = toContext.widget as Text;

    // Fade: исходный исчезает, целевой появляется в середине полёта.
    final fadeOut = Tween<double>(begin: 1.0, end: 0.0).chain(
      CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );
    final fadeIn = Tween<double>(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Opacity(
              opacity: fadeOut.evaluate(animation),
              child: Text(
                from.data ?? '',
                style: from.style,
                maxLines: from.maxLines,
                overflow: from.overflow,
              ),
            ),
            Opacity(
              opacity: fadeIn.evaluate(animation),
              child: Text(
                to.data ?? '',
                style: to.style,
                maxLines: to.maxLines,
                overflow: to.overflow,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Shuttle для StatusChip: во время Hero-полёта AnimatedSwitcher внутри
/// StatusChip отключается — показывается простой Container с текущим цветом.
class _StatusChipShuttle extends StatelessWidget {
  const _StatusChipShuttle({
    required this.toContext,
  });

  final BuildContext toContext;

  @override
  Widget build(BuildContext context) {
    // Просто подменяем на целевой виджет — StatusChip сам анимирует
    // смену статуса после посадки Hero.
    return toContext.widget;
  }
}
