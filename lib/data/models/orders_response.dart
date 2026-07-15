import 'package:freezed_annotation/freezed_annotation.dart';

part 'orders_response.freezed.dart';
part 'orders_response.g.dart';

/// Конвертер mass/volume: сервер может отдать int или String → всегда String.
String? _nullableToString(Object? value) => value?.toString();

/// Элемент списка заявок (`GET /orders`, `GET /orders/history`).
@freezed
class OrdersResponseItem with _$OrdersResponseItem {
  const factory OrdersResponseItem({
    int? id,
    String? num,
    int? status,
    String? route,
    @JsonKey(name: 'route_from') String? routeFrom,
    @JsonKey(name: 'route_to') String? routeTo,
    @JsonKey(name: 'loading_date') String? loadingDate,
    @JsonKey(name: 'unloading_date') String? unloadingDate,
    @JsonKey(name: 'is_working') int? isWorking,
    OrdersResponseClient? client,
  }) = _OrdersResponseItem;

  factory OrdersResponseItem.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseItemFromJson(json);
}

/// Детали заявки (`GET /orders/{id}/main`).
@freezed
class OrdersResponse with _$OrdersResponse {
  const factory OrdersResponse({
    int? id,
    String? num,
    int? status,
    String? route,
    @JsonKey(name: 'cargo_type') String? cargoType,
    @JsonKey(fromJson: _nullableToString) String? mass,
    @JsonKey(fromJson: _nullableToString) String? volume,
    @JsonKey(name: 'loading_date') String? loadingDate,
    @JsonKey(name: 'unloading_date') String? unloadingDate,
    @JsonKey(name: 'loading_time_from') String? loadingTimeFrom,
    @JsonKey(name: 'loading_time_to') String? loadingTimeTo,
    @JsonKey(name: 'unloading_time_from') String? unloadingTimeFrom,
    @JsonKey(name: 'unloading_time_to') String? unloadingTimeTo,
    @JsonKey(name: 'lat_start') double? latStart,
    @JsonKey(name: 'lng_start') double? lngStart,
    @JsonKey(name: 'lat_fin') double? latFin,
    @JsonKey(name: 'lng_fin') double? lngFin,
    OrdersResponseClient? client,
    @JsonKey(name: 'route_details')
    List<OrdersResponseRouteDetail>? routeDetails,
    List<OrdersResponseOrderPhoto>? photo,
  }) = _OrdersResponse;

  factory OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);
}

/// Клиент заявки.
@freezed
class OrdersResponseClient with _$OrdersResponseClient {
  const factory OrdersResponseClient({
    String? org,
    String? manager,
    String? phone,
  }) = _OrdersResponseClient;

  factory OrdersResponseClient.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseClientFromJson(json);
}

/// Точка маршрута.
@freezed
class OrdersResponseRouteDetail with _$OrdersResponseRouteDetail {
  const factory OrdersResponseRouteDetail({
    @JsonKey(name: 'route_detail_id') int? routeDetailId,
    @JsonKey(name: 'operation_type') int? operationType,
    String? city,
    String? address,
    String? date,
    @JsonKey(name: 'time_from') String? timeFrom,
    @JsonKey(name: 'time_to') String? timeTo,
    String? comment,
    @JsonKey(name: 'cargo_type') String? cargoType,
    @JsonKey(name: 'loading_method') String? loadingMethod,
    @JsonKey(fromJson: _nullableToString) String? mass,
    @JsonKey(fromJson: _nullableToString) String? volume,
    double? lat,
    double? lon,
    @JsonKey(name: 'client_detail') OrdersResponseClientDetail? clientDetail,
  }) = _OrdersResponseRouteDetail;

  factory OrdersResponseRouteDetail.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseRouteDetailFromJson(json);
}

/// Клиент в точке маршрута.
@freezed
class OrdersResponseClientDetail with _$OrdersResponseClientDetail {
  const factory OrdersResponseClientDetail({
    String? org,
    String? manager,
    String? phone,
    int? type,
  }) = _OrdersResponseClientDetail;

  factory OrdersResponseClientDetail.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseClientDetailFromJson(json);
}

/// Группа фото по типу.
@freezed
class OrdersResponseOrderPhoto with _$OrdersResponseOrderPhoto {
  const factory OrdersResponseOrderPhoto({
    int? id,
    String? type,
    @JsonKey(name: 'route_photo') List<OrdersResponseOrderRoutePhoto>? routePhoto,
  }) = _OrdersResponseOrderPhoto;

  factory OrdersResponseOrderPhoto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseOrderPhotoFromJson(json);
}

/// Фото в группе.
@freezed
class OrdersResponseOrderRoutePhoto with _$OrdersResponseOrderRoutePhoto {
  const factory OrdersResponseOrderRoutePhoto({
    int? id,
    String? url,
    int? status,
    String? comment,
  }) = _OrdersResponseOrderRoutePhoto;

  factory OrdersResponseOrderRoutePhoto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseOrderRoutePhotoFromJson(json);
}
