import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/service_locator.dart';
import '../../features/notifications/view_models/unread_badge_view_model.dart';

/// Каркас с нижней навигацией: Заявки, Уведомления, Профиль.
///
/// Использует StatefulNavigationShell из go_router (StatefulShellRoute)
/// для сохранения состояния каждой вкладки.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // При переходе на вкладку уведомлений — обновим счётчик.
          if (index == 1) {
            getIt<UnreadBadgeViewModel>().refresh();
          }
          navigationShell.goBranch(
            index,
            // Если вкладка уже активна — вернуться в начало стека.
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
            colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        elevation: theme.bottomNavigationBarTheme.elevation ?? 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: colorScheme.primary),
            label: 'Заявки',
          ),
          NavigationDestination(
            icon: const _NotificationsIcon(),
            selectedIcon:
                Icon(Icons.notifications, color: colorScheme.primary),
            label: 'Уведомления',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: colorScheme.primary),
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
