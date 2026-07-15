import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'secure_storage_service.dart';

/// Создаёт настроенный экземпляр [Dio]:
/// baseUrl, таймауты, перехватчики аутентификации и ошибок.
///
/// Порядок перехватчиков имеет значение: AuthInterceptor добавляет токен
/// на onRequest и чистит на onError; ErrorInterceptor преобразует ошибки
/// в доменные исключения (запускается последним).
class DioProvider {
  DioProvider._();

  static Dio create({
    required AppConfig config,
    required SecureStorageService storage,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(milliseconds: config.connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: config.receiveTimeoutMs),
        sendTimeout: Duration(milliseconds: config.connectTimeoutMs),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(storage),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
