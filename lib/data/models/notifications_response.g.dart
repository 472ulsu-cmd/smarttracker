// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationsResponseItemImpl _$$NotificationsResponseItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsResponseItemImpl(
      id: (json['id'] as num?)?.toInt(),
      message: json['message'] as String?,
      datetime: json['datetime'] as String?,
      statusId: (json['status_id'] as num?)?.toInt(),
      orderId: (json['order_id'] as num?)?.toInt(),
      routePhotoId: (json['route_photo_id'] as num?)?.toInt(),
      routePhotoTypeId: (json['route_photo_type_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NotificationsResponseItemImplToJson(
        _$NotificationsResponseItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'datetime': instance.datetime,
      'status_id': instance.statusId,
      'order_id': instance.orderId,
      'route_photo_id': instance.routePhotoId,
      'route_photo_type_id': instance.routePhotoTypeId,
    };
