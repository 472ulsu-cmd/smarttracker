// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrdersResponseItem {
  int? get id;
  String? get num;
  int? get status;
  String? get route;
  @JsonKey(name: 'route_from')
  String? get routeFrom;
  @JsonKey(name: 'route_to')
  String? get routeTo;
  @JsonKey(name: 'loading_date')
  String? get loadingDate;
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate;
  @JsonKey(name: 'is_working')
  int? get isWorking;
  OrdersResponseClient? get client;

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseItemCopyWith<OrdersResponseItem> get copyWith =>
      _$OrdersResponseItemCopyWithImpl<OrdersResponseItem>(
          this as OrdersResponseItem, _$identity);

  /// Serializes this OrdersResponseItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.num, num) || other.num == num) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.routeFrom, routeFrom) ||
                other.routeFrom == routeFrom) &&
            (identical(other.routeTo, routeTo) || other.routeTo == routeTo) &&
            (identical(other.loadingDate, loadingDate) ||
                other.loadingDate == loadingDate) &&
            (identical(other.unloadingDate, unloadingDate) ||
                other.unloadingDate == unloadingDate) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.client, client) || other.client == client));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, num, status, route,
      routeFrom, routeTo, loadingDate, unloadingDate, isWorking, client);

  @override
  String toString() {
    return 'OrdersResponseItem(id: $id, num: $num, status: $status, route: $route, routeFrom: $routeFrom, routeTo: $routeTo, loadingDate: $loadingDate, unloadingDate: $unloadingDate, isWorking: $isWorking, client: $client)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseItemCopyWith<$Res> {
  factory $OrdersResponseItemCopyWith(
          OrdersResponseItem value, $Res Function(OrdersResponseItem) _then) =
      _$OrdersResponseItemCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? num,
      int? status,
      String? route,
      @JsonKey(name: 'route_from') String? routeFrom,
      @JsonKey(name: 'route_to') String? routeTo,
      @JsonKey(name: 'loading_date') String? loadingDate,
      @JsonKey(name: 'unloading_date') String? unloadingDate,
      @JsonKey(name: 'is_working') int? isWorking,
      OrdersResponseClient? client});

  $OrdersResponseClientCopyWith<$Res>? get client;
}

/// @nodoc
class _$OrdersResponseItemCopyWithImpl<$Res>
    implements $OrdersResponseItemCopyWith<$Res> {
  _$OrdersResponseItemCopyWithImpl(this._self, this._then);

  final OrdersResponseItem _self;
  final $Res Function(OrdersResponseItem) _then;

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? num = freezed,
    Object? status = freezed,
    Object? route = freezed,
    Object? routeFrom = freezed,
    Object? routeTo = freezed,
    Object? loadingDate = freezed,
    Object? unloadingDate = freezed,
    Object? isWorking = freezed,
    Object? client = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _self.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      routeFrom: freezed == routeFrom
          ? _self.routeFrom
          : routeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTo: freezed == routeTo
          ? _self.routeTo
          : routeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _self.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _self.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: freezed == isWorking
          ? _self.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as int?,
      client: freezed == client
          ? _self.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
    ));
  }

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<$Res>? get client {
    if (_self.client == null) {
      return null;
    }

    return $OrdersResponseClientCopyWith<$Res>(_self.client!, (value) {
      return _then(_self.copyWith(client: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseItem implements OrdersResponseItem {
  const _OrdersResponseItem(
      {this.id,
      this.num,
      this.status,
      this.route,
      @JsonKey(name: 'route_from') this.routeFrom,
      @JsonKey(name: 'route_to') this.routeTo,
      @JsonKey(name: 'loading_date') this.loadingDate,
      @JsonKey(name: 'unloading_date') this.unloadingDate,
      @JsonKey(name: 'is_working') this.isWorking,
      this.client});
  factory _OrdersResponseItem.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseItemFromJson(json);

  @override
  final int? id;
  @override
  final String? num;
  @override
  final int? status;
  @override
  final String? route;
  @override
  @JsonKey(name: 'route_from')
  final String? routeFrom;
  @override
  @JsonKey(name: 'route_to')
  final String? routeTo;
  @override
  @JsonKey(name: 'loading_date')
  final String? loadingDate;
  @override
  @JsonKey(name: 'unloading_date')
  final String? unloadingDate;
  @override
  @JsonKey(name: 'is_working')
  final int? isWorking;
  @override
  final OrdersResponseClient? client;

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseItemCopyWith<_OrdersResponseItem> get copyWith =>
      __$OrdersResponseItemCopyWithImpl<_OrdersResponseItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.num, num) || other.num == num) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.routeFrom, routeFrom) ||
                other.routeFrom == routeFrom) &&
            (identical(other.routeTo, routeTo) || other.routeTo == routeTo) &&
            (identical(other.loadingDate, loadingDate) ||
                other.loadingDate == loadingDate) &&
            (identical(other.unloadingDate, unloadingDate) ||
                other.unloadingDate == unloadingDate) &&
            (identical(other.isWorking, isWorking) ||
                other.isWorking == isWorking) &&
            (identical(other.client, client) || other.client == client));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, num, status, route,
      routeFrom, routeTo, loadingDate, unloadingDate, isWorking, client);

  @override
  String toString() {
    return 'OrdersResponseItem(id: $id, num: $num, status: $status, route: $route, routeFrom: $routeFrom, routeTo: $routeTo, loadingDate: $loadingDate, unloadingDate: $unloadingDate, isWorking: $isWorking, client: $client)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseItemCopyWith<$Res>
    implements $OrdersResponseItemCopyWith<$Res> {
  factory _$OrdersResponseItemCopyWith(
          _OrdersResponseItem value, $Res Function(_OrdersResponseItem) _then) =
      __$OrdersResponseItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? num,
      int? status,
      String? route,
      @JsonKey(name: 'route_from') String? routeFrom,
      @JsonKey(name: 'route_to') String? routeTo,
      @JsonKey(name: 'loading_date') String? loadingDate,
      @JsonKey(name: 'unloading_date') String? unloadingDate,
      @JsonKey(name: 'is_working') int? isWorking,
      OrdersResponseClient? client});

  @override
  $OrdersResponseClientCopyWith<$Res>? get client;
}

