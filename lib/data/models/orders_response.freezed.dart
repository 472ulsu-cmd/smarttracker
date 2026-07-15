// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrdersResponseItem _$OrdersResponseItemFromJson(Map<String, dynamic> json) {
  return _OrdersResponseItem.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseItem {
  int? get id => throw _privateConstructorUsedError;
  String? get num => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;
  @JsonKey(name: 'route_from')
  String? get routeFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'route_to')
  String? get routeTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_date')
  String? get loadingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_working')
  int? get isWorking => throw _privateConstructorUsedError;
  OrdersResponseClient? get client => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseItemCopyWith<OrdersResponseItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseItemCopyWith<$Res> {
  factory $OrdersResponseItemCopyWith(
          OrdersResponseItem value, $Res Function(OrdersResponseItem) then) =
      _$OrdersResponseItemCopyWithImpl<$Res, OrdersResponseItem>;
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
}

/// @nodoc
class _$OrdersResponseItemCopyWithImpl<$Res, $Val extends OrdersResponseItem>
    implements $OrdersResponseItemCopyWith<$Res> {
  _$OrdersResponseItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      routeFrom: freezed == routeFrom
          ? _value.routeFrom
          : routeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTo: freezed == routeTo
          ? _value.routeTo
          : routeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _value.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _value.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: freezed == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as int?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersResponseItemImplCopyWith<$Res>
    implements $OrdersResponseItemCopyWith<$Res> {
  factory _$$OrdersResponseItemImplCopyWith(_$OrdersResponseItemImpl value,
          $Res Function(_$OrdersResponseItemImpl) then) =
      __$$OrdersResponseItemImplCopyWithImpl<$Res>;
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
}

/// @nodoc
class __$$OrdersResponseItemImplCopyWithImpl<$Res>
    extends _$OrdersResponseItemCopyWithImpl<$Res, _$OrdersResponseItemImpl>
    implements _$$OrdersResponseItemImplCopyWith<$Res> {
  __$$OrdersResponseItemImplCopyWithImpl(_$OrdersResponseItemImpl _value,
      $Res Function(_$OrdersResponseItemImpl) _then)
      : super(_value, _then);

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
    return _then(_$OrdersResponseItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      routeFrom: freezed == routeFrom
          ? _value.routeFrom
          : routeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      routeTo: freezed == routeTo
          ? _value.routeTo
          : routeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _value.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _value.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isWorking: freezed == isWorking
          ? _value.isWorking
          : isWorking // ignore: cast_nullable_to_non_nullable
              as int?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseItemImpl implements _OrdersResponseItem {
  const _$OrdersResponseItemImpl(
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

  factory _$OrdersResponseItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersResponseItemImplFromJson(json);

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

  @override
  String toString() {
    return 'OrdersResponseItem(id: $id, num: $num, status: $status, route: $route, routeFrom: $routeFrom, routeTo: $routeTo, loadingDate: $loadingDate, unloadingDate: $unloadingDate, isWorking: $isWorking, client: $client)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseItemImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, num, status, route,
      routeFrom, routeTo, loadingDate, unloadingDate, isWorking, client);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseItemImplCopyWith<_$OrdersResponseItemImpl> get copyWith =>
      __$$OrdersResponseItemImplCopyWithImpl<_$OrdersResponseItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseItemImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseItem implements OrdersResponseItem {
  const factory _OrdersResponseItem(
          {final int? id,
          final String? num,
          final int? status,
          final String? route,
          @JsonKey(name: 'route_from') final String? routeFrom,
          @JsonKey(name: 'route_to') final String? routeTo,
          @JsonKey(name: 'loading_date') final String? loadingDate,
          @JsonKey(name: 'unloading_date') final String? unloadingDate,
          @JsonKey(name: 'is_working') final int? isWorking,
          final OrdersResponseClient? client}) =
      _$OrdersResponseItemImpl;

  factory _OrdersResponseItem.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseItemImpl.fromJson;

  @override
  int? get id;
  @override
  String? get num;
  @override
  int? get status;
  @override
  String? get route;
  @override
  @JsonKey(name: 'route_from')
  String? get routeFrom;
  @override
  @JsonKey(name: 'route_to')
  String? get routeTo;
  @override
  @JsonKey(name: 'loading_date')
  String? get loadingDate;
  @override
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate;
  @override
  @JsonKey(name: 'is_working')
  int? get isWorking;
  @override
  OrdersResponseClient? get client;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseItemImplCopyWith<_$OrdersResponseItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrdersResponse _$OrdersResponseFromJson(Map<String, dynamic> json) {
  return _OrdersResponse.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponse {
  int? get id => throw _privateConstructorUsedError;
  String? get num => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_type')
  String? get cargoType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableToString)
  String? get mass => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableToString)
  String? get volume => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_date')
  String? get loadingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_time_from')
  String? get loadingTimeFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_time_to')
  String? get loadingTimeTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_time_from')
  String? get unloadingTimeFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'unloading_time_to')
  String? get unloadingTimeTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat_start')
  double? get latStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'lng_start')
  double? get lngStart => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat_fin')
  double? get latFin => throw _privateConstructorUsedError;
  @JsonKey(name: 'lng_fin')
  double? get lngFin => throw _privateConstructorUsedError;
  OrdersResponseClient? get client => throw _privateConstructorUsedError;
  @JsonKey(name: 'route_details')
  List<OrdersResponseRouteDetail>? get routeDetails =>
      throw _privateConstructorUsedError;
  List<OrdersResponseOrderPhoto>? get photo =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseCopyWith<OrdersResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseCopyWith<$Res> {
  factory $OrdersResponseCopyWith(
          OrdersResponse value, $Res Function(OrdersResponse) then) =
      _$OrdersResponseCopyWithImpl<$Res, OrdersResponse>;
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
class _$OrdersResponseCopyWithImpl<$Res, $Val extends OrdersResponse>
    implements $OrdersResponseCopyWith<$Res> {
  _$OrdersResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _value.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _value.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _value.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _value.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeFrom: freezed == loadingTimeFrom
          ? _value.loadingTimeFrom
          : loadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeTo: freezed == loadingTimeTo
          ? _value.loadingTimeTo
          : loadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeFrom: freezed == unloadingTimeFrom
          ? _value.unloadingTimeFrom
          : unloadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeTo: freezed == unloadingTimeTo
          ? _value.unloadingTimeTo
          : unloadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      latStart: freezed == latStart
          ? _value.latStart
          : latStart // ignore: cast_nullable_to_non_nullable
              as double?,
      lngStart: freezed == lngStart
          ? _value.lngStart
          : lngStart // ignore: cast_nullable_to_non_nullable
              as double?,
      latFin: freezed == latFin
          ? _value.latFin
          : latFin // ignore: cast_nullable_to_non_nullable
              as double?,
      lngFin: freezed == lngFin
          ? _value.lngFin
          : lngFin // ignore: cast_nullable_to_non_nullable
              as double?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
      routeDetails: freezed == routeDetails
          ? _value.routeDetails
          : routeDetails // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseRouteDetail>?,
      photo: freezed == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderPhoto>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientCopyWith<$Res>? get client {
    if (_value.client == null) {
      return null;
    }

    return $OrdersResponseClientCopyWith<$Res>(_value.client!, (value) {
      return _then(_value.copyWith(client: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrdersResponseImplCopyWith<$Res>
    implements $OrdersResponseCopyWith<$Res> {
  factory _$$OrdersResponseImplCopyWith(_$OrdersResponseImpl value,
          $Res Function(_$OrdersResponseImpl) then) =
      __$$OrdersResponseImplCopyWithImpl<$Res>;
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
class __$$OrdersResponseImplCopyWithImpl<$Res>
    extends _$OrdersResponseCopyWithImpl<$Res, _$OrdersResponseImpl>
    implements _$$OrdersResponseImplCopyWith<$Res> {
  __$$OrdersResponseImplCopyWithImpl(
      _$OrdersResponseImpl _value, $Res Function(_$OrdersResponseImpl) _then)
      : super(_value, _then);

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
    return _then(_$OrdersResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      num: freezed == num
          ? _value.num
          : num // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _value.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _value.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingDate: freezed == loadingDate
          ? _value.loadingDate
          : loadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingDate: freezed == unloadingDate
          ? _value.unloadingDate
          : unloadingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeFrom: freezed == loadingTimeFrom
          ? _value.loadingTimeFrom
          : loadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingTimeTo: freezed == loadingTimeTo
          ? _value.loadingTimeTo
          : loadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeFrom: freezed == unloadingTimeFrom
          ? _value.unloadingTimeFrom
          : unloadingTimeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      unloadingTimeTo: freezed == unloadingTimeTo
          ? _value.unloadingTimeTo
          : unloadingTimeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      latStart: freezed == latStart
          ? _value.latStart
          : latStart // ignore: cast_nullable_to_non_nullable
              as double?,
      lngStart: freezed == lngStart
          ? _value.lngStart
          : lngStart // ignore: cast_nullable_to_non_nullable
              as double?,
      latFin: freezed == latFin
          ? _value.latFin
          : latFin // ignore: cast_nullable_to_non_nullable
              as double?,
      lngFin: freezed == lngFin
          ? _value.lngFin
          : lngFin // ignore: cast_nullable_to_non_nullable
              as double?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClient?,
      routeDetails: freezed == routeDetails
          ? _value._routeDetails
          : routeDetails // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseRouteDetail>?,
      photo: freezed == photo
          ? _value._photo
          : photo // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderPhoto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseImpl implements _OrdersResponse {
  const _$OrdersResponseImpl(
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

  factory _$OrdersResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersResponseImplFromJson(json);

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

  @override
  String toString() {
    return 'OrdersResponse(id: $id, num: $num, status: $status, route: $route, cargoType: $cargoType, mass: $mass, volume: $volume, loadingDate: $loadingDate, unloadingDate: $unloadingDate, loadingTimeFrom: $loadingTimeFrom, loadingTimeTo: $loadingTimeTo, unloadingTimeFrom: $unloadingTimeFrom, unloadingTimeTo: $unloadingTimeTo, latStart: $latStart, lngStart: $lngStart, latFin: $latFin, lngFin: $lngFin, client: $client, routeDetails: $routeDetails, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseImpl &&
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

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseImplCopyWith<_$OrdersResponseImpl> get copyWith =>
      __$$OrdersResponseImplCopyWithImpl<_$OrdersResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponse implements OrdersResponse {
  const factory _OrdersResponse(
      {final int? id,
      final String? num,
      final int? status,
      final String? route,
      @JsonKey(name: 'cargo_type') final String? cargoType,
      @JsonKey(fromJson: _nullableToString) final String? mass,
      @JsonKey(fromJson: _nullableToString) final String? volume,
      @JsonKey(name: 'loading_date') final String? loadingDate,
      @JsonKey(name: 'unloading_date') final String? unloadingDate,
      @JsonKey(name: 'loading_time_from') final String? loadingTimeFrom,
      @JsonKey(name: 'loading_time_to') final String? loadingTimeTo,
      @JsonKey(name: 'unloading_time_from') final String? unloadingTimeFrom,
      @JsonKey(name: 'unloading_time_to') final String? unloadingTimeTo,
      @JsonKey(name: 'lat_start') final double? latStart,
      @JsonKey(name: 'lng_start') final double? lngStart,
      @JsonKey(name: 'lat_fin') final double? latFin,
      @JsonKey(name: 'lng_fin') final double? lngFin,
      final OrdersResponseClient? client,
      @JsonKey(name: 'route_details')
      final List<OrdersResponseRouteDetail>? routeDetails,
      final List<OrdersResponseOrderPhoto>? photo}) = _$OrdersResponseImpl;

  factory _OrdersResponse.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseImpl.fromJson;

  @override
  int? get id;
  @override
  String? get num;
  @override
  int? get status;
  @override
  String? get route;
  @override
  @JsonKey(name: 'cargo_type')
  String? get cargoType;
  @override
  @JsonKey(fromJson: _nullableToString)
  String? get mass;
  @override
  @JsonKey(fromJson: _nullableToString)
  String? get volume;
  @override
  @JsonKey(name: 'loading_date')
  String? get loadingDate;
  @override
  @JsonKey(name: 'unloading_date')
  String? get unloadingDate;
  @override
  @JsonKey(name: 'loading_time_from')
  String? get loadingTimeFrom;
  @override
  @JsonKey(name: 'loading_time_to')
  String? get loadingTimeTo;
  @override
  @JsonKey(name: 'unloading_time_from')
  String? get unloadingTimeFrom;
  @override
  @JsonKey(name: 'unloading_time_to')
  String? get unloadingTimeTo;
  @override
  @JsonKey(name: 'lat_start')
  double? get latStart;
  @override
  @JsonKey(name: 'lng_start')
  double? get lngStart;
  @override
  @JsonKey(name: 'lat_fin')
  double? get latFin;
  @override
  @JsonKey(name: 'lng_fin')
  double? get lngFin;
  @override
  OrdersResponseClient? get client;
  @override
  @JsonKey(name: 'route_details')
  List<OrdersResponseRouteDetail>? get routeDetails;
  @override
  List<OrdersResponseOrderPhoto>? get photo;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseImplCopyWith<_$OrdersResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrdersResponseClient _$OrdersResponseClientFromJson(Map<String, dynamic> json) {
  return _OrdersResponseClient.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseClient {
  String? get org => throw _privateConstructorUsedError;
  String? get manager => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseClientCopyWith<OrdersResponseClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseClientCopyWith<$Res> {
  factory $OrdersResponseClientCopyWith(OrdersResponseClient value,
          $Res Function(OrdersResponseClient) then) =
      _$OrdersResponseClientCopyWithImpl<$Res, OrdersResponseClient>;
  @useResult
  $Res call({String? org, String? manager, String? phone});
}

/// @nodoc
class _$OrdersResponseClientCopyWithImpl<$Res,
        $Val extends OrdersResponseClient>
    implements $OrdersResponseClientCopyWith<$Res> {
  _$OrdersResponseClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
  }) {
    return _then(_value.copyWith(
      org: freezed == org
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersResponseClientImplCopyWith<$Res>
    implements $OrdersResponseClientCopyWith<$Res> {
  factory _$$OrdersResponseClientImplCopyWith(_$OrdersResponseClientImpl value,
          $Res Function(_$OrdersResponseClientImpl) then) =
      __$$OrdersResponseClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? org, String? manager, String? phone});
}

/// @nodoc
class __$$OrdersResponseClientImplCopyWithImpl<$Res>
    extends _$OrdersResponseClientCopyWithImpl<$Res, _$OrdersResponseClientImpl>
    implements _$$OrdersResponseClientImplCopyWith<$Res> {
  __$$OrdersResponseClientImplCopyWithImpl(_$OrdersResponseClientImpl _value,
      $Res Function(_$OrdersResponseClientImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
  }) {
    return _then(_$OrdersResponseClientImpl(
      org: freezed == org
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseClientImpl implements _OrdersResponseClient {
  const _$OrdersResponseClientImpl({this.org, this.manager, this.phone});

  factory _$OrdersResponseClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersResponseClientImplFromJson(json);

  @override
  final String? org;
  @override
  final String? manager;
  @override
  final String? phone;

  @override
  String toString() {
    return 'OrdersResponseClient(org: $org, manager: $manager, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseClientImpl &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseClientImplCopyWith<_$OrdersResponseClientImpl>
      get copyWith =>
          __$$OrdersResponseClientImplCopyWithImpl<_$OrdersResponseClientImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseClientImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseClient implements OrdersResponseClient {
  const factory _OrdersResponseClient(
      {final String? org,
      final String? manager,
      final String? phone}) = _$OrdersResponseClientImpl;

  factory _OrdersResponseClient.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseClientImpl.fromJson;

  @override
  String? get org;
  @override
  String? get manager;
  @override
  String? get phone;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseClientImplCopyWith<_$OrdersResponseClientImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrdersResponseRouteDetail _$OrdersResponseRouteDetailFromJson(
    Map<String, dynamic> json) {
  return _OrdersResponseRouteDetail.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseRouteDetail {
  @JsonKey(name: 'route_detail_id')
  int? get routeDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'operation_type')
  int? get operationType => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_from')
  String? get timeFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_to')
  String? get timeTo => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'cargo_type')
  String? get cargoType => throw _privateConstructorUsedError;
  @JsonKey(name: 'loading_method')
  String? get loadingMethod => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableToString)
  String? get mass => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _nullableToString)
  String? get volume => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  @JsonKey(name: 'client_detail')
  OrdersResponseClientDetail? get clientDetail =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseRouteDetailCopyWith<OrdersResponseRouteDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseRouteDetailCopyWith<$Res> {
  factory $OrdersResponseRouteDetailCopyWith(OrdersResponseRouteDetail value,
          $Res Function(OrdersResponseRouteDetail) then) =
      _$OrdersResponseRouteDetailCopyWithImpl<$Res, OrdersResponseRouteDetail>;
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
class _$OrdersResponseRouteDetailCopyWithImpl<$Res,
        $Val extends OrdersResponseRouteDetail>
    implements $OrdersResponseRouteDetailCopyWith<$Res> {
  _$OrdersResponseRouteDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      routeDetailId: freezed == routeDetailId
          ? _value.routeDetailId
          : routeDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      timeFrom: freezed == timeFrom
          ? _value.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTo: freezed == timeTo
          ? _value.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _value.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMethod: freezed == loadingMethod
          ? _value.loadingMethod
          : loadingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _value.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      clientDetail: freezed == clientDetail
          ? _value.clientDetail
          : clientDetail // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClientDetail?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrdersResponseClientDetailCopyWith<$Res>? get clientDetail {
    if (_value.clientDetail == null) {
      return null;
    }

    return $OrdersResponseClientDetailCopyWith<$Res>(_value.clientDetail!,
        (value) {
      return _then(_value.copyWith(clientDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrdersResponseRouteDetailImplCopyWith<$Res>
    implements $OrdersResponseRouteDetailCopyWith<$Res> {
  factory _$$OrdersResponseRouteDetailImplCopyWith(
          _$OrdersResponseRouteDetailImpl value,
          $Res Function(_$OrdersResponseRouteDetailImpl) then) =
      __$$OrdersResponseRouteDetailImplCopyWithImpl<$Res>;
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
class __$$OrdersResponseRouteDetailImplCopyWithImpl<$Res>
    extends _$OrdersResponseRouteDetailCopyWithImpl<$Res,
        _$OrdersResponseRouteDetailImpl>
    implements _$$OrdersResponseRouteDetailImplCopyWith<$Res> {
  __$$OrdersResponseRouteDetailImplCopyWithImpl(
      _$OrdersResponseRouteDetailImpl _value,
      $Res Function(_$OrdersResponseRouteDetailImpl) _then)
      : super(_value, _then);

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
    return _then(_$OrdersResponseRouteDetailImpl(
      routeDetailId: freezed == routeDetailId
          ? _value.routeDetailId
          : routeDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      operationType: freezed == operationType
          ? _value.operationType
          : operationType // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      timeFrom: freezed == timeFrom
          ? _value.timeFrom
          : timeFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      timeTo: freezed == timeTo
          ? _value.timeTo
          : timeTo // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      cargoType: freezed == cargoType
          ? _value.cargoType
          : cargoType // ignore: cast_nullable_to_non_nullable
              as String?,
      loadingMethod: freezed == loadingMethod
          ? _value.loadingMethod
          : loadingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      mass: freezed == mass
          ? _value.mass
          : mass // ignore: cast_nullable_to_non_nullable
              as String?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      clientDetail: freezed == clientDetail
          ? _value.clientDetail
          : clientDetail // ignore: cast_nullable_to_non_nullable
              as OrdersResponseClientDetail?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseRouteDetailImpl implements _OrdersResponseRouteDetail {
  const _$OrdersResponseRouteDetailImpl(
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

  factory _$OrdersResponseRouteDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersResponseRouteDetailImplFromJson(json);

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

  @override
  String toString() {
    return 'OrdersResponseRouteDetail(routeDetailId: $routeDetailId, operationType: $operationType, city: $city, address: $address, date: $date, timeFrom: $timeFrom, timeTo: $timeTo, comment: $comment, cargoType: $cargoType, loadingMethod: $loadingMethod, mass: $mass, volume: $volume, lat: $lat, lon: $lon, clientDetail: $clientDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseRouteDetailImpl &&
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

  @JsonKey(ignore: true)
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

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseRouteDetailImplCopyWith<_$OrdersResponseRouteDetailImpl>
      get copyWith => __$$OrdersResponseRouteDetailImplCopyWithImpl<
          _$OrdersResponseRouteDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseRouteDetailImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseRouteDetail implements OrdersResponseRouteDetail {
  const factory _OrdersResponseRouteDetail(
          {@JsonKey(name: 'route_detail_id') final int? routeDetailId,
          @JsonKey(name: 'operation_type') final int? operationType,
          final String? city,
          final String? address,
          final String? date,
          @JsonKey(name: 'time_from') final String? timeFrom,
          @JsonKey(name: 'time_to') final String? timeTo,
          final String? comment,
          @JsonKey(name: 'cargo_type') final String? cargoType,
          @JsonKey(name: 'loading_method') final String? loadingMethod,
          @JsonKey(fromJson: _nullableToString) final String? mass,
          @JsonKey(fromJson: _nullableToString) final String? volume,
          final double? lat,
          final double? lon,
          @JsonKey(name: 'client_detail')
          final OrdersResponseClientDetail? clientDetail}) =
      _$OrdersResponseRouteDetailImpl;

  factory _OrdersResponseRouteDetail.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseRouteDetailImpl.fromJson;

  @override
  @JsonKey(name: 'route_detail_id')
  int? get routeDetailId;
  @override
  @JsonKey(name: 'operation_type')
  int? get operationType;
  @override
  String? get city;
  @override
  String? get address;
  @override
  String? get date;
  @override
  @JsonKey(name: 'time_from')
  String? get timeFrom;
  @override
  @JsonKey(name: 'time_to')
  String? get timeTo;
  @override
  String? get comment;
  @override
  @JsonKey(name: 'cargo_type')
  String? get cargoType;
  @override
  @JsonKey(name: 'loading_method')
  String? get loadingMethod;
  @override
  @JsonKey(fromJson: _nullableToString)
  String? get mass;
  @override
  @JsonKey(fromJson: _nullableToString)
  String? get volume;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  @JsonKey(name: 'client_detail')
  OrdersResponseClientDetail? get clientDetail;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseRouteDetailImplCopyWith<_$OrdersResponseRouteDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrdersResponseClientDetail _$OrdersResponseClientDetailFromJson(
    Map<String, dynamic> json) {
  return _OrdersResponseClientDetail.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseClientDetail {
  String? get org => throw _privateConstructorUsedError;
  String? get manager => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseClientDetailCopyWith<OrdersResponseClientDetail>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseClientDetailCopyWith<$Res> {
  factory $OrdersResponseClientDetailCopyWith(OrdersResponseClientDetail value,
          $Res Function(OrdersResponseClientDetail) then) =
      _$OrdersResponseClientDetailCopyWithImpl<$Res,
          OrdersResponseClientDetail>;
  @useResult
  $Res call({String? org, String? manager, String? phone, int? type});
}

/// @nodoc
class _$OrdersResponseClientDetailCopyWithImpl<$Res,
        $Val extends OrdersResponseClientDetail>
    implements $OrdersResponseClientDetailCopyWith<$Res> {
  _$OrdersResponseClientDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      org: freezed == org
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersResponseClientDetailImplCopyWith<$Res>
    implements $OrdersResponseClientDetailCopyWith<$Res> {
  factory _$$OrdersResponseClientDetailImplCopyWith(
          _$OrdersResponseClientDetailImpl value,
          $Res Function(_$OrdersResponseClientDetailImpl) then) =
      __$$OrdersResponseClientDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? org, String? manager, String? phone, int? type});
}

/// @nodoc
class __$$OrdersResponseClientDetailImplCopyWithImpl<$Res>
    extends _$OrdersResponseClientDetailCopyWithImpl<$Res,
        _$OrdersResponseClientDetailImpl>
    implements _$$OrdersResponseClientDetailImplCopyWith<$Res> {
  __$$OrdersResponseClientDetailImplCopyWithImpl(
      _$OrdersResponseClientDetailImpl _value,
      $Res Function(_$OrdersResponseClientDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? org = freezed,
    Object? manager = freezed,
    Object? phone = freezed,
    Object? type = freezed,
  }) {
    return _then(_$OrdersResponseClientDetailImpl(
      org: freezed == org
          ? _value.org
          : org // ignore: cast_nullable_to_non_nullable
              as String?,
      manager: freezed == manager
          ? _value.manager
          : manager // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseClientDetailImpl implements _OrdersResponseClientDetail {
  const _$OrdersResponseClientDetailImpl(
      {this.org, this.manager, this.phone, this.type});

  factory _$OrdersResponseClientDetailImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrdersResponseClientDetailImplFromJson(json);

  @override
  final String? org;
  @override
  final String? manager;
  @override
  final String? phone;
  @override
  final int? type;

  @override
  String toString() {
    return 'OrdersResponseClientDetail(org: $org, manager: $manager, phone: $phone, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseClientDetailImpl &&
            (identical(other.org, org) || other.org == org) &&
            (identical(other.manager, manager) || other.manager == manager) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, org, manager, phone, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseClientDetailImplCopyWith<_$OrdersResponseClientDetailImpl>
      get copyWith => __$$OrdersResponseClientDetailImplCopyWithImpl<
          _$OrdersResponseClientDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseClientDetailImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseClientDetail
    implements OrdersResponseClientDetail {
  const factory _OrdersResponseClientDetail(
      {final String? org,
      final String? manager,
      final String? phone,
      final int? type}) = _$OrdersResponseClientDetailImpl;

  factory _OrdersResponseClientDetail.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseClientDetailImpl.fromJson;

  @override
  String? get org;
  @override
  String? get manager;
  @override
  String? get phone;
  @override
  int? get type;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseClientDetailImplCopyWith<_$OrdersResponseClientDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrdersResponseOrderPhoto _$OrdersResponseOrderPhotoFromJson(
    Map<String, dynamic> json) {
  return _OrdersResponseOrderPhoto.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseOrderPhoto {
  int? get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'route_photo')
  List<OrdersResponseOrderRoutePhoto>? get routePhoto =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseOrderPhotoCopyWith<OrdersResponseOrderPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseOrderPhotoCopyWith<$Res> {
  factory $OrdersResponseOrderPhotoCopyWith(OrdersResponseOrderPhoto value,
          $Res Function(OrdersResponseOrderPhoto) then) =
      _$OrdersResponseOrderPhotoCopyWithImpl<$Res, OrdersResponseOrderPhoto>;
  @useResult
  $Res call(
      {int? id,
      String? type,
      @JsonKey(name: 'route_photo')
      List<OrdersResponseOrderRoutePhoto>? routePhoto});
}

/// @nodoc
class _$OrdersResponseOrderPhotoCopyWithImpl<$Res,
        $Val extends OrdersResponseOrderPhoto>
    implements $OrdersResponseOrderPhotoCopyWith<$Res> {
  _$OrdersResponseOrderPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? routePhoto = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      routePhoto: freezed == routePhoto
          ? _value.routePhoto
          : routePhoto // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderRoutePhoto>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersResponseOrderPhotoImplCopyWith<$Res>
    implements $OrdersResponseOrderPhotoCopyWith<$Res> {
  factory _$$OrdersResponseOrderPhotoImplCopyWith(
          _$OrdersResponseOrderPhotoImpl value,
          $Res Function(_$OrdersResponseOrderPhotoImpl) then) =
      __$$OrdersResponseOrderPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? type,
      @JsonKey(name: 'route_photo')
      List<OrdersResponseOrderRoutePhoto>? routePhoto});
}

/// @nodoc
class __$$OrdersResponseOrderPhotoImplCopyWithImpl<$Res>
    extends _$OrdersResponseOrderPhotoCopyWithImpl<$Res,
        _$OrdersResponseOrderPhotoImpl>
    implements _$$OrdersResponseOrderPhotoImplCopyWith<$Res> {
  __$$OrdersResponseOrderPhotoImplCopyWithImpl(
      _$OrdersResponseOrderPhotoImpl _value,
      $Res Function(_$OrdersResponseOrderPhotoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = freezed,
    Object? routePhoto = freezed,
  }) {
    return _then(_$OrdersResponseOrderPhotoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      routePhoto: freezed == routePhoto
          ? _value._routePhoto
          : routePhoto // ignore: cast_nullable_to_non_nullable
              as List<OrdersResponseOrderRoutePhoto>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseOrderPhotoImpl implements _OrdersResponseOrderPhoto {
  const _$OrdersResponseOrderPhotoImpl(
      {this.id,
      this.type,
      @JsonKey(name: 'route_photo')
      final List<OrdersResponseOrderRoutePhoto>? routePhoto})
      : _routePhoto = routePhoto;

  factory _$OrdersResponseOrderPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersResponseOrderPhotoImplFromJson(json);

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

  @override
  String toString() {
    return 'OrdersResponseOrderPhoto(id: $id, type: $type, routePhoto: $routePhoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseOrderPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._routePhoto, _routePhoto));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, const DeepCollectionEquality().hash(_routePhoto));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseOrderPhotoImplCopyWith<_$OrdersResponseOrderPhotoImpl>
      get copyWith => __$$OrdersResponseOrderPhotoImplCopyWithImpl<
          _$OrdersResponseOrderPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseOrderPhotoImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseOrderPhoto implements OrdersResponseOrderPhoto {
  const factory _OrdersResponseOrderPhoto(
          {final int? id,
          final String? type,
          @JsonKey(name: 'route_photo')
          final List<OrdersResponseOrderRoutePhoto>? routePhoto}) =
      _$OrdersResponseOrderPhotoImpl;

  factory _OrdersResponseOrderPhoto.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseOrderPhotoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get type;
  @override
  @JsonKey(name: 'route_photo')
  List<OrdersResponseOrderRoutePhoto>? get routePhoto;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseOrderPhotoImplCopyWith<_$OrdersResponseOrderPhotoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrdersResponseOrderRoutePhoto _$OrdersResponseOrderRoutePhotoFromJson(
    Map<String, dynamic> json) {
  return _OrdersResponseOrderRoutePhoto.fromJson(json);
}

/// @nodoc
mixin _$OrdersResponseOrderRoutePhoto {
  int? get id => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersResponseOrderRoutePhotoCopyWith<OrdersResponseOrderRoutePhoto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  factory $OrdersResponseOrderRoutePhotoCopyWith(
          OrdersResponseOrderRoutePhoto value,
          $Res Function(OrdersResponseOrderRoutePhoto) then) =
      _$OrdersResponseOrderRoutePhotoCopyWithImpl<$Res,
          OrdersResponseOrderRoutePhoto>;
  @useResult
  $Res call({int? id, String? url, int? status, String? comment});
}

/// @nodoc
class _$OrdersResponseOrderRoutePhotoCopyWithImpl<$Res,
        $Val extends OrdersResponseOrderRoutePhoto>
    implements $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  _$OrdersResponseOrderRoutePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? status = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersResponseOrderRoutePhotoImplCopyWith<$Res>
    implements $OrdersResponseOrderRoutePhotoCopyWith<$Res> {
  factory _$$OrdersResponseOrderRoutePhotoImplCopyWith(
          _$OrdersResponseOrderRoutePhotoImpl value,
          $Res Function(_$OrdersResponseOrderRoutePhotoImpl) then) =
      __$$OrdersResponseOrderRoutePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String? url, int? status, String? comment});
}

/// @nodoc
class __$$OrdersResponseOrderRoutePhotoImplCopyWithImpl<$Res>
    extends _$OrdersResponseOrderRoutePhotoCopyWithImpl<$Res,
        _$OrdersResponseOrderRoutePhotoImpl>
    implements _$$OrdersResponseOrderRoutePhotoImplCopyWith<$Res> {
  __$$OrdersResponseOrderRoutePhotoImplCopyWithImpl(
      _$OrdersResponseOrderRoutePhotoImpl _value,
      $Res Function(_$OrdersResponseOrderRoutePhotoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? status = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$OrdersResponseOrderRoutePhotoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersResponseOrderRoutePhotoImpl
    implements _OrdersResponseOrderRoutePhoto {
  const _$OrdersResponseOrderRoutePhotoImpl(
      {this.id, this.url, this.status, this.comment});

  factory _$OrdersResponseOrderRoutePhotoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrdersResponseOrderRoutePhotoImplFromJson(json);

  @override
  final int? id;
  @override
  final String? url;
  @override
  final int? status;
  @override
  final String? comment;

  @override
  String toString() {
    return 'OrdersResponseOrderRoutePhoto(id: $id, url: $url, status: $status, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersResponseOrderRoutePhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, url, status, comment);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersResponseOrderRoutePhotoImplCopyWith<
          _$OrdersResponseOrderRoutePhotoImpl>
      get copyWith => __$$OrdersResponseOrderRoutePhotoImplCopyWithImpl<
          _$OrdersResponseOrderRoutePhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersResponseOrderRoutePhotoImplToJson(
      this,
    );
  }
}

abstract class _OrdersResponseOrderRoutePhoto
    implements OrdersResponseOrderRoutePhoto {
  const factory _OrdersResponseOrderRoutePhoto(
      {final int? id,
      final String? url,
      final int? status,
      final String? comment}) = _$OrdersResponseOrderRoutePhotoImpl;

  factory _OrdersResponseOrderRoutePhoto.fromJson(Map<String, dynamic> json) =
      _$OrdersResponseOrderRoutePhotoImpl.fromJson;

  @override
  int? get id;
  @override
  String? get url;
  @override
  int? get status;
  @override
  String? get comment;
  @override
  @JsonKey(ignore: true)
  _$$OrdersResponseOrderRoutePhotoImplCopyWith<
          _$OrdersResponseOrderRoutePhotoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
