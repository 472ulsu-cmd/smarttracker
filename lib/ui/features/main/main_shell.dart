import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../config/service_locator.dart';
import '../../features/notifications/view_models/notifications_view_model.dart';
import '../../features/notifications/view_models/unread_badge_view_model.dart';

/// Каркас с нижней навигацией: Заявки, Уведомления, Профиль.
///
/// Использует StatefulNavigationShell из go_router (StatefulShellRoute)
/// для сохранения состояния каждой вкладки.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    // Предзагрузка уведомлений сразу после входа: ветка «Уведомления»
    // строится лениво (IndexedStack), поэтому без явного вызова здесь список
    // остался бы пустым до первого открытия вкладки. VM — singleton, данные
    // переживут переходы.
    getIt<NotificationsViewModel>().load();
    // Подписываем бейдж на NotificationsViewModel и синхронизируем count.
    // Бейдж — проекция VM, поэтому мгновенно реагирует на markAsRead/
    // markAllRead, а не только на полный refresh при перезаходе на вкладку.
    getIt<UnreadBadgeViewModel>().syncFromNotifications();
  }

  void _onDestinationSelected(int index) {
    // При переходе на вкладку уведомлений — подсосём свежие данные
    // (бейдж обновится автоматически через подписку на VM).
    if (index == _notificationsTabIndex) {
      getIt<NotificationsViewModel>().load();
    }
    // Тактиль подтверждает смену вкладки — заметно в поле, при тряске,
    // не глядя на индикатор. selectionClick — мягче статуса/фото, чтобы
    // не конкурировать с ними по «весу».
    HapticFeedback.selectionClick();
    widget.navigationShell.goBranch(
      index,
      // Если вкладка уже активна — вернуться в начало стека.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  /// Индекс вкладки уведомлений в нижней навигации.
  static const _notificationsTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navigationShell = widget.navigationShell;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        elevation: theme.bottomNavigationBarTheme.elevation ?? 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined),
            // Spring-pop при активации вкладки: иконка «выпрыгивает»
            // (scale 0.8→1.0, easeOutBack). Reduce Motion honoured.
            selectedIcon: _PopIcon(
              color: colorScheme.primary,
              icon: Icons.assignment,
            ),
            label: 'Заявки',
          ),
          NavigationDestination(
            icon: const _NotificationsIcon(),
            selectedIcon: _PopIcon(
              color: colorScheme.primary,
              icon: Icons.notifications,
            ),
            label: 'Уведомления',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: _PopIcon(
              color: colorScheme.primary,
              icon: Icons.person,
            ),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

/// Иконка уведомлений с динамическим бейджем непрочитанных.
class _NotificationsIcon extends StatelessWidget {
  const _NotificationsIcon();

  @override
  Widget build(BuildContext context) {
    final badge = getIt<UnreadBadgeViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: badge,
      builder: (context, _) {
        if (badge.count <= 0) {
          return const Icon(Icons.notifications_outlined);
        }
        return Badge(
          label: Text('${badge.count > 99 ? '99+' : badge.count}'),
          backgroundColor: colorScheme.primary,
          child: const Icon(Icons.notifications_outlined),
        );
      },
    );
  }
}

/// Иконка активной вкладки с spring-pop при появлении.
///
/// `selectedIcon` в NavigationDestination монтируется заново, когда вкладка
/// становится активной — это и есть триггер анимации: иконка «выпрыгивает»
/// (scale 0.8→1.0 через easeOutBack), тактильно подтверждая выбор. Reduce
/// Motion honoured: scale всегда 1.0 (мгновенно).
class _PopIcon extends StatelessWidget {
  const _PopIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: reduceMotion ? 1.0 : 0.8, end: 1.0),
      curve: Curves.easeOutBack,
      duration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Icon(icon, color: color),
    );
  }
}