/// @nodoc
class __$OrdersResponseItemCopyWithImpl<$Res>
    implements _$OrdersResponseItemCopyWith<$Res> {
  __$OrdersResponseItemCopyWithImpl(this._self, this._then);

  final _OrdersResponseItem _self;
  final $Res Function(_OrdersResponseItem) _then;

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? num = freezed,
    Object? status = freezed,
    Object? route = freezed,
    Object? routeFrom = freezed,
    Object? routeTo = freezed,
    Object? loadingDate = freezed,
    Object? unloadingDate = freezed,
    Object? isWorking = freezed,
    Object? client = freezed,
  }) {
    return _then(_OrdersResponseItem(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _self.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      routeFrom: freezed == routeFrom
          ? _self.routeFrom
          : routeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTo: freezed == routeTo
          ? _self.routeTo
          : routeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _self.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _self.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: freezed == isWorking
          ? _self.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as int?,
      client: freezed == client
          ? _self.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
    ));
  }

  /// Create a copy of OrdersResponseItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<$Res>? get client {
    if (_self.client == null) {
      return null;
    }

    return $OrdersResponseClientCopyWith<$Res>(_self.client!, (value) {
      return _then(_self.copyWith(client: value));
    });
  }
}

/// @nodoc
mixin _$OrdersResponse {
  int? get id;
  String? get num;
  int? get status;
  String? get route;
  @JsonKey(name: 'cargo_type')
  String? get cargoType;
  @JsonKey(fromJson: _nullableToString)
  String? get mass;
  @JsonKey(fromJson: _nullableToString)
  String? get volume;
  @JsonKey(name: 'loading_date')
  String? get loadingDate;
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate;
  @JsonKey(name: 'loading_time_from')
  String? get loadingTimeFrom;
  @JsonKey(name: 'loading_time_to')
  String? get loadingTimeTo;
  @JsonKey(name: 'unloading_time_from')
  String? get unloadingTimeFrom;
  @JsonKey(name: 'unloading_time_to')
  String? get unloadingTimeTo;
  @JsonKey(name: 'lat_start')
  double? get latStart;
  @JsonKey(name: 'lng_start')
  double? get lngStart;
  @JsonKey(name: 'lat_fin')
  double? get latFin;
  @JsonKey(name: 'lng_fin')
  double? get lngFin;
  OrdersResponseClient? get client;
  @JsonKey(name: 'route_details')
  List<OrdersResponseRouteDetail>? get routeDetails;
  List<OrdersResponseOrderPhoto>? get photo;

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseCopyWith<OrdersResponse> get copyWith =>
      _$OrdersResponseCopyWithImpl<OrdersResponse>(
          this as OrdersResponse, _$identity);

  /// Serializes this OrdersResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.num, num) || other.num == num) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.cargoType, cargoType) ||
                other.cargoType == cargoType) &&
            (identical(other.mass, mass) || other.mass == mass) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.loadingDate, loadingDate) ||
                other.loadingDate == loadingDate) &&
            (identical(other.unloadingDate, unloadingDate) ||
                other.unloadingDate == unloadingDate) &&
            (identical(other.loadingTimeFrom, loadingTimeFrom) ||
                other.loadingTimeFrom == loadingTimeFrom) &&
            (identical(other.loadingTimeTo, loadingTimeTo) ||
                other.loadingTimeTo == loadingTimeTo) &&
            (identical(other.unloadingTimeFrom, unloadingTimeFrom) ||
                other.unloadingTimeFrom == unloadingTimeFrom) &&
            (identical(other.unloadingTimeTo, unloadingTimeTo) ||
                other.unloadingTimeTo == unloadingTimeTo) &&
            (identical(other.latStart, latStart) ||
                other.latStart == latStart) &&
            (identical(other.lngStart, lngStart) ||
                other.lngStart == lngStart) &&
            (identical(other.latFin, latFin) || other.latFin == latFin) &&
            (identical(other.lngFin, lngFin) || other.lngFin == lngFin) &&
            (identical(other.client, client) || other.client == client) &&
            const DeepCollectionEquality()
                .equals(other.routeDetails, routeDetails) &&
            const DeepCollectionEquality().equals(other.photo, photo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        num,
        status,
        route,
        cargoType,
        mass,
        volume,
        loadingDate,
        unloadingDate,
        loadingTimeFrom,
        loadingTimeTo,
        unloadingTimeFrom,
        unloadingTimeTo,
        latStart,
        lngStart,
        latFin,
        lngFin,
        client,
        const DeepCollectionEquality().hash(routeDetails),
        const DeepCollectionEquality().hash(photo)
      ]);

  @override
  String toString() {
    return 'OrdersResponse(id: $id, num: $num, status: $status, route: $route, cargoType: $cargoType, mass: $mass, volume: $volume, loadingDate: $loadingDate, unloadingDate: $unloadingDate, loadingTimeFrom: $loadingTimeFrom, loadingTimeTo: $loadingTimeTo, unloadingTimeFrom: $unloadingTimeFrom, unloadingTimeTo: $unloadingTimeTo, latStart: $latStart, lngStart: $lngStart, latFin: $latFin, lngFin: $lngFin, client: $client, routeDetails: $routeDetails, photo: $photo)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseCopyWith<$Res> {
  factory $OrdersResponseCopyWith(
          OrdersResponse value, $Res Function(OrdersResponse) _then) =
      _$OrdersResponseCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
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
      List<OrdersResponseOrderPhoto>? photo});

  $OrdersResponseClientCopyWith<$Res>? get client;
}

