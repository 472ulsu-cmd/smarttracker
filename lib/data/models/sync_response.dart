/// Конфигурация периодов (`GET /sync`).
class SyncResponse {
  const SyncResponse({this.coordinatesPeriod, this.syncPeriod});

  factory SyncResponse.fromJson(Map<String, dynamic> json) => SyncResponse(
        coordinatesPeriod: (json['coordinates_period'] as num?)?.toInt(),
        syncPeriod: (json['sync_period'] as num?)?.toInt(),
      );

  final int? coordinatesPeriod;
  final int? syncPeriod;
}
