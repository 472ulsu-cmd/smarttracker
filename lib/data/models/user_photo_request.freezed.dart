// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_photo_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPhotoRequest {
  String? get avatar;

  /// Create a copy of UserPhotoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserPhotoRequestCopyWith<UserPhotoRequest> get copyWith =>
      _$UserPhotoRequestCopyWithImpl<UserPhotoRequest>(
          this as UserPhotoRequest, _$identity);

  /// Serializes this UserPhotoRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserPhotoRequest &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, avatar);

  @override
  String toString() {
    return 'UserPhotoRequest(avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class $UserPhotoRequestCopyWith<$Res> {
  factory $UserPhotoRequestCopyWith(
          UserPhotoRequest value, $Res Function(UserPhotoRequest) _then) =
      _$UserPhotoRequestCopyWithImpl;
  @useResult
  $Res call({String? avatar});
}

/// @nodoc
class _$UserPhotoRequestCopyWithImpl<$Res>
    implements $UserPhotoRequestCopyWith<$Res> {
  _$UserPhotoRequestCopyWithImpl(this._self, this._then);

  final UserPhotoRequest _self;
  final $Res Function(UserPhotoRequest) _then;

  /// Create a copy of UserPhotoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
  }) {
    return _then(_self.copyWith(
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserPhotoRequest implements UserPhotoRequest {
  const _UserPhotoRequest({this.avatar});
  factory _UserPhotoRequest.fromJson(Map<String, dynamic> json) =>
      _$UserPhotoRequestFromJson(json);

  @override
  final String? avatar;

  /// Create a copy of UserPhotoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserPhotoRequestCopyWith<_UserPhotoRequest> get copyWith =>
      __$UserPhotoRequestCopyWithImpl<_UserPhotoRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserPhotoRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserPhotoRequest &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, avatar);

  @override
  String toString() {
    return 'UserPhotoRequest(avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$UserPhotoRequestCopyWith<$Res>
    implements $UserPhotoRequestCopyWith<$Res> {
  factory _$UserPhotoRequestCopyWith(
          _UserPhotoRequest value, $Res Function(_UserPhotoRequest) _then) =
      __$UserPhotoRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String? avatar});
}

/// @nodoc
class __$UserPhotoRequestCopyWithImpl<$Res>
    implements _$UserPhotoRequestCopyWith<$Res> {
  __$UserPhotoRequestCopyWithImpl(this._self, this._then);

  final _UserPhotoRequest _self;
  final $Res Function(_UserPhotoRequest) _then;

  /// Create a copy of UserPhotoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? avatar = freezed,
  }) {
    return _then(_UserPhotoRequest(
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