/// @nodoc
class _$OrdersResponseCopyWithImpl<$Res>
    implements $OrdersResponseCopyWith<$Res> {
  _$OrdersResponseCopyWithImpl(this._self, this._then);

  final OrdersResponse _self;
  final $Res Function(OrdersResponse) _then;

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? num = freezed,
    Object? status = freezed,
    Object? route = freezed,
    Object? cargoType = freezed,
    Object? mass = freezed,
    Object? volume = freezed,
    Object? loadingDate = freezed,
    Object? unloadingDate = freezed,
    Object? loadingTimeFrom = freezed,
    Object? loadingTimeTo = freezed,
    Object? unloadingTimeFrom = freezed,
    Object? unloadingTimeTo = freezed,
    Object? latStart = freezed,
    Object? lngStart = freezed,
    Object? latFin = freezed,
    Object? lngFin = freezed,
    Object? client = freezed,
    Object? routeDetails = freezed,
    Object? photo = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _self.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _self.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _self.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _self.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _self.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeFrom: freezed == loadingTimeFrom
          ? _self.loadingTimeFrom
          : loadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeTo: freezed == loadingTimeTo
          ? _self.loadingTimeTo
          : loadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeFrom: freezed == unloadingTimeFrom
          ? _self.unloadingTimeFrom
          : unloadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeTo: freezed == unloadingTimeTo
          ? _self.unloadingTimeTo
          : unloadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      latStart: freezed == latStart
          ? _self.latStart
          : latStart // ignore: cast_nullable_to_non_nullable
              as double?,
      lngStart: freezed == lngStart
          ? _self.lngStart
          : lngStart // ignore: cast_nullable_to_non_nullable
              as double?,
      latFin: freezed == latFin
          ? _self.latFin
          : latFin // ignore: cast_nullable_to_non_nullable
              as double?,
      lngFin: freezed == lngFin
          ? _self.lngFin
          : lngFin // ignore: cast_nullable_to_non_nullable
              as double?,
      client: freezed == client
          ? _self.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
      routeDetails: freezed == routeDetails
          ? _self.routeDetails
          : routeDetails // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseRouteDetail>?,
      photo: freezed == photo
          ? _self.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderPhoto>?,
    ));
  }

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<$Res>? get client {
    if (_self.client == null) {
      return null;
    }

    return $OrdersResponseClientCopyWith<$Res>(_self.client!, (value) {
      return _then(_self.copyWith(client: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponse implements OrdersResponse {
  const _OrdersResponse(
      {this.id,
      this.num,
      this.status,
      this.route,
      @JsonKey(name: 'cargo_type') this.cargoType,
      @JsonKey(fromJson: _nullableToString) this.mass,
      @JsonKey(fromJson: _nullableToString) this.volume,
      @JsonKey(name: 'loading_date') this.loadingDate,
      @JsonKey(name: 'unloading_date') this.unloadingDate,
      @JsonKey(name: 'loading_time_from') this.loadingTimeFrom,
      @JsonKey(name: 'loading_time_to') this.loadingTimeTo,
      @JsonKey(name: 'unloading_time_from') this.unloadingTimeFrom,
      @JsonKey(name: 'unloading_time_to') this.unloadingTimeTo,
      @JsonKey(name: 'lat_start') this.latStart,
      @JsonKey(name: 'lng_start') this.lngStart,
      @JsonKey(name: 'lat_fin') this.latFin,
      @JsonKey(name: 'lng_fin') this.lngFin,
      this.client,
      @JsonKey(name: 'route_details')
      final List<OrdersResponseRouteDetail>? routeDetails,
      final List<OrdersResponseOrderPhoto>? photo})
      : _routeDetails = routeDetails,
        _photo = photo;
  factory _OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);

  @override
  final int? id;
  @override
  final String? num;
  @override
  final int? status;
  @override
  final String? route;
  @override
  @JsonKey(name: 'cargo_type')
  final String? cargoType;
  @override
  @JsonKey(fromJson: _nullableToString)
  final String? mass;
  @override
  @JsonKey(fromJson: _nullableToString)
  final String? volume;
  @override
  @JsonKey(name: 'loading_date')
  final String? loadingDate;
  @override
  @JsonKey(name: 'unloading_date')
  final String? unloadingDate;
  @override
  @JsonKey(name: 'loading_time_from')
  final String? loadingTimeFrom;
  @override
  @JsonKey(name: 'loading_time_to')
  final String? loadingTimeTo;
  @override
  @JsonKey(name: 'unloading_time_from')
  final String? unloadingTimeFrom;
  @override
  @JsonKey(name: 'unloading_time_to')
  final String? unloadingTimeTo;
  @override
  @JsonKey(name: 'lat_start')
  final double? latStart;
  @override
  @JsonKey(name: 'lng_start')
  final double? lngStart;
  @override
  @JsonKey(name: 'lat_fin')
  final double? latFin;
  @override
  @JsonKey(name: 'lng_fin')
  final double? lngFin;
  @override
  final OrdersResponseClient? client;
  final List<OrdersResponseRouteDetail>? _routeDetails;
  @override
  @JsonKey(name: 'route_details')
  List<OrdersResponseRouteDetail>? get routeDetails {
    final value = _routeDetails;
    if (value == null) return null;
    if (_routeDetails is EqualUnmodifiableListView) return _routeDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<OrdersResponseOrderPhoto>? _photo;
  @override
  List<OrdersResponseOrderPhoto>? get photo {
    final value = _photo;
    if (value == null) return null;
    if (_photo is EqualUnmodifiableListView) return _photo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseCopyWith<_OrdersResponse> get copyWith =>
      __$OrdersResponseCopyWithImpl<_OrdersResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.num, num) || other.num == num) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.cargoType, cargoType) ||
                other.cargoType == cargoType) &&
            (identical(other.mass, mass) || other.mass == mass) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.loadingDate, loadingDate) ||
                other.loadingDate == loadingDate) &&
            (identical(other.unloadingDate, unloadingDate) ||
                other.unloadingDate == unloadingDate) &&
            (identical(other.loadingTimeFrom, loadingTimeFrom) ||
                other.loadingTimeFrom == loadingTimeFrom) &&
            (identical(other.loadingTimeTo, loadingTimeTo) ||
                other.loadingTimeTo == loadingTimeTo) &&
            (identical(other.unloadingTimeFrom, unloadingTimeFrom) ||
                other.unloadingTimeFrom == unloadingTimeFrom) &&
            (identical(other.unloadingTimeTo, unloadingTimeTo) ||
                other.unloadingTimeTo == unloadingTimeTo) &&
            (identical(other.latStart, latStart) ||
                other.latStart == latStart) &&
            (identical(other.lngStart, lngStart) ||
                other.lngStart == lngStart) &&
            (identical(other.latFin, latFin) || other.latFin == latFin) &&
            (identical(other.lngFin, lngFin) || other.lngFin == lngFin) &&
            (identical(other.client, client) || other.client == client) &&
            const DeepCollectionEquality()
                .equals(other._routeDetails, _routeDetails) &&
            const DeepCollectionEquality().equals(other._photo, _photo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        num,
        status,
        route,
        cargoType,
        mass,
        volume,
        loadingDate,
        unloadingDate,
        loadingTimeFrom,
        loadingTimeTo,
        unloadingTimeFrom,
        unloadingTimeTo,
        latStart,
        lngStart,
        latFin,
        lngFin,
        client,
        const DeepCollectionEquality().hash(_routeDetails),
        const DeepCollectionEquality().hash(_photo)
      ]);

  @override
  String toString() {
    return 'OrdersResponse(id: $id, num: $num, status: $status, route: $route, cargoType: $cargoType, mass: $mass, volume: $volume, loadingDate: $loadingDate, unloadingDate: $unloadingDate, loadingTimeFrom: $loadingTimeFrom, loadingTimeTo: $loadingTimeTo, unloadingTimeFrom: $unloadingTimeFrom, unloadingTimeTo: $unloadingTimeTo, latStart: $latStart, lngStart: $lngStart, latFin: $latFin, lngFin: $lngFin, client: $client, routeDetails: $routeDetails, photo: $photo)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseCopyWith<$Res>
    implements $OrdersResponseCopyWith<$Res> {
  factory _$OrdersResponseCopyWith(
          _OrdersResponse value, $Res Function(_OrdersResponse) _then) =
      __$OrdersResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
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
      List<OrdersResponseOrderPhoto>? photo});

  @override
  $OrdersResponseClientCopyWith<$Res>? get client;
}

