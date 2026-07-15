// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) {
  return _SyncResponse.fromJson(json);
}

/// @nodoc
mixin _$SyncResponse {
  @JsonKey(name: 'coordinates_period')
  int? get coordinatesPeriod => throw _privateConstructorUsedError;
  @JsonKey(name: 'sync_period')
  int? get syncPeriod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SyncResponseCopyWith<SyncResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncResponseCopyWith<$Res> {
  factory $SyncResponseCopyWith(
          SyncResponse value, $Res Function(SyncResponse) then) =
      _$SyncResponseCopyWithImpl<$Res, SyncResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates_period') int? coordinatesPeriod,
      @JsonKey(name: 'sync_period') int? syncPeriod});
}

/// @nodoc
class _$SyncResponseCopyWithImpl<$Res, $Val extends SyncResponse>
    implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinatesPeriod = freezed,
    Object? syncPeriod = freezed,
  }) {
    return _then(_value.copyWith(
      coordinatesPeriod: freezed == coordinatesPeriod
          ? _value.coordinatesPeriod
          : coordinatesPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      syncPeriod: freezed == syncPeriod
          ? _value.syncPeriod
          : syncPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncResponseImplCopyWith<$Res>
    implements $SyncResponseCopyWith<$Res> {
  factory _$$SyncResponseImplCopyWith(
          _$SyncResponseImpl value, $Res Function(_$SyncResponseImpl) then) =
      __$$SyncResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates_period') int? coordinatesPeriod,
      @JsonKey(name: 'sync_period') int? syncPeriod});
}

/// @nodoc
class __$$SyncResponseImplCopyWithImpl<$Res>
    extends _$SyncResponseCopyWithImpl<$Res, _$SyncResponseImpl>
    implements _$$SyncResponseImplCopyWith<$Res> {
  __$$SyncResponseImplCopyWithImpl(
      _$SyncResponseImpl _value, $Res Function(_$SyncResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinatesPeriod = freezed,
    Object? syncPeriod = freezed,
  }) {
    return _then(_$SyncResponseImpl(
      coordinatesPeriod: freezed == coordinatesPeriod
          ? _value.coordinatesPeriod
          : coordinatesPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      syncPeriod: freezed == syncPeriod
          ? _value.syncPeriod
          : syncPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncResponseImpl implements _SyncResponse {
  const _$SyncResponseImpl(
      {@JsonKey(name: 'coordinates_period') this.coordinatesPeriod,
      @JsonKey(name: 'sync_period') this.syncPeriod});

  factory _$SyncResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncResponseImplFromJson(json);

  @override
  @JsonKey(name: 'coordinates_period')
  final int? coordinatesPeriod;
  @override
  @JsonKey(name: 'sync_period')
  final int? syncPeriod;

  @override
  String toString() {
    return 'SyncResponse(coordinatesPeriod: $coordinatesPeriod, syncPeriod: $syncPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncResponseImpl &&
            (identical(other.coordinatesPeriod, coordinatesPeriod) ||
                other.coordinatesPeriod == coordinatesPeriod) &&
            (identical(other.syncPeriod, syncPeriod) ||
                other.syncPeriod == syncPeriod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coordinatesPeriod, syncPeriod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncResponseImplCopyWith<_$SyncResponseImpl> get copyWith =>
      __$$SyncResponseImplCopyWithImpl<_$SyncResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncResponseImplToJson(
      this,
    );
  }
}

abstract class _SyncResponse implements SyncResponse {
  const factory _SyncResponse(
          {@JsonKey(name: 'coordinates_period') final int? coordinatesPeriod,
          @JsonKey(name: 'sync_period') final int? syncPeriod}) =
      _$SyncResponseImpl;

  factory _SyncResponse.fromJson(Map<String, dynamic> json) =
      _$SyncResponseImpl.fromJson;

  @override
  @JsonKey(name: 'coordinates_period')
  int? get coordinatesPeriod;
  @override
  @JsonKey(name: 'sync_period')
  int? get syncPeriod;
  @override
  @JsonKey(ignore: true)
  _$$SyncResponseImplCopyWith<_$SyncResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
