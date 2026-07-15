// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrdersRoutePhotoResponseImpl _$$OrdersRoutePhotoResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$OrdersRoutePhotoResponseImpl(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$OrdersRoutePhotoResponseImplToJson(
        _$OrdersRoutePhotoResponseImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

_$OrdersRoutePhotoTypeResponseImpl _$$OrdersRoutePhotoTypeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$OrdersRoutePhotoTypeResponseImpl(
      photoId: (json['photo_id'] as num?)?.toInt(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$OrdersRoutePhotoTypeResponseImplToJson(
        _$OrdersRoutePhotoTypeResponseImpl instance) =>
    <String, dynamic>{
      'photo_id': instance.photoId,
      'url': instance.url,
    };
