import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/app_exception.dart';

/// Преобразует Dio-ошибки в доменные [AppException].
///
/// Запускается последним ( onError ), чтобы видеть все типы сбоев:
/// отсутствие сети, таймауты, HTTP-статусы, ошибки бизнес-логики (api code).
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = mapError(err);
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

  /// Преобразует [DioException] в доменное [AppException].
  ///
  /// Вынесено из [onError], чтобы логику маппинга можно было покрыть
  /// unit-тестами без запуска реальной сети.
  @visibleForTesting
  AppException mapError(DioException err) => _map(err);

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
      // При регистрации 401/403 означает, что паспорт уже занят —
      // у нового пользователя ещё нет пароля, который можно ввести неверно.
      if (path.startsWith('/registration')) {
        return const ValidationException(
            message: 'Пользователь с таким паспортом уже зарегистрирован. '
                'Попробуйте войти или восстановить пароль.');
      }
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
  /// - `-4` / `-10`:
  ///   * на `/login` — неверный паспорт или пароль;
  ///   * на `/user/password` — неверный текущий пароль;
  /// - `-6`:
  ///   * на `/user/send_phone_code` (регистрация) — паспорт уже занят;
  ///   * на `/user/send_restoring_phone_code` (восстановление) — логин не найден;
  /// - `-7`:
  ///   * на `/user/send_phone_code` — телефон уже занят;
  ///   * на `/user/send_restoring_phone_code` — телефон не найден;
  /// - `-12` — неверный SMS-код (`/user/verify_phone_code`);
  /// - `-14` — на `/user/send_phone_code`: заняты и паспорт, и телефон.
  ///   На остальных эндпоинтах — некорректные данные.
  String _apiCodeMessage(int code, String path) {
    // Запрос SMS-кода при регистрации.
    final isSendPhoneCode = path.startsWith('/user/send_phone_code');
    // Запрос SMS-кода при восстановлении пароля.
    final isSendRestoringPhoneCode =
        path.startsWith('/user/send_restoring_phone_code');
    final isRestore =
        isSendRestoringPhoneCode || path.startsWith('/restore');
    final isRegistration = path.startsWith('/registration');
    // Смена пароля из профиля: на форме нет поля паспорта, только текущий и
    // новые пароли — поэтому упоминание паспорта здесь вводит в заблуждение.
    final isChangePassword = path.startsWith('/user/password');
    switch (code) {
      case -4:
      case -10:
        // При регистрации эти коды означают, что паспорт уже занят —
        // у нового пользователя ещё нет пароля, который можно ввести неверно.
        if (isRegistration) {
          return 'Пользователь с таким паспортом уже зарегистрирован. '
              'Попробуйте войти или восстановить пароль.';
        }
        // Смена пароля: коды -4/-10 означают неверный текущий пароль.
        if (isChangePassword) {
          return 'Неверный текущий пароль. Проверьте ввод и попробуйте ещё раз.';
        }
        return 'Неверный паспорт или пароль. Проверьте введённые данные.';
      case -6:
        if (isSendPhoneCode) {
          return 'Пользователь с таким паспортом уже зарегистрирован. Попробуйте войти или восстановить пароль.';
        }
        if (isSendRestoringPhoneCode) {
          return 'Пользователь с таким паспортом не найден. Проверьте серию и номер.';
        }
        return 'Пользователь с таким паспортом уже зарегистрирован. Попробуйте войти или восстановить пароль.';
      case -7:
        if (isSendPhoneCode) {
          // Конфликт по телефону при регистрации.
          return 'Этот телефон уже привязан к другому аккаунту. Укажите другой номер или попробуйте восстановить пароль.';
        }
        if (isSendRestoringPhoneCode) {
          return 'Этот телефон не привязан к аккаунту. Проверьте номер.';
        }
        return 'Пользователь с таким паспортом или телефоном не найден.';
      case -12:
        return 'Неверный код подтверждения.';
      case -14:
        // На /user/send_phone_code: заняты и паспорт, и телефон.
        if (isSendPhoneCode) {
          return 'Паспорт и телефон уже привязаны к другому аккаунту. Попробуйте войти или восстановить пароль.';
        }
        if (isRestore) {
          return 'Пользователь с такими данными не найден. Проверьте ввод или зарегистрируйтесь.';
        }
        return 'Проверьте введённые данные.';
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
