// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) =>
    _SyncResponse(
      coordinatesPeriod: (json['coordinates_period'] as num?)?.toInt(),
      syncPeriod: (json['sync_period'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SyncResponseToJson(_SyncResponse instance) =>
    <String, dynamic>{
      'coordinates_period': instance.coordinatesPeriod,
      'sync_period': instance.syncPeriod,
    };