/// @nodoc
class __$OrdersResponseCopyWithImpl<$Res>
    implements _$OrdersResponseCopyWith<$Res> {
  __$OrdersResponseCopyWithImpl(this._self, this._then);

  final _OrdersResponse _self;
  final $Res Function(_OrdersResponse) _then;

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? num = freezed,
    Object? status = freezed,
    Object? route = freezed,
    Object? cargoType = freezed,
    Object? mass = freezed,
    Object? volume = freezed,
    Object? loadingDate = freezed,
    Object? unloadingDate = freezed,
    Object? loadingTimeFrom = freezed,
    Object? loadingTimeTo = freezed,
    Object? unloadingTimeFrom = freezed,
    Object? unloadingTimeTo = freezed,
    Object? latStart = freezed,
    Object? lngStart = freezed,
    Object? latFin = freezed,
    Object? lngFin = freezed,
    Object? client = freezed,
    Object? routeDetails = freezed,
    Object? photo = freezed,
  }) {
    return _then(_OrdersResponse(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _self.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _self.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _self.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _self.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _self.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _self.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeFrom: freezed == loadingTimeFrom
          ? _self.loadingTimeFrom
          : loadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeTo: freezed == loadingTimeTo
          ? _self.loadingTimeTo
          : loadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeFrom: freezed == unloadingTimeFrom
          ? _self.unloadingTimeFrom
          : unloadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeTo: freezed == unloadingTimeTo
          ? _self.unloadingTimeTo
          : unloadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      latStart: freezed == latStart
          ? _self.latStart
          : latStart // ignore: cast_nullable_to_non_nullable
              as double?,
      lngStart: freezed == lngStart
          ? _self.lngStart
          : lngStart // ignore: cast_nullable_to_non_nullable
              as double?,
      latFin: freezed == latFin
          ? _self.latFin
          : latFin // ignore: cast_nullable_to_non_nullable
              as double?,
      lngFin: freezed == lngFin
          ? _self.lngFin
          : lngFin // ignore: cast_nullable_to_non_nullable
              as double?,
      client: freezed == client
          ? _self.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
      routeDetails: freezed == routeDetails
          ? _self._routeDetails
          : routeDetails // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseRouteDetail>?,
      photo: freezed == photo
          ? _self._photo
          : photo // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderPhoto>?,
    ));
  }

  /// Create a copy of OrdersResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<$Res>? get client {
    if (_self.client == null) {
      return null;
    }

    return $OrdersResponseClientCopyWith<$Res>(_self.client!, (value) {
      return _then(_self.copyWith(client: value));
    });
  }
}

