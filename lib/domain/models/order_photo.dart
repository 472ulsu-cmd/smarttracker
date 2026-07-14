/// Статус прикреплённого фото.
enum OrderPhotoStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case OrderPhotoStatus.pending:
        return 'На рассмотрении';
      case OrderPhotoStatus.approved:
        return 'Одобрено';
      case OrderPhotoStatus.rejected:
        return 'Отклонено';
    }
  }

  static OrderPhotoStatus fromApiStatus(int? value) {
    switch (value) {
      case 2:
        return OrderPhotoStatus.approved;
      case 3:
        return OrderPhotoStatus.rejected;
      case 1:
      default:
        return OrderPhotoStatus.pending;
    }
  }
}

class OrderPhotoGroup {
  const OrderPhotoGroup({
    required this.id,
    required this.type,
    this.photos = const [],
  });

  final int id;
  final String type;
  final List<OrderPhoto> photos;
}

class OrderPhoto {
  const OrderPhoto({
    required this.id,
    required this.url,
    this.status = OrderPhotoStatus.pending,
    this.comment = '',
    this.rejectionReason = '',
  });

  final int id;
  final String url;
  final OrderPhotoStatus status;
  final String comment;
  final String rejectionReason;
}
