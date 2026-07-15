// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrdersRoutePhotoResponse _$OrdersRoutePhotoResponseFromJson(
    Map<String, dynamic> json) {
  return _OrdersRoutePhotoResponse.fromJson(json);
}

/// @nodoc
mixin _$OrdersRoutePhotoResponse {
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersRoutePhotoResponseCopyWith<OrdersRoutePhotoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersRoutePhotoResponseCopyWith<$Res> {
  factory $OrdersRoutePhotoResponseCopyWith(OrdersRoutePhotoResponse value,
          $Res Function(OrdersRoutePhotoResponse) then) =
      _$OrdersRoutePhotoResponseCopyWithImpl<$Res, OrdersRoutePhotoResponse>;
  @useResult
  $Res call({String? url});
}

/// @nodoc
class _$OrdersRoutePhotoResponseCopyWithImpl<$Res,
        $Val extends OrdersRoutePhotoResponse>
    implements $OrdersRoutePhotoResponseCopyWith<$Res> {
  _$OrdersRoutePhotoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersRoutePhotoResponseImplCopyWith<$Res>
    implements $OrdersRoutePhotoResponseCopyWith<$Res> {
  factory _$$OrdersRoutePhotoResponseImplCopyWith(
          _$OrdersRoutePhotoResponseImpl value,
          $Res Function(_$OrdersRoutePhotoResponseImpl) then) =
      __$$OrdersRoutePhotoResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url});
}

/// @nodoc
class __$$OrdersRoutePhotoResponseImplCopyWithImpl<$Res>
    extends _$OrdersRoutePhotoResponseCopyWithImpl<$Res,
        _$OrdersRoutePhotoResponseImpl>
    implements _$$OrdersRoutePhotoResponseImplCopyWith<$Res> {
  __$$OrdersRoutePhotoResponseImplCopyWithImpl(
      _$OrdersRoutePhotoResponseImpl _value,
      $Res Function(_$OrdersRoutePhotoResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_$OrdersRoutePhotoResponseImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersRoutePhotoResponseImpl implements _OrdersRoutePhotoResponse {
  const _$OrdersRoutePhotoResponseImpl({this.url});

  factory _$OrdersRoutePhotoResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersRoutePhotoResponseImplFromJson(json);

  @override
  final String? url;

  @override
  String toString() {
    return 'OrdersRoutePhotoResponse(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersRoutePhotoResponseImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersRoutePhotoResponseImplCopyWith<_$OrdersRoutePhotoResponseImpl>
      get copyWith => __$$OrdersRoutePhotoResponseImplCopyWithImpl<
          _$OrdersRoutePhotoResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersRoutePhotoResponseImplToJson(
      this,
    );
  }
}

abstract class _OrdersRoutePhotoResponse implements OrdersRoutePhotoResponse {
  const factory _OrdersRoutePhotoResponse({final String? url}) =
      _$OrdersRoutePhotoResponseImpl;

  factory _OrdersRoutePhotoResponse.fromJson(Map<String, dynamic> json) =
      _$OrdersRoutePhotoResponseImpl.fromJson;

  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$OrdersRoutePhotoResponseImplCopyWith<_$OrdersRoutePhotoResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrdersRoutePhotoTypeResponse _$OrdersRoutePhotoTypeResponseFromJson(
    Map<String, dynamic> json) {
  return _OrdersRoutePhotoTypeResponse.fromJson(json);
}

/// @nodoc
mixin _$OrdersRoutePhotoTypeResponse {
  @JsonKey(name: 'photo_id')
  int? get photoId => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersRoutePhotoTypeResponseCopyWith<OrdersRoutePhotoTypeResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  factory $OrdersRoutePhotoTypeResponseCopyWith(
          OrdersRoutePhotoTypeResponse value,
          $Res Function(OrdersRoutePhotoTypeResponse) then) =
      _$OrdersRoutePhotoTypeResponseCopyWithImpl<$Res,
          OrdersRoutePhotoTypeResponse>;
  @useResult
  $Res call({@JsonKey(name: 'photo_id') int? photoId, String? url});
}

/// @nodoc
class _$OrdersRoutePhotoTypeResponseCopyWithImpl<$Res,
        $Val extends OrdersRoutePhotoTypeResponse>
    implements $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  _$OrdersRoutePhotoTypeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoId = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      photoId: freezed == photoId
          ? _value.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersRoutePhotoTypeResponseImplCopyWith<$Res>
    implements $OrdersRoutePhotoTypeResponseCopyWith<$Res> {
  factory _$$OrdersRoutePhotoTypeResponseImplCopyWith(
          _$OrdersRoutePhotoTypeResponseImpl value,
          $Res Function(_$OrdersRoutePhotoTypeResponseImpl) then) =
      __$$OrdersRoutePhotoTypeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'photo_id') int? photoId, String? url});
}

/// @nodoc
class __$$OrdersRoutePhotoTypeResponseImplCopyWithImpl<$Res>
    extends _$OrdersRoutePhotoTypeResponseCopyWithImpl<$Res,
        _$OrdersRoutePhotoTypeResponseImpl>
    implements _$$OrdersRoutePhotoTypeResponseImplCopyWith<$Res> {
  __$$OrdersRoutePhotoTypeResponseImplCopyWithImpl(
      _$OrdersRoutePhotoTypeResponseImpl _value,
      $Res Function(_$OrdersRoutePhotoTypeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoId = freezed,
    Object? url = freezed,
  }) {
    return _then(_$OrdersRoutePhotoTypeResponseImpl(
      photoId: freezed == photoId
          ? _value.photoId
          : photoId // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersRoutePhotoTypeResponseImpl
    implements _OrdersRoutePhotoTypeResponse {
  const _$OrdersRoutePhotoTypeResponseImpl(
      {@JsonKey(name: 'photo_id') this.photoId, this.url});

  factory _$OrdersRoutePhotoTypeResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$OrdersRoutePhotoTypeResponseImplFromJson(json);

  @override
  @JsonKey(name: 'photo_id')
  final int? photoId;
  @override
  final String? url;

  @override
  String toString() {
    return 'OrdersRoutePhotoTypeResponse(photoId: $photoId, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersRoutePhotoTypeResponseImpl &&
            (identical(other.photoId, photoId) || other.photoId == photoId) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, photoId, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersRoutePhotoTypeResponseImplCopyWith<
          _$OrdersRoutePhotoTypeResponseImpl>
      get copyWith => __$$OrdersRoutePhotoTypeResponseImplCopyWithImpl<
          _$OrdersRoutePhotoTypeResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersRoutePhotoTypeResponseImplToJson(
      this,
    );
  }
}

abstract class _OrdersRoutePhotoTypeResponse
    implements OrdersRoutePhotoTypeResponse {
  const factory _OrdersRoutePhotoTypeResponse(
      {@JsonKey(name: 'photo_id') final int? photoId,
      final String? url}) = _$OrdersRoutePhotoTypeResponseImpl;

  factory _OrdersRoutePhotoTypeResponse.fromJson(Map<String, dynamic> json) =
      _$OrdersRoutePhotoTypeResponseImpl.fromJson;

  @override
  @JsonKey(name: 'photo_id')
  int? get photoId;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$OrdersRoutePhotoTypeResponseImplCopyWith<
          _$OrdersRoutePhotoTypeResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
