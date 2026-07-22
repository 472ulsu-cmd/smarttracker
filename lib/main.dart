import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'config/service_locator.dart';
import 'core/background/background_bootstrap.dart';
import 'router.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/location/view_models/location_permission_view_model.dart';

/// Точка входа в приложение.
///
/// Архитектура: MVVM (skills flutter-apply-architecture-best-practices).
/// DI: get_it. Навигация: go_router.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Приложение работает только в вертикальной (портретной) ориентации.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Конфигурация. Для демо без backend замените на AppConfig.mock.
  const config = AppConfig.production;

  await setupDependencies(config);
  await BackgroundBootstrap.instance.initCore();

  // Проверяем сохранённую сессию (восстановление входа).
  await getIt<AuthViewModel>().checkSession();

  // Читаем текущий статус разрешения геолокации (без диалога) —
  // нужен для редиректа. Сам запрос с системным диалогом происходит
  // на экране /location-permission при первом входе пользователя.
  await getIt<LocationPermissionViewModel>().check();

  runApp(const SmartTrackerApp());
}

class SmartTrackerApp extends StatefulWidget {
  const SmartTrackerApp({super.key});

  @override
  State<SmartTrackerApp> createState() => _SmartTrackerAppState();
}

class _SmartTrackerAppState extends State<SmartTrackerApp> {
  late final AuthViewModel _auth;
  late final LocationPermissionViewModel _location;
  late final GoRouter _router;
  bool _backgroundStarted = false;

  @override
  void initState() {
    super.initState();
    _auth = getIt<AuthViewModel>();
    _location = getIt<LocationPermissionViewModel>();
    // Роутер создаётся ОДИН раз — пересоздание в build() сбрасывает
    // навигацию и ломает кнопки/переходы.
    _router = createRouter();
    _auth.addListener(_onStateChanged);
    _location.addListener(_onStateChanged);
    _onStateChanged();
  }

  @override
  void dispose() {
    _auth.removeListener(_onStateChanged);
    _location.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    // Фоновые сервисы стартуют только при наличии И аутентификации,
    // И разрешения геолокации «Всегда».
    final shouldRun = _auth.isAuthenticated && _location.isGranted;
    if (shouldRun && !_backgroundStarted) {
      _backgroundStarted = true;
      BackgroundBootstrap.instance.start();
    } else if (!shouldRun && _backgroundStarted) {
      _backgroundStarted = false;
      BackgroundBootstrap.instance.stop();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Умный Водитель',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      locale: const Locale('ru', 'RU'),
      supportedLocales: const [Locale('ru', 'RU')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) {
        // Пока проверяем сессию — показываем сплэш.
        if (_auth.status == AuthStatus.initial && child == null) {
          return const _Splash();
        }
        return child ?? const SizedBox();
      },
    );
  }
}

/// Простой сплэш-экран на время проверки сессии.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