/// @nodoc
mixin _$OrdersResponseClient {
  String? get org;
  String? get manager;
  String? get phone;

  /// Create a copy of OrdersResponseClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<OrdersResponseClient> get copyWith =>
      _$OrdersResponseClientCopyWithImpl<OrdersResponseClient>(
          this as OrdersResponseClient, _$identity);

  /// Serializes this OrdersResponseClient to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseClient &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone);

  @override
  String toString() {
    return 'OrdersResponseClient(org: $org, manager: $manager, phone: $phone)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseClientCopyWith<$Res> {
  factory $OrdersResponseClientCopyWith(OrdersResponseClient value,
          $Res Function(OrdersResponseClient) _then) =
      _$OrdersResponseClientCopyWithImpl;
  @useResult
  $Res call({String? org, String? manager, String? phone});
}

/// @nodoc
class _$OrdersResponseClientCopyWithImpl<$Res>
    implements $OrdersResponseClientCopyWith<$Res> {
  _$OrdersResponseClientCopyWithImpl(this._self, this._then);

  final OrdersResponseClient _self;
  final $Res Function(OrdersResponseClient) _then;

  /// Create a copy of OrdersResponseClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
  }) {
    return _then(_self.copyWith(
      org: freezed == org
          ? _self.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _self.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseClient implements OrdersResponseClient {
  const _OrdersResponseClient({this.org, this.manager, this.phone});
  factory _OrdersResponseClient.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseClientFromJson(json);

  @override
  final String? org;
  @override
  final String? manager;
  @override
  final String? phone;

  /// Create a copy of OrdersResponseClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseClientCopyWith<_OrdersResponseClient> get copyWith =>
      __$OrdersResponseClientCopyWithImpl<_OrdersResponseClient>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseClientToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseClient &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone);

  @override
  String toString() {
    return 'OrdersResponseClient(org: $org, manager: $manager, phone: $phone)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseClientCopyWith<$Res>
    implements $OrdersResponseClientCopyWith<$Res> {
  factory _$OrdersResponseClientCopyWith(_OrdersResponseClient value,
          $Res Function(_OrdersResponseClient) _then) =
      __$OrdersResponseClientCopyWithImpl;
  @override
  @useResult
  $Res call({String? org, String? manager, String? phone});
}

/// @nodoc
class __$OrdersResponseClientCopyWithImpl<$Res>
    implements _$OrdersResponseClientCopyWith<$Res> {
  __$OrdersResponseClientCopyWithImpl(this._self, this._then);

  final _OrdersResponseClient _self;
  final $Res Function(_OrdersResponseClient) _then;

  /// Create a copy of OrdersResponseClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
  }) {
    return _then(_OrdersResponseClient(
      org: freezed == org
          ? _self.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _self.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$OrdersResponseRouteDetail {
  @JsonKey(name: 'route_detail_id')
  int? get routeDetailId;
  @JsonKey(name: 'operation_type')
  int? get operationType;
  String? get city;
  String? get address;
  String? get date;
  @JsonKey(name: 'time_from')
  String? get timeFrom;
  @JsonKey(name: 'time_to')
  String? get timeTo;
  String? get comment;
  @JsonKey(name: 'cargo_type')
  String? get cargoType;
  @JsonKey(name: 'loading_method')
  String? get loadingMethod;
  @JsonKey(fromJson: _nullableToString)
  String? get mass;
  @JsonKey(fromJson: _nullableToString)
  String? get volume;
  double? get lat;
  double? get lon;
  @JsonKey(name: 'client_detail')
  OrdersResponseClientDetail? get clientDetail;

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseRouteDetailCopyWith<OrdersResponseRouteDetail> get copyWith =>
      _$OrdersResponseRouteDetailCopyWithImpl<OrdersResponseRouteDetail>(
          this as OrdersResponseRouteDetail, _$identity);

  /// Serializes this OrdersResponseRouteDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseRouteDetail &&
            (identical(other.routeDetailId, routeDetailId) ||
                other.routeDetailId == routeDetailId) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeFrom, timeFrom) ||
                other.timeFrom == timeFrom) &&
            (identical(other.timeTo, timeTo) || other.timeTo == timeTo) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.cargoType, cargoType) ||
                other.cargoType == cargoType) &&
            (identical(other.loadingMethod, loadingMethod) ||
                other.loadingMethod == loadingMethod) &&
            (identical(other.mass, mass) || other.mass == mass) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.clientDetail, clientDetail) ||
                other.clientDetail == clientDetail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      routeDetailId,
      operationType,
      city,
      address,
      date,
      timeFrom,
      timeTo,
      comment,
      cargoType,
      loadingMethod,
      mass,
      volume,
      lat,
      lon,
      clientDetail);

  @override
  String toString() {
    return 'OrdersResponseRouteDetail(routeDetailId: $routeDetailId, operationType: $operationType, city: $city, address: $address, date: $date, timeFrom: $timeFrom, timeTo: $timeTo, comment: $comment, cargoType: $cargoType, loadingMethod: $loadingMethod, mass: $mass, volume: $volume, lat: $lat, lon: $lon, clientDetail: $clientDetail)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseRouteDetailCopyWith<$Res> {
  factory $OrdersResponseRouteDetailCopyWith(OrdersResponseRouteDetail value,
          $Res Function(OrdersResponseRouteDetail) _then) =
      _$OrdersResponseRouteDetailCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'route_detail_id') int? routeDetailId,
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
      @JsonKey(name: 'client_detail')
      OrdersResponseClientDetail? clientDetail});

  $OrdersResponseClientDetailCopyWith<$Res>? get clientDetail;
}

