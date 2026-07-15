/// Доменные исключения приложения.
///
/// `ErrorInterceptor` преобразует Dio-ошибки в эти типы.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Понятное пользователю сообщение на русском.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Нет соединения с сервером / нет интернета.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Нет соединения с интернетом.']);
}

/// Ошибки валидации (например, неверный логин/пароль).
class ValidationException extends AppException {
  const ValidationException({
    String message = 'Проверьте введённые данные.',
    this.fieldErrors = const {},
  }) : super(message);

  /// Ошибки по полям формы: { 'password': '...' }.
  final Map<String, String> fieldErrors;
}

/// Серверная ошибка с HTTP-статусом и кодом API.
class ServerException extends AppException {
  const ServerException({
    String message = 'Ошибка сервера. Попробуйте позже.',
    this.statusCode,
    this.apiCode,
  }) : super(message);

  final int? statusCode;
  final int? apiCode;
}

/// Неавторизован — токен недействителен/истёк.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Сессия истекла. Войдите снова.',
  ]);
}

/// Необработанная/неожиданная ошибка.
class UnknownException extends AppException {
  const UnknownException([super.message = 'Произошла непредвиденная ошибка.']);
}
