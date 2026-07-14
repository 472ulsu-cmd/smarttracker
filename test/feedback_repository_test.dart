import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/repositories/feedback_repository_impl.dart';
import 'package:smarttracker/domain/models/app_exception.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({this.throwError});

  final Object? throwError;
  RequestOptions? captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    if (throwError != null) {
      throw throwError!;
    }
    return ResponseBody.fromString(
      jsonEncode({'success': true}),
      200,
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWithAdapter(HttpClientAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://st.b2b-logist.com/api/'))
      ..httpClientAdapter = adapter;

void main() {
  group('FeedbackRepositoryImpl', () {
    test('sendFeedback отправляет PUT /feedback с телом {message}', () async {
      final adapter = _FakeAdapter();
      final repo = FeedbackRepositoryImpl(dio: _dioWithAdapter(adapter));

      await repo.sendFeedback('Тестовое сообщение');

      expect(adapter.captured?.method, 'PUT');
      expect(adapter.captured?.path, '/feedback');
      expect(adapter.captured?.data, {'message': 'Тестовое сообщение'});
    });

    test('sendFeedback пробрасывает NetworkException при сетевой ошибке',
        () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/feedback'),
          type: DioExceptionType.connectionError,
          error: Exception('no connection'),
        ),
      );
      final repo = FeedbackRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendFeedback('msg'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('sendFeedback пробрасывает AppException из cause', () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/feedback'),
          type: DioExceptionType.badResponse,
          error: const ValidationException(),
        ),
      );
      final repo = FeedbackRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendFeedback('msg'),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
