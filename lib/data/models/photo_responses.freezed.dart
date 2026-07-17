// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrdersRoutePhotoResponse {
  String? get url;

  /// Create a copy of OrdersRoutePhotoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersRoutePhotoResponseCopyWith<OrdersRoutePhotoResponse> get copyWith =>
      _$OrdersRoutePhotoResponseCopyWithImpl<OrdersRoutePhotoResponse>(
          this as OrdersRoutePhotoResponse, _$identity);

  /// Serializes this OrdersRoutePhotoResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersRoutePhotoResponse &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  @override
  String toString() {
    return 'OrdersRoutePhotoResponse(url: $url)';
  }
}

/// @nodoc
abstract mixin class $OrdersRoutePhotoResponseCopyWith<$Res> {
  factory $OrdersRoutePhotoResponseCopyWith(OrdersRoutePhotoResponse value,
          $Res Function(OrdersRoutePhotoResponse) _then) =
      _$OrdersRoutePhotoResponseCopyWithImpl;
  @useResult
  $Res call({String? url});
}

/// @nodoc
class _$OrdersRoutePhotoResponseCopyWithImpl<$Res>
    implements $OrdersRoutePhotoResponseCopyWith<$Res> {
  _$OrdersRoutePhotoResponseCopyWithImpl(this._self, this._then);

  final OrdersRoutePhotoResponse _self;
  final $Res Function(OrdersRoutePhotoResponse) _then;

  /// Create a copy of OrdersRoutePhotoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersRoutePhotoResponse implements OrdersRoutePhotoResponse {
  const _OrdersRoutePhotoResponse({this.url});
  factory _OrdersRoutePhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersRoutePhotoResponseFromJson(json);

  @override
  final String? url;

  /// Create a copy of OrdersRoutePhotoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersRoutePhotoResponseCopyWith<_OrdersRoutePhotoResponse> get copyWith =>
      __$OrdersRoutePhotoResponseCopyWithImpl<_OrdersRoutePhotoResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersRoutePhotoResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersRoutePhotoResponse &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  @override
  String toString() {
    return 'OrdersRoutePhotoResponse(url: $url)';
  }
}

/// @nodoc
abstract mixin class _$OrdersRoutePhotoResponseCopyWith<$Res>
    implements $OrdersRoutePhotoResponseCopyWith<$Res> {
  factory _$OrdersRoutePhotoResponseCopyWith(_OrdersRoutePhotoResponse value,
          $Res Function(_OrdersRoutePhotoResponse) _then) =
      __$OrdersRoutePhotoResponseCopyWithImpl;
  @override
  @useResult
  $Res call({String? url});
}

/// @nodoc
class __$OrdersRoutePhotoResponseCopyWithImpl<$Res>
    implements _$OrdersRoutePhotoResponseCopyWith<$Res> {
  __$OrdersRoutePhotoResponseCopyWithImpl(this._self, this._then);

  final _OrdersRoutePhotoResponse _self;
  final $Res Function(_OrdersRoutePhotoResponse) _then;

  /// Create a copy of OrdersRoutePhotoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_OrdersRoutePhotoResponse(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$OrdersRoutePhotoTypeResponse {
  @JsonKey(name: 'photo_id')
  int? get photoId;
  String? get url;

  /// Create a copy of OrdersRoutePhotoTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrdersRoutePhotoTypeResponseCopyWith<OrdersRoutePhotoTypeResponse>
      get copyWith => _$OrdersRoutePhotoTypeResponseCopyWithImpl<
              OrdersRoutePhotoTypeResponse>(
          this as OrdersRoutePhotoTypeResponse, _$identity);

  /// Serializes this OrdersRoutePhotoTypeResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrdersRoutePhotoTypeResponse &&
            (identical(other.photoId, photoId) || other.photoId == photoId) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, photoId, url);

  @override
  String toString() {
    return 'OrdersRoutePhotoTypeResponse(photoId: $photoId, url: $url)';
  }
}

/// @nodoc
abstract mixin class $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  factory $OrdersRoutePhotoTypeResponseCopyWith(
          OrdersRoutePhotoTypeResponse value,
          $Res Function(OrdersRoutePhotoTypeResponse) _then) =
      _$OrdersRoutePhotoTypeResponseCopyWithImpl;
  @useResult
  $Res call({@JsonKey(name: 'photo_id') int? photoId, String? url});
}

/// @nodoc
class _$OrdersRoutePhotoTypeResponseCopyWithImpl<$Res>
    implements $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  _$OrdersRoutePhotoTypeResponseCopyWithImpl(this._self, this._then);

  final OrdersRoutePhotoTypeResponse _self;
  final $Res Function(OrdersRoutePhotoTypeResponse) _then;

  /// Create a copy of OrdersRoutePhotoTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoId = freezed,
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      photoId: freezed == photoId
          ? _self.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _OrdersRoutePhotoTypeResponse implements OrdersRoutePhotoTypeResponse {
  const _OrdersRoutePhotoTypeResponse(
      {@JsonKey(name: 'photo_id') this.photoId, this.url});
  factory _OrdersRoutePhotoTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersRoutePhotoTypeResponseFromJson(json);

  @override
  @JsonKey(name: 'photo_id')
  final int? photoId;
  @override
  final String? url;

  /// Create a copy of OrdersRoutePhotoTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrdersRoutePhotoTypeResponseCopyWith<_OrdersRoutePhotoTypeResponse>
      get copyWith => __$OrdersRoutePhotoTypeResponseCopyWithImpl<
          _OrdersRoutePhotoTypeResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrdersRoutePhotoTypeResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrdersRoutePhotoTypeResponse &&
            (identical(other.photoId, photoId) || other.photoId == photoId) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, photoId, url);

  @override
  String toString() {
    return 'OrdersRoutePhotoTypeResponse(photoId: $photoId, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$OrdersRoutePhotoTypeResponseCopyWith<$Res>
    implements $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  factory _$OrdersRoutePhotoTypeResponseCopyWith(
          _OrdersRoutePhotoTypeResponse value,
          $Res Function(_OrdersRoutePhotoTypeResponse) _then) =
      __$OrdersRoutePhotoTypeResponseCopyWithImpl;
  @override
  @useResult
  $Res call({@JsonKey(name: 'photo_id') int? photoId, String? url});
}

/// @nodoc
class __$OrdersRoutePhotoTypeResponseCopyWithImpl<$Res>
    implements _$OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  __$OrdersRoutePhotoTypeResponseCopyWithImpl(this._self, this._then);

  final _OrdersRoutePhotoTypeResponse _self;
  final $Res Function(_OrdersRoutePhotoTypeResponse) _then;

  /// Create a copy of OrdersRoutePhotoTypeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? photoId = freezed,
    Object? url = freezed,
  }) {
    return _then(_OrdersRoutePhotoTypeResponse(
      photoId: freezed == photoId
          ? _self.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
