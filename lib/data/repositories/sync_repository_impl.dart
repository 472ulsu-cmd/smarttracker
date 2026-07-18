import 'package:dio/dio.dart';

import '../../domain/models/geo_point.dart';
import '../../domain/models/sync_config.dart';
import '../../domain/repositories/sync_repository.dart';
import '../models/sync_response.dart' as api;
import '../services/dio_error.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> sendCoordinates(List<GeoPoint> points) async {
    if (points.isEmpty) return;
    try {
      await _dio.post<dynamic>(
        '/coordinates',
        data: points.map((p) => p.toJson()).toList(),
      );
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }

  @override
  Future<SyncConfig> fetchSyncConfig() async {
    try {
      final response = await _dio.get<dynamic>('/sync');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = api.SyncResponse.fromJson(data);
      return SyncConfig(
        coordinatesPeriodSec: parsed.coordinatesPeriod ?? 60,
        syncPeriodSec: parsed.syncPeriod ?? 900,
      );
    } on DioException catch (e) {
      throw rethrowDio(e);
    }
  }
}
