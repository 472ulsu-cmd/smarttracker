import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';

/// Преобразует Dio-ошибки в доменные [AppException].
///
/// Запускается последним ( onError ), чтобы видеть все типы сбоев:
/// отсутствие сети, таймауты, HTTP-статусы, ошибки бизнес-логики (api code).
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _map(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        type: err.type,
        response: err.response,
        error: exception,
        stackTrace: err.stackTrace,
        message: exception.message,
      ),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (err.error is AppException) return err.error as AppException;
        return const NetworkException();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException('Сервер не отвечает. Попробуйте позже.');
      case DioExceptionType.cancel:
        return const UnknownException('Запрос отменён.');
      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Ошибка сертификата.');
      case DioExceptionType.badResponse:
        return _mapResponse(err.response);
    }
  }

  AppException _mapResponse(Response? response) {
    if (response == null) {
      return const ServerException();
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final path = response.requestOptions.path;

    // Сначала пытаемся прочитать бизнес-код API (поле "code") — он точнее
    // HTTP-статуса и одинаков для 200 с code<0 и для 401 с code<0.
    if (data is Map<String, dynamic>) {
      final apiCode = data['code'];
      if (apiCode is num && apiCode < 0) {
        return ValidationException(
          message: _apiCodeMessage(apiCode.toInt(), path),
        );
      }
    }

    // 401/403 — неавторизован.
    if (statusCode == 401 || statusCode == 403) {
      // Для публичных auth-эндпоинтов (например /login) 401 означает
      // неверные учётные данные, а не истёкшую сессию.
      if (_isPublicAuthPath(path)) {
        return const ValidationException(
            message: 'Неверный паспорт или пароль. Проверьте введённые данные.');
      }
      return const UnauthorizedException();
    }

    if (statusCode >= 500) {
      return ServerException(
        message: 'Ошибка сервера ($statusCode). Попробуйте позже.',
        statusCode: statusCode,
      );
    }

    // 429 — слишком много запросов: сработала защита от перебора.
    // Предлагаем подождать и повторить.
    if (statusCode == 429) {
      return ServerException(
        message: 'Слишком много попыток входа. Подождите несколько минут и попробуйте снова.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 404) {
      return ServerException(
        message: 'Метод не найден.',
        statusCode: statusCode,
      );
    }

    if (statusCode >= 400) {
      return ServerException(
        message: 'Ошибка запроса ($statusCode).',
        statusCode: statusCode,
      );
    }

    return ServerException(statusCode: statusCode);
  }

  /// Человек-понятные сообщения по известным кодам API.
  ///
  /// Коды получены из тестов реальных эндпоинтов:
  /// - `-4` / `-10` — неверный паспорт или пароль (`/login`);
  /// - `-6` — пользователь с таким паспортом уже зарегистрирован
  ///   (`/registration`). На эндпоинтах восстановления (`/restore`,
  ///   `/user/send_restoring_phone_code`) этот же код сервер может
  ///   возвращать и для несуществующего пользователя — инвертируем смысл.
  /// - `-7` — пользователь с указанным паспортом и телефоном не найден
  ///   (`/user/send_restoring_phone_code`, `/restore`);
  /// - `-12` — неверный SMS-код (`/user/verify_phone_code`);
  /// - `-14` — некорректные данные (зависит от эндпоинта).
  String _apiCodeMessage(int code, String path) {
    // На эндпоинтах восстановления пароля код -6 фактически означает,
    // что пользователь не найден (семантика инвертирована относительно
    // регистрации).
    final isRestore = path.startsWith('/restore') ||
        path.startsWith('/user/send_restoring_phone_code');
    switch (code) {
      case -4:
      case -10:
        return 'Неверный паспорт или пароль. Проверьте введённые данные.';
      case -6:
        if (isRestore) {
          return 'Пользователь с таким паспортом или телефоном не найден. Проверьте данные или зарегистрируйтесь.';
        }
        return 'Пользователь с таким паспортом уже зарегистрирован. Попробуйте войти или восстановить пароль.';
      case -7:
        return 'Пользователь с таким паспортом или телефоном не найден.';
      case -12:
        return 'Неверный код подтверждения.';
      case -14:
        if (isRestore) {
          return 'Пользователь с таким паспортом или телефоном не найден. Проверьте данные или зарегистрируйтесь.';
        }
        return 'Проверьте введённые данные. Возможно, пользователь уже существует.';
      default:
        return 'Проверьте введённые данные.';
    }
  }

  /// Публичные auth-эндпоинты — для них 401 это неверные данные, а не
  /// истёкшая сессия. Список должен совпадать с `_publicAuthPaths` в
  /// `auth_interceptor.dart`.
  bool _isPublicAuthPath(String path) {
    const publicAuthPaths = <String>{
      '/login',
      '/registration',
      '/restore',
      '/user/send_phone_code',
      '/user/send_restoring_phone_code',
      '/user/verify_phone_code',
    };
    return publicAuthPaths.any(path.startsWith);
  }
}
