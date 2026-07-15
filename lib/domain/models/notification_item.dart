/// Элемент списка уведомлений.
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.message,
    required this.datetime,
    required this.isRead,
    this.orderId,
    this.routePhotoId,
    this.routePhotoTypeId,
  });

  final int id;
  final String message;
  final String datetime;
  final bool isRead;
  final int? orderId;
  final int? routePhotoId;
  final int? routePhotoTypeId;

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      message: message,
      datetime: datetime,
      isRead: isRead ?? this.isRead,
      orderId: orderId,
      routePhotoId: routePhotoId,
      routePhotoTypeId: routePhotoTypeId,
    );
  }

  /// Имеет ли смысл открывать заявку по тапу.
  bool get hasOrder => orderId != null && orderId! > 0;
}