/// @nodoc
class _$OrdersResponseRouteDetailCopyWithImpl<$Res>
    implements $OrdersResponseRouteDetailCopyWith<$Res> {
  _$OrdersResponseRouteDetailCopyWithImpl(this._self, this._then);

  final OrdersResponseRouteDetail _self;
  final $Res Function(OrdersResponseRouteDetail) _then;

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routeDetailId = freezed,
    Object? operationType = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? date = freezed,
    Object? timeFrom = freezed,
    Object? timeTo = freezed,
    Object? comment = freezed,
    Object? cargoType = freezed,
    Object? loadingMethod = freezed,
    Object? mass = freezed,
    Object? volume = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? clientDetail = freezed,
  }) {
    return _then(_self.copyWith(
      routeDetailId: freezed == routeDetailId
          ? _self.routeDetailId
          : routeDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      timeFrom: freezed == timeFrom
          ? _self.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTo: freezed == timeTo
          ? _self.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _self.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMethod: freezed == loadingMethod
          ? _self.loadingMethod
          : loadingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _self.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      clientDetail: freezed == clientDetail
          ? _self.clientDetail
          : clientDetail // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClientDetail?,
    ));
  }

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientDetailCopyWith<$Res>? get clientDetail {
    if (_self.clientDetail == null) {
      return null;
    }

    return $OrdersResponseClientDetailCopyWith<$Res>(_self.clientDetail!,
        (value) {
      return _then(_self.copyWith(clientDetail: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseRouteDetail implements OrdersResponseRouteDetail {
  const _OrdersResponseRouteDetail(
      {@JsonKey(name: 'route_detail_id') this.routeDetailId,
      @JsonKey(name: 'operation_type') this.operationType,
      this.city,
      this.address,
      this.date,
      @JsonKey(name: 'time_from') this.timeFrom,
      @JsonKey(name: 'time_to') this.timeTo,
      this.comment,
      @JsonKey(name: 'cargo_type') this.cargoType,
      @JsonKey(name: 'loading_method') this.loadingMethod,
      @JsonKey(fromJson: _nullableToString) this.mass,
      @JsonKey(fromJson: _nullableToString) this.volume,
      this.lat,
      this.lon,
      @JsonKey(name: 'client_detail') this.clientDetail});
  factory _OrdersResponseRouteDetail.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseRouteDetailFromJson(json);

  @override
  @JsonKey(name: 'route_detail_id')
  final int? routeDetailId;
  @override
  @JsonKey(name: 'operation_type')
  final int? operationType;
  @override
  final String? city;
  @override
  final String? address;
  @override
  final String? date;
  @override
  @JsonKey(name: 'time_from')
  final String? timeFrom;
  @override
  @JsonKey(name: 'time_to')
  final String? timeTo;
  @override
  final String? comment;
  @override
  @JsonKey(name: 'cargo_type')
  final String? cargoType;
  @override
  @JsonKey(name: 'loading_method')
  final String? loadingMethod;
  @override
  @JsonKey(fromJson: _nullableToString)
  final String? mass;
  @override
  @JsonKey(fromJson: _nullableToString)
  final String? volume;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  @JsonKey(name: 'client_detail')
  final OrdersResponseClientDetail? clientDetail;

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseRouteDetailCopyWith<_OrdersResponseRouteDetail>
      get copyWith =>
          __$OrdersResponseRouteDetailCopyWithImpl<_OrdersResponseRouteDetail>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseRouteDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseRouteDetail &&
            (identical(other.routeDetailId, routeDetailId) ||
                other.routeDetailId == routeDetailId) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.timeFrom, timeFrom) ||
                other.timeFrom == timeFrom) &&
            (identical(other.timeTo, timeTo) || other.timeTo == timeTo) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.cargoType, cargoType) ||
                other.cargoType == cargoType) &&
            (identical(other.loadingMethod, loadingMethod) ||
                other.loadingMethod == loadingMethod) &&
            (identical(other.mass, mass) || other.mass == mass) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            (identical(other.clientDetail, clientDetail) ||
                other.clientDetail == clientDetail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      routeDetailId,
      operationType,
      city,
      address,
      date,
      timeFrom,
      timeTo,
      comment,
      cargoType,
      loadingMethod,
      mass,
      volume,
      lat,
      lon,
      clientDetail);

  @override
  String toString() {
    return 'OrdersResponseRouteDetail(routeDetailId: $routeDetailId, operationType: $operationType, city: $city, address: $address, date: $date, timeFrom: $timeFrom, timeTo: $timeTo, comment: $comment, cargoType: $cargoType, loadingMethod: $loadingMethod, mass: $mass, volume: $volume, lat: $lat, lon: $lon, clientDetail: $clientDetail)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseRouteDetailCopyWith<$Res>
    implements $OrdersResponseRouteDetailCopyWith<$Res> {
  factory _$OrdersResponseRouteDetailCopyWith(_OrdersResponseRouteDetail value,
          $Res Function(_OrdersResponseRouteDetail) _then) =
      __$OrdersResponseRouteDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'route_detail_id') int? routeDetailId,
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
      @JsonKey(name: 'client_detail')
      OrdersResponseClientDetail? clientDetail});

  @override
  $OrdersResponseClientDetailCopyWith<$Res>? get clientDetail;
}

/// @nodoc
class __$OrdersResponseRouteDetailCopyWithImpl<$Res>
    implements _$OrdersResponseRouteDetailCopyWith<$Res> {
  __$OrdersResponseRouteDetailCopyWithImpl(this._self, this._then);

  final _OrdersResponseRouteDetail _self;
  final $Res Function(_OrdersResponseRouteDetail) _then;

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? routeDetailId = freezed,
    Object? operationType = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? date = freezed,
    Object? timeFrom = freezed,
    Object? timeTo = freezed,
    Object? comment = freezed,
    Object? cargoType = freezed,
    Object? loadingMethod = freezed,
    Object? mass = freezed,
    Object? volume = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? clientDetail = freezed,
  }) {
    return _then(_OrdersResponseRouteDetail(
      routeDetailId: freezed == routeDetailId
          ? _self.routeDetailId
          : routeDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _self.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      timeFrom: freezed == timeFrom
          ? _self.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTo: freezed == timeTo
          ? _self.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _self.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMethod: freezed == loadingMethod
          ? _self.loadingMethod
          : loadingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _self.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      clientDetail: freezed == clientDetail
          ? _self.clientDetail
          : clientDetail // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClientDetail?,
    ));
  }

  /// Create a copy of OrdersResponseRouteDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientDetailCopyWith<$Res>? get clientDetail {
    if (_self.clientDetail == null) {
      return null;
    }

    return $OrdersResponseClientDetailCopyWith<$Res>(_self.clientDetail!,
        (value) {
      return _then(_self.copyWith(clientDetail: value));
    });
  }
}

