import 'package:dio/dio.dart';

import '../../domain/repositories/feedback_repository.dart';
import '../services/dio_error.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> sendFeedback(String message) async {
    try {
      await _dio.put<dynamic>('/feedback', data: {'message': message});
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }
}
