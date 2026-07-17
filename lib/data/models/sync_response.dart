import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_response.freezed.dart';
part 'sync_response.g.dart';

/// Конфигурация периодов (`GET /sync`).
@freezed
abstract class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    @JsonKey(name: 'coordinates_period') int? coordinatesPeriod,
    @JsonKey(name: 'sync_period') int? syncPeriod,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}
