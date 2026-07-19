/// Элемент списка уведомлений (`GET /notification/{type_id}`).
class NotificationsResponseItem {
  const NotificationsResponseItem({
    this.id,
    this.message,
    this.datetime,
    this.statusId,
    this.orderId,
    this.routePhotoId,
    this.routePhotoTypeId,
  });

  factory NotificationsResponseItem.fromJson(Map<String, dynamic> json) =>
      NotificationsResponseItem(
        id: (json['id'] as num?)?.toInt(),
        message: json['message'] as String?,
        datetime: json['datetime'] as String?,
        statusId: (json['status_id'] as num?)?.toInt(),
        orderId: (json['order_id'] as num?)?.toInt(),
        routePhotoId: (json['route_photo_id'] as num?)?.toInt(),
        routePhotoTypeId: (json['route_photo_type_id'] as num?)?.toInt(),
      );

  final int? id;
  final String? message;
  final String? datetime;
  final int? statusId;
  final int? orderId;
  final int? routePhotoId;
  final int? routePhotoTypeId;
}
