import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';
import '../../domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> sendFeedback(String message) async {
    try {
      await _dio.put<dynamic>('/feedback', data: {'message': message});
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  Never _rethrowDio(DioException e) {
    final cause = e.error;
    if (cause is AppException) throw cause;
    throw const NetworkException();
  }
}
