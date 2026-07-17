// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrdersRoutePhotoResponse _$OrdersRoutePhotoResponseFromJson(
        Map<String, dynamic> json) =>
    _OrdersRoutePhotoResponse(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$OrdersRoutePhotoResponseToJson(
        _OrdersRoutePhotoResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

_OrdersRoutePhotoTypeResponse _$OrdersRoutePhotoTypeResponseFromJson(
        Map<String, dynamic> json) =>
    _OrdersRoutePhotoTypeResponse(
      photoId: (json['photo_id'] as num?)?.toInt(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$OrdersRoutePhotoTypeResponseToJson(
        _OrdersRoutePhotoTypeResponse instance) =>
    <String, dynamic>{
      'photo_id': instance.photoId,
      'url': instance.url,
    };
