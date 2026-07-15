import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/repositories/sync_repository_impl.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/geo_point.dart';

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
    return ResponseBody.fromString('', 200);
  }

  @override
  void close({bool force = false}) {}
}

Dio _dioWithAdapter(HttpClientAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://st.b2b-logist.com/api/'))
      ..httpClientAdapter = adapter;

GeoPoint _point(double lat, double lng, String city) => GeoPoint(
      lat: lat,
      lng: lng,
      datetime: DateTime.parse('2026-07-15T10:00:00Z'),
      nearestCity: city,
    );

void main() {
  group('SyncRepositoryImpl.sendCoordinates', () {
    test('отправляет POST /coordinates с массивом точек', () async {
      final adapter = _FakeAdapter();
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      await repo.sendCoordinates([
        _point(55.75, 37.61, 'Москва'),
        _point(56.83, 60.60, 'Екатеринбург'),
      ]);

      expect(adapter.captured?.method, 'POST');
      expect(adapter.captured?.path, '/coordinates');
      final data = adapter.captured?.data as List<dynamic>;
      expect(data.length, 2);
      expect(data.first['lat'], 55.75);
      expect(data.first['nearest_city'], 'Москва');
    });

    test('пустой список не вызывает запрос', () async {
      final adapter = _FakeAdapter();
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      await repo.sendCoordinates([]);

      expect(adapter.captured, isNull);
    });

    test('пробрасывает NetworkException при сетевой ошибке', () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/coordinates'),
          type: DioExceptionType.connectionError,
          error: Exception('no connection'),
        ),
      );
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendCoordinates([_point(55.0, 37.0, '')]),
        throwsA(isA<NetworkException>()),
      );
    });

    test('пробрасывает AppException из cause', () async {
      final adapter = _FakeAdapter(
        throwError: DioException(
          requestOptions: RequestOptions(path: '/coordinates'),
          type: DioExceptionType.badResponse,
          error: const ValidationException(),
        ),
      );
      final repo = SyncRepositoryImpl(dio: _dioWithAdapter(adapter));

      expect(
        () async => repo.sendCoordinates([_point(55.0, 37.0, '')]),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
