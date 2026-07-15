import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_responses.freezed.dart';
part 'photo_responses.g.dart';

/// Ответ загрузки фото по ID (`POST /orders/{id}/photo/{routePhotoId}`).
@freezed
class OrdersRoutePhotoResponse with _$OrdersRoutePhotoResponse {
  const factory OrdersRoutePhotoResponse({
    String? url,
  }) = _OrdersRoutePhotoResponse;

  factory OrdersRoutePhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersRoutePhotoResponseFromJson(json);
}

/// Ответ загрузки фото по типу (`POST /orders/{id}/photo_type/{typeId}/photo`).
@freezed
class OrdersRoutePhotoTypeResponse with _$OrdersRoutePhotoTypeResponse {
  const factory OrdersRoutePhotoTypeResponse({
    @JsonKey(name: 'photo_id') int? photoId,
    String? url,
  }) = _OrdersRoutePhotoTypeResponse;

  factory OrdersRoutePhotoTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersRoutePhotoTypeResponseFromJson(json);
}
