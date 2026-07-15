import '../../domain/models/order.dart';
import '../../domain/models/order_photo.dart';
import '../models/orders_response.dart' as api;

/// Преобразование API-моделей заказов в доменные.
class OrderMapper {
  OrderMapper._();

  static OrderListItem toItem(api.OrdersResponseItem i) {
    return OrderListItem(
      id: i.id ?? 0,
      num: i.num ?? '',
      status: i.status ?? 0,
      route: i.route ?? '',
      routeFrom: i.routeFrom ?? '',
      routeTo: i.routeTo ?? '',
      loadingDate: i.loadingDate ?? '',
      unloadingDate: i.unloadingDate ?? '',
      isWorking: (i.isWorking ?? 0) == 1,
      client: _toClient(i.client),
    );
  }

  static OrderDetail toDetail(api.OrdersResponse d) {
    return OrderDetail(
      id: d.id ?? 0,
      num: d.num ?? '',
      status: d.status ?? 0,
      route: d.route ?? '',
      cargoType: d.cargoType ?? '',
      mass: d.mass ?? '',
      volume: d.volume ?? '',
      loadingDate: d.loadingDate ?? '',
      unloadingDate: d.unloadingDate ?? '',
      loadingTimeFrom: d.loadingTimeFrom ?? '',
      loadingTimeTo: d.loadingTimeTo ?? '',
      unloadingTimeFrom: d.unloadingTimeFrom ?? '',
      unloadingTimeTo: d.unloadingTimeTo ?? '',
      latStart: d.latStart,
      lngStart: d.lngStart,
      latFin: d.latFin,
      lngFin: d.lngFin,
      client: _toClient(d.client),
      routeDetails:
          (d.routeDetails ?? []).map(_toRouteDetail).toList(growable: false),
      photos: (d.photo ?? []).map(_toPhotoGroup).toList(growable: false),
    );
  }

  static OrderClient _toClient(api.OrdersResponseClient? c) {
    return OrderClient(
      org: c?.org ?? '',
      manager: c?.manager ?? '',
      phone: c?.phone ?? '',
    );
  }

  static OrderRouteDetail _toRouteDetail(api.OrdersResponseRouteDetail r) {
    return OrderRouteDetail(
      routeDetailId: r.routeDetailId ?? 0,
      operationType: r.operationType ?? 0,
      city: r.city ?? '',
      address: r.address ?? '',
      date: r.date ?? '',
      timeFrom: r.timeFrom ?? '',
      timeTo: r.timeTo ?? '',
      comment: r.comment ?? '',
      cargoType: r.cargoType ?? '',
      loadingMethod: r.loadingMethod ?? '',
      mass: r.mass ?? '',
      volume: r.volume ?? '',
      lat: r.lat,
      lon: r.lon,
      client: OrderClient(
        org: r.clientDetail?.org ?? '',
        manager: r.clientDetail?.manager ?? '',
        phone: r.clientDetail?.phone ?? '',
      ),
    );
  }

  static OrderPhotoGroup _toPhotoGroup(api.OrdersResponseOrderPhoto p) {
    return OrderPhotoGroup(
      id: p.id ?? 0,
      type: p.type ?? '',
      photos:
          (p.routePhoto ?? []).map(_toPhoto).toList(growable: false),
    );
  }

  static OrderPhoto _toPhoto(api.OrdersResponseOrderRoutePhoto p) {
    final status = OrderPhotoStatus.fromApiStatus(p.status);
    final comment = p.comment ?? '';
    return OrderPhoto(
      id: p.id ?? 0,
      url: p.url ?? '',
      status: status,
      comment: comment,
      rejectionReason:
          status == OrderPhotoStatus.rejected ? comment : '',
    );
  }
}
