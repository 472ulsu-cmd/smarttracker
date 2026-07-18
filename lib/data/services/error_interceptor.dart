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

    // 401/403 — неавторизован.
    if (statusCode == 401 || statusCode == 403) {
      return const UnauthorizedException();
    }

    // Попытка прочитать бизнес-код API (поле "code").
    if (data is Map<String, dynamic>) {
      final apiCode = data['code'];
      if (apiCode is num && apiCode < 0) {
        return ValidationException(
          message: _apiCodeMessage(apiCode.toInt()),
        );
      }
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
  /// - `-7` — пользователь с указанным паспортом и телефоном не найден
  ///   (`/user/send_restoring_phone_code`, `/restore`);
  /// - `-12` — неверный SMS-код (`/user/verify_phone_code`);
  /// - `-6` — пользователь с таким паспортом уже зарегистрирован.
  /// - `-14` — некорректные данные: пользователь уже существует или пароль
  ///   слишком короткий (зависит от эндпоинта).
  String _apiCodeMessage(int code) {
    switch (code) {
      case -4:
      case -10:
        return 'Неверный паспорт или пароль. Проверьте введённые данные.';
      case -6:
        return 'Пользователь с таким паспортом уже зарегистрирован. Попробуйте войти или восстановить пароль.';
      case -7:
        return 'Пользователь с таким паспортом и телефоном не найден.';
      case -12:
        return 'Неверный код подтверждения.';
      case -14:
        return 'Проверьте введённые данные. Возможно, пользователь уже существует или пароль слишком короткий.';
      default:
        return 'Проверьте введённые данные.';
    }
  }
}
