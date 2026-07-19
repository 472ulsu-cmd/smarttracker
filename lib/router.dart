import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'config/service_locator.dart';
import 'domain/repositories/auth_repository.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/auth/views/auth_stepper_screen.dart';
import 'ui/features/auth/views/login_screen.dart';
import 'ui/features/legal/views/agreement_screen.dart';
import 'ui/features/location/view_models/location_permission_view_model.dart';
import 'ui/features/location/views/location_permission_screen.dart';
import 'ui/features/main/main_shell.dart';
import 'ui/features/notifications/views/notifications_screen.dart';
import 'ui/features/orders/views/order_detail_screen.dart';
import 'ui/features/orders/views/order_route_screen.dart';
import 'ui/features/orders/views/orders_screen.dart';
import 'ui/features/photos/views/photo_screen.dart';
import 'ui/features/profile/views/change_password_screen.dart';
import 'ui/features/profile/views/feedback_screen.dart';
import 'ui/features/profile/views/profile_edit_screen.dart';
import 'ui/features/profile/views/profile_screen.dart';

/// Все маршруты приложения.
class AppRoutes {
  AppRoutes._();

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const recovery = '/auth/recovery';
  // Соглашение доступно до входа (из регистрации) — отдельный маршрут
  // в /auth-зоне, чтобы редирект неавторизованных его не перехватывал.
  static const authAgreement = '/auth/agreement';
  static const locationPermission = '/location-permission';
  static const orders = '/main/orders';
  static const notifications = '/main/notifications';
  static const profile = '/main/profile';
}

String? _authRedirect(BuildContext context, GoRouterState state) {
  final auth = getIt<AuthViewModel>();
  final path = state.uri.toString();
  final isAuthRoute = path.startsWith('/auth');
  final isLocationScreen = path == AppRoutes.locationPermission;

  switch (auth.status) {
    case AuthStatus.initial:
      return null;
    case AuthStatus.unauthenticated:
      // На auth-маршрутах (login/register/recovery) — оставляем.
      // На остальных — на экран входа.
      return isAuthRoute ? null : AppRoutes.login;
    case AuthStatus.authenticated:
      // Авторизован — не пускаем обратно на auth-экраны.
      if (isAuthRoute) {
        // Сначала проверяем разрешение геолокации.
        final loc = getIt<LocationPermissionViewModel>();
        if (!loc.isGranted) return AppRoutes.locationPermission;
        return AppRoutes.orders;
      }
      // На основном разделе — проверяем разрешение геолокации.
      // Без разрешения работать нельзя.
      final loc = getIt<LocationPermissionViewModel>();
      if (!loc.isGranted && !isLocationScreen) {
        return AppRoutes.locationPermission;
      }
      // Если разрешение выдано и пользователь на экране запроса —
      // пускаем в приложение.
      if (loc.isGranted && isLocationScreen) {
        return AppRoutes.orders;
      }
      return null;
  }
}

/// Создаёт сконфигурированный [GoRouter].
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: _authRedirect,
    // Роутер реагирует на изменения и аутентификации, и разрешения геолокации.
    refreshListenable: Listenable.merge([
      getIt<AuthViewModel>(),
      getIt<LocationPermissionViewModel>(),
    ]),
    routes: [
      // --- Аутентификация ---
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const AuthStepperScreen(
            mode: AuthFlowMode.registration),
      ),
      GoRoute(
        path: AppRoutes.recovery,
        builder: (context, state) => const AuthStepperScreen(
            mode: AuthFlowMode.recovery),
      ),
      // Соглашение из флоу регистрации (пользователь ещё не вошёл).
      GoRoute(
        path: AppRoutes.authAgreement,
        builder: (context, state) => const AgreementScreen(),
      ),

      // --- Разрешение геолокации ---
      GoRoute(
        path: AppRoutes.locationPermission,
        builder: (context, state) => const LocationPermissionScreen(),
      ),

      // --- Основная часть (нижняя навигация) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.orders,
              builder: (context, state) => const OrdersScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.tryParse(
                            state.pathParameters['id'] ?? '') ??
                        0;
                    return OrderDetailScreen(orderId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'route',
                      builder: (context, state) {
                        final id = int.tryParse(
                                state.pathParameters['id'] ?? '') ??
                            0;
                        return OrderRouteScreen(orderId: id);
                      },
                    ),
                    GoRoute(
                      path: 'photos',
                      builder: (context, state) {
                        final id = int.tryParse(
                                state.pathParameters['id'] ?? '') ??
                            0;
                        return PhotoScreen(orderId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.notifications,
              builder: (context, state) => const NotificationsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const ProfileEditScreen(),
                ),
                GoRoute(
                  path: 'password',
                  builder: (context, state) =>
                      const ChangePasswordScreen(),
                ),
                GoRoute(
                  path: 'feedback',
                  builder: (context, state) => const FeedbackScreen(),
                ),
                // Соглашение из профиля (пользователь авторизован:
                // /auth/agreement для него перехватит редирект).
                GoRoute(
                  path: 'agreement',
                  builder: (context, state) => const AgreementScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
}