/// @nodoc
mixin _$OrdersResponseClientDetail {
  String? get org;
  String? get manager;
  String? get phone;
  int? get type;

  /// Create a copy of OrdersResponseClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseClientDetailCopyWith<OrdersResponseClientDetail>
      get copyWith =>
          _$OrdersResponseClientDetailCopyWithImpl<OrdersResponseClientDetail>(
              this as OrdersResponseClientDetail, _$identity);

  /// Serializes this OrdersResponseClientDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseClientDetail &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone, type);

  @override
  String toString() {
    return 'OrdersResponseClientDetail(org: $org, manager: $manager, phone: $phone, type: $type)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseClientDetailCopyWith<$Res> {
  factory $OrdersResponseClientDetailCopyWith(OrdersResponseClientDetail value,
          $Res Function(OrdersResponseClientDetail) _then) =
      _$OrdersResponseClientDetailCopyWithImpl;
  @useResult
  $Res call({String? org, String? manager, String? phone, int? type});
}

/// @nodoc
class _$OrdersResponseClientDetailCopyWithImpl<$Res>
    implements $OrdersResponseClientDetailCopyWith<$Res> {
  _$OrdersResponseClientDetailCopyWithImpl(this._self, this._then);

  final OrdersResponseClientDetail _self;
  final $Res Function(OrdersResponseClientDetail) _then;

  /// Create a copy of OrdersResponseClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
    Object? type = freezed,
  }) {
    return _then(_self.copyWith(
      org: freezed == org
          ? _self.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _self.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseClientDetail implements OrdersResponseClientDetail {
  const _OrdersResponseClientDetail(
      {this.org, this.manager, this.phone, this.type});
  factory _OrdersResponseClientDetail.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseClientDetailFromJson(json);

  @override
  final String? org;
  @override
  final String? manager;
  @override
  final String? phone;
  @override
  final int? type;

  /// Create a copy of OrdersResponseClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseClientDetailCopyWith<_OrdersResponseClientDetail>
      get copyWith => __$OrdersResponseClientDetailCopyWithImpl<
          _OrdersResponseClientDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseClientDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseClientDetail &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone, type);

  @override
  String toString() {
    return 'OrdersResponseClientDetail(org: $org, manager: $manager, phone: $phone, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseClientDetailCopyWith<$Res>
    implements $OrdersResponseClientDetailCopyWith<$Res> {
  factory _$OrdersResponseClientDetailCopyWith(
          _OrdersResponseClientDetail value,
          $Res Function(_OrdersResponseClientDetail) _then) =
      __$OrdersResponseClientDetailCopyWithImpl;
  @override
  @useResult
  $Res call({String? org, String? manager, String? phone, int? type});
}

/// @nodoc
class __$OrdersResponseClientDetailCopyWithImpl<$Res>
    implements _$OrdersResponseClientDetailCopyWith<$Res> {
  __$OrdersResponseClientDetailCopyWithImpl(this._self, this._then);

  final _OrdersResponseClientDetail _self;
  final $Res Function(_OrdersResponseClientDetail) _then;

  /// Create a copy of OrdersResponseClientDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
    Object? type = freezed,
  }) {
    return _then(_OrdersResponseClientDetail(
      org: freezed == org
          ? _self.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _self.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$OrdersResponseOrderPhoto {
  int? get id;
  String? get type;
  @JsonKey(name: 'route_photo')
  List<OrdersResponseOrderRoutePhoto>? get routePhoto;

  /// Create a copy of OrdersResponseOrderPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseOrderPhotoCopyWith<OrdersResponseOrderPhoto> get copyWith =>
      _$OrdersResponseOrderPhotoCopyWithImpl<OrdersResponseOrderPhoto>(
          this as OrdersResponseOrderPhoto, _$identity);

  /// Serializes this OrdersResponseOrderPhoto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseOrderPhoto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.routePhoto, routePhoto));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, const DeepCollectionEquality().hash(routePhoto));

  @override
  String toString() {
    return 'OrdersResponseOrderPhoto(id: $id, type: $type, routePhoto: $routePhoto)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseOrderPhotoCopyWith<$Res> {
  factory $OrdersResponseOrderPhotoCopyWith(OrdersResponseOrderPhoto value,
          $Res Function(OrdersResponseOrderPhoto) _then) =
      _$OrdersResponseOrderPhotoCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String? type,
      @JsonKey(name: 'route_photo')
      List<OrdersResponseOrderRoutePhoto>? routePhoto});
}

/// @nodoc
class _$OrdersResponseOrderPhotoCopyWithImpl<$Res>
    implements $OrdersResponseOrderPhotoCopyWith<$Res> {
  _$OrdersResponseOrderPhotoCopyWithImpl(this._self, this._then);

  final OrdersResponseOrderPhoto _self;
  final $Res Function(OrdersResponseOrderPhoto) _then;

  /// Create a copy of OrdersResponseOrderPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? routePhoto = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      routePhoto: freezed == routePhoto
          ? _self.routePhoto
          : routePhoto // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderRoutePhoto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseOrderPhoto implements OrdersResponseOrderPhoto {
  const _OrdersResponseOrderPhoto(
      {this.id,
      this.type,
      @JsonKey(name: 'route_photo')
      final List<OrdersResponseOrderRoutePhoto>? routePhoto})
      : _routePhoto = routePhoto;
  factory _OrdersResponseOrderPhoto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseOrderPhotoFromJson(json);

  @override
  final int? id;
  @override
  final String? type;
  final List<OrdersResponseOrderRoutePhoto>? _routePhoto;
  @override
  @JsonKey(name: 'route_photo')
  List<OrdersResponseOrderRoutePhoto>? get routePhoto {
    final value = _routePhoto;
    if (value == null) return null;
    if (_routePhoto is EqualUnmodifiableListView) return _routePhoto;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of OrdersResponseOrderPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseOrderPhotoCopyWith<_OrdersResponseOrderPhoto> get copyWith =>
      __$OrdersResponseOrderPhotoCopyWithImpl<_OrdersResponseOrderPhoto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseOrderPhotoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseOrderPhoto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._routePhoto, _routePhoto));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, const DeepCollectionEquality().hash(_routePhoto));

  @override
  String toString() {
    return 'OrdersResponseOrderPhoto(id: $id, type: $type, routePhoto: $routePhoto)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseOrderPhotoCopyWith<$Res>
    implements $OrdersResponseOrderPhotoCopyWith<$Res> {
  factory _$OrdersResponseOrderPhotoCopyWith(_OrdersResponseOrderPhoto value,
          $Res Function(_OrdersResponseOrderPhoto) _then) =
      __$OrdersResponseOrderPhotoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String? type,
      @JsonKey(name: 'route_photo')
      List<OrdersResponseOrderRoutePhoto>? routePhoto});
}

/// @nodoc
class __$OrdersResponseOrderPhotoCopyWithImpl<$Res>
    implements _$OrdersResponseOrderPhotoCopyWith<$Res> {
  __$OrdersResponseOrderPhotoCopyWithImpl(this._self, this._then);

  final _OrdersResponseOrderPhoto _self;
  final $Res Function(_OrdersResponseOrderPhoto) _then;

  /// Create a copy of OrdersResponseOrderPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? routePhoto = freezed,
  }) {
    return _then(_OrdersResponseOrderPhoto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      routePhoto: freezed == routePhoto
          ? _self._routePhoto
          : routePhoto // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderRoutePhoto>?,
    ));
  }
}

