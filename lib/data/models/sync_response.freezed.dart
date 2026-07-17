// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncResponse {
  @JsonKey(name: 'coordinates_period')
  int? get coordinatesPeriod;
  @JsonKey(name: 'sync_period')
  int? get syncPeriod;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncResponseCopyWith<SyncResponse> get copyWith =>
      _$SyncResponseCopyWithImpl<SyncResponse>(
          this as SyncResponse, _$identity);

  /// Serializes this SyncResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncResponse &&
            (identical(other.coordinatesPeriod, coordinatesPeriod) ||
                other.coordinatesPeriod == coordinatesPeriod) &&
            (identical(other.syncPeriod, syncPeriod) ||
                other.syncPeriod == syncPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coordinatesPeriod, syncPeriod);

  @override
  String toString() {
    return 'SyncResponse(coordinatesPeriod: $coordinatesPeriod, syncPeriod: $syncPeriod)';
  }
}

/// @nodoc
abstract mixin class $SyncResponseCopyWith<$Res> {
  factory $SyncResponseCopyWith(
          SyncResponse value, $Res Function(SyncResponse) _then) =
      _$SyncResponseCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates_period') int? coordinatesPeriod,
      @JsonKey(name: 'sync_period') int? syncPeriod});
}

/// @nodoc
class _$SyncResponseCopyWithImpl<$Res> implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._self, this._then);

  final SyncResponse _self;
  final $Res Function(SyncResponse) _then;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coordinatesPeriod = freezed,
    Object? syncPeriod = freezed,
  }) {
    return _then(_self.copyWith(
      coordinatesPeriod: freezed == coordinatesPeriod
          ? _self.coordinatesPeriod
          : coordinatesPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      syncPeriod: freezed == syncPeriod
          ? _self.syncPeriod
          : syncPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SyncResponse implements SyncResponse {
  const _SyncResponse(
      {@JsonKey(name: 'coordinates_period') this.coordinatesPeriod,
      @JsonKey(name: 'sync_period') this.syncPeriod});
  factory _SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);

  @override
  @JsonKey(name: 'coordinates_period')
  final int? coordinatesPeriod;
  @override
  @JsonKey(name: 'sync_period')
  final int? syncPeriod;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SyncResponseCopyWith<_SyncResponse> get copyWith =>
      __$SyncResponseCopyWithImpl<_SyncResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SyncResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SyncResponse &&
            (identical(other.coordinatesPeriod, coordinatesPeriod) ||
                other.coordinatesPeriod == coordinatesPeriod) &&
            (identical(other.syncPeriod, syncPeriod) ||
                other.syncPeriod == syncPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, coordinatesPeriod, syncPeriod);

  @override
  String toString() {
    return 'SyncResponse(coordinatesPeriod: $coordinatesPeriod, syncPeriod: $syncPeriod)';
  }
}

/// @nodoc
abstract mixin class _$SyncResponseCopyWith<$Res>
    implements $SyncResponseCopyWith<$Res> {
  factory _$SyncResponseCopyWith(
          _SyncResponse value, $Res Function(_SyncResponse) _then) =
      __$SyncResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'coordinates_period') int? coordinatesPeriod,
      @JsonKey(name: 'sync_period') int? syncPeriod});
}

/// @nodoc
class __$SyncResponseCopyWithImpl<$Res>
    implements _$SyncResponseCopyWith<$Res> {
  __$SyncResponseCopyWithImpl(this._self, this._then);

  final _SyncResponse _self;
  final $Res Function(_SyncResponse) _then;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? coordinatesPeriod = freezed,
    Object? syncPeriod = freezed,
  }) {
    return _then(_SyncResponse(
      coordinatesPeriod: freezed == coordinatesPeriod
          ? _self.coordinatesPeriod
          : coordinatesPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      syncPeriod: freezed == syncPeriod
          ? _self.syncPeriod
          : syncPeriod // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
