// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrdersResponseItem _$OrdersResponseItemFromJson(Map<String, dynamic> json) =>
    _OrdersResponseItem(
      id: (json['id'] as num?)?.toInt(),
      num: json['num'] as String?,
      status: (json['status'] as num?)?.toInt(),
      route: json['route'] as String?,
      routeFrom: json['route_from'] as String?,
      routeTo: json['route_to'] as String?,
      loadingDate: json['loading_date'] as String?,
      unloadingDate: json['unloading_date'] as String?,
      isWorking: (json['is_working'] as num?)?.toInt(),
      client: json['client'] == null
          ? null
          : OrdersResponseClient.fromJson(
              json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrdersResponseItemToJson(_OrdersResponseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num': instance.num,
      'status': instance.status,
      'route': instance.route,
      'route_from': instance.routeFrom,
      'route_to': instance.routeTo,
      'loading_date': instance.loadingDate,
      'unloading_date': instance.unloadingDate,
      'is_working': instance.isWorking,
      'client': instance.client,
    };

_OrdersResponse _$OrdersResponseFromJson(Map<String, dynamic> json) =>
    _OrdersResponse(
      id: (json['id'] as num?)?.toInt(),
      num: json['num'] as String?,
      status: (json['status'] as num?)?.toInt(),
      route: json['route'] as String?,
      cargoType: json['cargo_type'] as String?,
      mass: _nullableToString(json['mass']),
      volume: _nullableToString(json['volume']),
      loadingDate: json['loading_date'] as String?,
      unloadingDate: json['unloading_date'] as String?,
      loadingTimeFrom: json['loading_time_from'] as String?,
      loadingTimeTo: json['loading_time_to'] as String?,
      unloadingTimeFrom: json['unloading_time_from'] as String?,
      unloadingTimeTo: json['unloading_time_to'] as String?,
      latStart: (json['lat_start'] as num?)?.toDouble(),
      lngStart: (json['lng_start'] as num?)?.toDouble(),
      latFin: (json['lat_fin'] as num?)?.toDouble(),
      lngFin: (json['lng_fin'] as num?)?.toDouble(),
      client: json['client'] == null
          ? null
          : OrdersResponseClient.fromJson(
              json['client'] as Map<String, dynamic>),
      routeDetails: (json['route_details'] as List<dynamic>?)
          ?.map((e) =>
              OrdersResponseRouteDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      photo: (json['photo'] as List<dynamic>?)
          ?.map((e) =>
              OrdersResponseOrderPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersResponseToJson(_OrdersResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num': instance.num,
      'status': instance.status,
      'route': instance.route,
      'cargo_type': instance.cargoType,
      'mass': instance.mass,
      'volume': instance.volume,
      'loading_date': instance.loadingDate,
      'unloading_date': instance.unloadingDate,
      'loading_time_from': instance.loadingTimeFrom,
      'loading_time_to': instance.loadingTimeTo,
      'unloading_time_from': instance.unloadingTimeFrom,
      'unloading_time_to': instance.unloadingTimeTo,
      'lat_start': instance.latStart,
      'lng_start': instance.lngStart,
      'lat_fin': instance.latFin,
      'lng_fin': instance.lngFin,
      'client': instance.client,
      'route_details': instance.routeDetails,
      'photo': instance.photo,
    };

_OrdersResponseClient _$OrdersResponseClientFromJson(
        Map<String, dynamic> json) =>
    _OrdersResponseClient(
      org: json['org'] as String?,
      manager: json['manager'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$OrdersResponseClientToJson(
        _OrdersResponseClient instance) =>
    <String, dynamic>{
      'org': instance.org,
      'manager': instance.manager,
      'phone': instance.phone,
    };

_OrdersResponseRouteDetail _$OrdersResponseRouteDetailFromJson(
        Map<String, dynamic> json) =>
    _OrdersResponseRouteDetail(
      routeDetailId: (json['route_detail_id'] as num?)?.toInt(),
      operationType: (json['operation_type'] as num?)?.toInt(),
      city: json['city'] as String?,
      address: json['address'] as String?,
      date: json['date'] as String?,
      timeFrom: json['time_from'] as String?,
      timeTo: json['time_to'] as String?,
      comment: json['comment'] as String?,
      cargoType: json['cargo_type'] as String?,
      loadingMethod: json['loading_method'] as String?,
      mass: _nullableToString(json['mass']),
      volume: _nullableToString(json['volume']),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      clientDetail: json['client_detail'] == null
          ? null
          : OrdersResponseClientDetail.fromJson(
              json['client_detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrdersResponseRouteDetailToJson(
        _OrdersResponseRouteDetail instance) =>
    <String, dynamic>{
      'route_detail_id': instance.routeDetailId,
      'operation_type': instance.operationType,
      'city': instance.city,
      'address': instance.address,
      'date': instance.date,
      'time_from': instance.timeFrom,
      'time_to': instance.timeTo,
      'comment': instance.comment,
      'cargo_type': instance.cargoType,
      'loading_method': instance.loadingMethod,
      'mass': instance.mass,
      'volume': instance.volume,
      'lat': instance.lat,
      'lon': instance.lon,
      'client_detail': instance.clientDetail,
    };

_OrdersResponseClientDetail _$OrdersResponseClientDetailFromJson(
        Map<String, dynamic> json) =>
    _OrdersResponseClientDetail(
      org: json['org'] as String?,
      manager: json['manager'] as String?,
      phone: json['phone'] as String?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrdersResponseClientDetailToJson(
        _OrdersResponseClientDetail instance) =>
    <String, dynamic>{
      'org': instance.org,
      'manager': instance.manager,
      'phone': instance.phone,
      'type': instance.type,
    };

_OrdersResponseOrderPhoto _$OrdersResponseOrderPhotoFromJson(
        Map<String, dynamic> json) =>
    _OrdersResponseOrderPhoto(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      routePhoto: (json['route_photo'] as List<dynamic>?)
          ?.map((e) =>
              OrdersResponseOrderRoutePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersResponseOrderPhotoToJson(
        _OrdersResponseOrderPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'route_photo': instance.routePhoto,
    };

_OrdersResponseOrderRoutePhoto _$OrdersResponseOrderRoutePhotoFromJson(
        Map<String, dynamic> json) =>
    _OrdersResponseOrderRoutePhoto(
      id: (json['id'] as num?)?.toInt(),
      url: json['url'] as String?,
      status: (json['status'] as num?)?.toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$OrdersResponseOrderRoutePhotoToJson(
        _OrdersResponseOrderRoutePhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'status': instance.status,
      'comment': instance.comment,
    };
