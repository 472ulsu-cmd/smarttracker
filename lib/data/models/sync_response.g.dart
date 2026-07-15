// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncResponseImpl _$$SyncResponseImplFromJson(Map<String, dynamic> json) =>
    _$SyncResponseImpl(
      coordinatesPeriod: (json['coordinates_period'] as num?)?.toInt(),
      syncPeriod: (json['sync_period'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SyncResponseImplToJson(_$SyncResponseImpl instance) =>
    <String, dynamic>{
      'coordinates_period': instance.coordinatesPeriod,
      'sync_period': instance.syncPeriod,
    };
