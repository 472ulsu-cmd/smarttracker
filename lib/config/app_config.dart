/// Глобальная конфигурация приложения.
///
/// Переключение `useMock` включает заглушку API (без обращения к серверу)
/// для демонстрации UI и отладки без backend.
class AppConfig {
  const AppConfig({
    this.baseUrl = 'https://st.b2b-logist.com/api/',
    this.useMock = false,
    this.connectTimeoutMs = 15000,
    this.receiveTimeoutMs = 20000,
  });

  /// Базовый URL API «Умная логистика».
  final String baseUrl;

  /// Использовать mock-реализации репозиториев.
  final bool useMock;

  final int connectTimeoutMs;
  final int receiveTimeoutMs;

  /// Конфигурация по умолчанию для production-сборки.
  static const AppConfig production = AppConfig();

  /// Конфигурация с mock-режимом (для отладки/демо без сервера).
  static const AppConfig mock = AppConfig(useMock: true);
}
