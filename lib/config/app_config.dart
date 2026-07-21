/// Глобальная конфигурация приложения.
///
/// `baseUrl` по умолчанию — production API «Умная логистика».
/// Для dev-сборки baseUrl передаётся через `--dart-define=API_BASE_URL=...`
/// при сборке (см. команды ниже). В mock-режиме baseUrl игнорируется.
///
/// Команды сборки:
///   dev:  flutter build apk --release --flavor dev \
///           --dart-define=API_BASE_URL=https://st-dev.b2b-logist.com/api/
///   prod: flutter build apk --release --flavor prod
class AppConfig {
  const AppConfig({
    this.baseUrl = _defaultBaseUrl,
    this.useMock = false,
    this.connectTimeoutMs = 15000,
    this.receiveTimeoutMs = 20000,
  });

  /// Базовый URL API «Умная логистика».
  ///
  /// Из `--dart-define=API_BASE_URL=...`, по умолчанию — production.
  final String baseUrl;

  /// Использовать mock-реализации репозиториев.
  final bool useMock;

  final int connectTimeoutMs;
  final int receiveTimeoutMs;

  /// Конфигурация по умолчанию для production-сборки.
  ///
  /// `baseUrl` берётся из `--dart-define=API_BASE_URL` (если задан) или
  /// остаётся production по умолчанию.
  static const AppConfig production = AppConfig();

  /// Конфигурация с mock-режимом (для отладки/демо без сервера).
  static const AppConfig mock = AppConfig(useMock: true);

  static const String _defaultBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'https://st.b2b-logist.com/api/');
}