/// @nodoc
mixin _$OrdersResponseOrderRoutePhoto {
  int? get id;
  String? get url;
  int? get status;
  String? get comment;

  /// Create a copy of OrdersResponseOrderRoutePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersResponseOrderRoutePhotoCopyWith<OrdersResponseOrderRoutePhoto>
      get copyWith => _$OrdersResponseOrderRoutePhotoCopyWithImpl<
              OrdersResponseOrderRoutePhoto>(
          this as OrdersResponseOrderRoutePhoto, _$identity);

  /// Serializes this OrdersResponseOrderRoutePhoto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersResponseOrderRoutePhoto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, status, comment);

  @override
  String toString() {
    return 'OrdersResponseOrderRoutePhoto(id: $id, url: $url, status: $status, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  factory $OrdersResponseOrderRoutePhotoCopyWith(
          OrdersResponseOrderRoutePhoto value,
          $Res Function(OrdersResponseOrderRoutePhoto) _then) =
      _$OrdersResponseOrderRoutePhotoCopyWithImpl;
  @useResult
  $Res call({int? id, String? url, int? status, String? comment});
}

/// @nodoc
class _$OrdersResponseOrderRoutePhotoCopyWithImpl<$Res>
    implements $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  _$OrdersResponseOrderRoutePhotoCopyWithImpl(this._self, this._then);

  final OrdersResponseOrderRoutePhoto _self;
  final $Res Function(OrdersResponseOrderRoutePhoto) _then;

  /// Create a copy of OrdersResponseOrderRoutePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? status = freezed,
    Object? comment = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersResponseOrderRoutePhoto implements OrdersResponseOrderRoutePhoto {
  const _OrdersResponseOrderRoutePhoto(
      {this.id, this.url, this.status, this.comment});
  factory _OrdersResponseOrderRoutePhoto.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseOrderRoutePhotoFromJson(json);

  @override
  final int? id;
  @override
  final String? url;
  @override
  final int? status;
  @override
  final String? comment;

  /// Create a copy of OrdersResponseOrderRoutePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersResponseOrderRoutePhotoCopyWith<_OrdersResponseOrderRoutePhoto>
      get copyWith => __$OrdersResponseOrderRoutePhotoCopyWithImpl<
          _OrdersResponseOrderRoutePhoto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersResponseOrderRoutePhotoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersResponseOrderRoutePhoto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, status, comment);

  @override
  String toString() {
    return 'OrdersResponseOrderRoutePhoto(id: $id, url: $url, status: $status, comment: $comment)';
  }
}

/// @nodoc
abstract mixin class _$OrdersResponseOrderRoutePhotoCopyWith<$Res>
    implements $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  factory _$OrdersResponseOrderRoutePhotoCopyWith(
          _OrdersResponseOrderRoutePhoto value,
          $Res Function(_OrdersResponseOrderRoutePhoto) _then) =
      __$OrdersResponseOrderRoutePhotoCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, String? url, int? status, String? comment});
}

/// @nodoc
class __$OrdersResponseOrderRoutePhotoCopyWithImpl<$Res>
    implements _$OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  __$OrdersResponseOrderRoutePhotoCopyWithImpl(this._self, this._then);

  final _OrdersResponseOrderRoutePhoto _self;
  final $Res Function(_OrdersResponseOrderRoutePhoto) _then;

  /// Create a copy of OrdersResponseOrderRoutePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? status = freezed,
    Object? comment = freezed,
  }) {
    return _then(_OrdersResponseOrderRoutePhoto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
