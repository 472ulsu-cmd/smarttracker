import 'order_photo.dart';
import 'order_status.dart';

/// Короткая модель заявки из списка (`GET /orders`, `GET /orders/history`).
class OrderListItem {
  const OrderListItem({
    required this.id,
    required this.num,
    required this.status,
    required this.route,
    this.routeFrom = '',
    this.routeTo = '',
    this.loadingDate = '',
    this.unloadingDate = '',
    this.isWorking = false,
  });

  final int id;
  final String num;
  final int status;
  final String route;
  final String routeFrom;
  final String routeTo;
  final String loadingDate;
  final String unloadingDate;
  final bool isWorking;

  String get statusLabel => OrderStatus.labelForId(status);
}

/// Детальная модель заявки (`GET /orders/{id}/main`).
class OrderDetail {
  const OrderDetail({
    required this.id,
    required this.num,
    required this.status,
    required this.route,
    this.cargoType = '',
    this.mass = '',
    this.volume = '',
    this.loadingDate = '',
    this.unloadingDate = '',
    this.loadingTimeFrom = '',
    this.loadingTimeTo = '',
    this.unloadingTimeFrom = '',
    this.unloadingTimeTo = '',
    this.latStart,
    this.lngStart,
    this.latFin,
    this.lngFin,
    this.client = const OrderClient(),
    this.routeDetails = const [],
    this.photos = const [],
  });

  final int id;
  final String num;
  final int status;
  final String route;
  final String cargoType;
  final String mass;
  final String volume;
  final String loadingDate;
  final String unloadingDate;
  final String loadingTimeFrom;
  final String loadingTimeTo;
  final String unloadingTimeFrom;
  final String unloadingTimeTo;
  final double? latStart;
  final double? lngStart;
  final double? latFin;
  final double? lngFin;
  final OrderClient client;
  final List<OrderRouteDetail> routeDetails;
  final List<OrderPhotoGroup> photos;

  String get statusLabel => OrderStatus.labelForId(status);
}

/// Клиент заявки.
class OrderClient {
  const OrderClient({
    this.org = '',
    this.manager = '',
    this.phone = '',
  });

  final String org;
  final String manager;
  final String phone;
}

/// Точка маршрута.
class OrderRouteDetail {
  const OrderRouteDetail({
    required this.routeDetailId,
    required this.operationType,
    this.city = '',
    this.address = '',
    this.date = '',
    this.timeFrom = '',
    this.timeTo = '',
    this.comment = '',
    this.cargoType = '',
    this.loadingMethod = '',
    this.mass = '',
    this.volume = '',
    this.lat,
    this.lon,
    this.client = const OrderClient(),
  });

  final int routeDetailId;
  final int operationType;
  final String city;
  final String address;
  final String date;
  final String timeFrom;
  final String timeTo;
  final String comment;
  final String cargoType;
  final String loadingMethod;
  final String mass;
  final String volume;
  final double? lat;
  final double? lon;
  final OrderClient client;

  /// Тип операции по API: 1 — погрузка, 2 — разгрузка.
  bool get isLoading => operationType == 1;
}
