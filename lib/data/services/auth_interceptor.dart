import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';
import 'secure_storage_service.dart';

/// Публичные auth-эндпоинты — к ним НЕ добавляется Bearer-токен.
const _publicAuthPaths = <String>{
  '/login',
  '/registration',
  '/restore',
  '/user/send_phone_code',
  '/user/send_restoring_phone_code',
  '/user/verify_phone_code',
};

/// Добавляет `Authorization: Bearer <token>` ко всем защищённым запросам.
///
/// При ответе 401 очищает сохранённый токен. Сама навигация на экран входа
/// выполняется на уровне ViewModel/Router по состоянию аутентификации.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final isPublic = _publicAuthPaths.any(path.startsWith);
    if (!isPublic) {
      final token = await _storage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // При 401 чистим токен — сессия более недействительна.
    if (err.error is UnauthorizedException) {
      await _storage.deleteToken();
    }
    return super.onError(err, handler);
  }
}
