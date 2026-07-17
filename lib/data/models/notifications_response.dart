import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_response.freezed.dart';
part 'notifications_response.g.dart';

/// Элемент списка уведомлений (`GET /notification/{type_id}`).
@freezed
abstract class NotificationsResponseItem with _$NotificationsResponseItem {
  const factory NotificationsResponseItem({
    int? id,
    String? message,
    String? datetime,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'order_id') int? orderId,
    @JsonKey(name: 'route_photo_id') int? routePhotoId,
    @JsonKey(name: 'route_photo_type_id') int? routePhotoTypeId,
  }) = _NotificationsResponseItem;

  factory NotificationsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationsResponseItemFromJson(json);
}
