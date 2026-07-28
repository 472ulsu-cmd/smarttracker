import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/error_interceptor.dart';
import 'package:smarttracker/domain/models/app_exception.dart';

/// Утилита: собирает [DioException] типа [DioExceptionType.badResponse] с
/// заданным статусом и телом ответа — так, как будто Dio доехал до сервера
/// и разобрал JSON.
DioException _badResponse({
  required String path,
  required int statusCode,
  Map<String, dynamic>? data,
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  group('ErrorInterceptor — смена пароля (/user/password)', () {
    test(
        'при неверном текущем пароле (code -4) сообщение не упоминает паспорт',
        () {
      // Баг: при смене пароля из профиля на форме нет поля паспорта — только
      // текущий и новые пароли. Поэтому «Неверный паспорт или пароль…»
      // (текст экрана входа) вводит пользователя в заблуждение.
      final err = ErrorInterceptor().mapError(
        _badResponse(
          path: '/user/password',
          statusCode: 400,
          data: const {'code': -4},
        ),
      );

      expect(err, isA<ValidationException>());
      expect(err.message, contains('текущий пароль'));
      expect(err.message.toLowerCase(), isNot(contains('паспорт')));
    });

    test('при code -10 тоже показывается password-only сообщение', () {
      final err = ErrorInterceptor().mapError(
        _badResponse(
          path: '/user/password',
          statusCode: 400,
          data: const {'code': -10},
        ),
      );

      expect(err, isA<ValidationException>());
      expect(err.message, contains('текущий пароль'));
      expect(err.message.toLowerCase(), isNot(contains('паспорт')));
    });

    test('входные сообщения (/login) не пострадали: паспорт там валиден', () {
      // Регресс: для /login текст «Неверный паспорт или пароль…» должен
      // остаться прежним — там паспорт является идентификатором.
      final err = ErrorInterceptor().mapError(
        _badResponse(
          path: '/login',
          statusCode: 401,
          data: const {'code': -4},
        ),
      );

      expect(err, isA<ValidationException>());
      expect(err.message, 'Неверный паспорт или пароль. Проверьте введённые данные.');
    });
  });
}
