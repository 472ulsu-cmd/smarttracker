// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_photo_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPhotoRequest _$UserPhotoRequestFromJson(Map<String, dynamic> json) {
  return _UserPhotoRequest.fromJson(json);
}

/// @nodoc
mixin _$UserPhotoRequest {
  String? get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPhotoRequestCopyWith<UserPhotoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPhotoRequestCopyWith<$Res> {
  factory $UserPhotoRequestCopyWith(
          UserPhotoRequest value, $Res Function(UserPhotoRequest) then) =
      _$UserPhotoRequestCopyWithImpl<$Res, UserPhotoRequest>;
  @useResult
  $Res call({String? avatar});
}

/// @nodoc
class _$UserPhotoRequestCopyWithImpl<$Res, $Val extends UserPhotoRequest>
    implements $UserPhotoRequestCopyWith<$Res> {
  _$UserPhotoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPhotoRequestImplCopyWith<$Res>
    implements $UserPhotoRequestCopyWith<$Res> {
  factory _$$UserPhotoRequestImplCopyWith(_$UserPhotoRequestImpl value,
          $Res Function(_$UserPhotoRequestImpl) then) =
      __$$UserPhotoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? avatar});
}

/// @nodoc
class __$$UserPhotoRequestImplCopyWithImpl<$Res>
    extends _$UserPhotoRequestCopyWithImpl<$Res, _$UserPhotoRequestImpl>
    implements _$$UserPhotoRequestImplCopyWith<$Res> {
  __$$UserPhotoRequestImplCopyWithImpl(_$UserPhotoRequestImpl _value,
      $Res Function(_$UserPhotoRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = freezed,
  }) {
    return _then(_$UserPhotoRequestImpl(
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPhotoRequestImpl implements _UserPhotoRequest {
  const _$UserPhotoRequestImpl({this.avatar});

  factory _$UserPhotoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPhotoRequestImplFromJson(json);

  @override
  final String? avatar;

  @override
  String toString() {
    return 'UserPhotoRequest(avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPhotoRequestImpl &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPhotoRequestImplCopyWith<_$UserPhotoRequestImpl> get copyWith =>
      __$$UserPhotoRequestImplCopyWithImpl<_$UserPhotoRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPhotoRequestImplToJson(
      this,
    );
  }
}

abstract class _UserPhotoRequest implements UserPhotoRequest {
  const factory _UserPhotoRequest({final String? avatar}) =
      _$UserPhotoRequestImpl;

  factory _UserPhotoRequest.fromJson(Map<String, dynamic> json) =
      _$UserPhotoRequestImpl.fromJson;

  @override
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$UserPhotoRequestImplCopyWith<_$UserPhotoRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
