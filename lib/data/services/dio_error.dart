import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';

/// Достаёт доменное исключение из DioException (ErrorInterceptor кладёт его в `error`).
Never rethrowDio(DioException e) {
  final cause = e.error;
  if (cause is AppException) throw cause;
  throw const NetworkException();
}
