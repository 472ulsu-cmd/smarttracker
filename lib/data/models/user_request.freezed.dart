// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRequest _$UserRequestFromJson(Map<String, dynamic> json) {
  return _UserRequest.fromJson(json);
}

/// @nodoc
mixin _$UserRequest {
  int? get id => throw _privateConstructorUsedError;
  String? get login => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'second_name')
  String? get secondName => throw _privateConstructorUsedError;
  String? get surname => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_code')
  int? get phoneCode => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserRequestCopyWith<UserRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRequestCopyWith<$Res> {
  factory $UserRequestCopyWith(
          UserRequest value, $Res Function(UserRequest) then) =
      _$UserRequestCopyWithImpl<$Res, UserRequest>;
  @useResult
  $Res call(
      {int? id,
      String? login,
      String? name,
      @JsonKey(name: 'second_name') String? secondName,
      String? surname,
      String? phone,
      @JsonKey(name: 'phone_code') int? phoneCode,
      String? avatar});
}

/// @nodoc
class _$UserRequestCopyWithImpl<$Res, $Val extends UserRequest>
    implements $UserRequestCopyWith<$Res> {
  _$UserRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? login = freezed,
    Object? name = freezed,
    Object? secondName = freezed,
    Object? surname = freezed,
    Object? phone = freezed,
    Object? phoneCode = freezed,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      secondName: freezed == secondName
          ? _value.secondName
          : secondName // ignore: cast_nullable_to_non_nullable
              as String?,
      surname: freezed == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as int?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRequestImplCopyWith<$Res>
    implements $UserRequestCopyWith<$Res> {
  factory _$$UserRequestImplCopyWith(
          _$UserRequestImpl value, $Res Function(_$UserRequestImpl) then) =
      __$$UserRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? login,
      String? name,
      @JsonKey(name: 'second_name') String? secondName,
      String? surname,
      String? phone,
      @JsonKey(name: 'phone_code') int? phoneCode,
      String? avatar});
}

/// @nodoc
class __$$UserRequestImplCopyWithImpl<$Res>
    extends _$UserRequestCopyWithImpl<$Res, _$UserRequestImpl>
    implements _$$UserRequestImplCopyWith<$Res> {
  __$$UserRequestImplCopyWithImpl(
      _$UserRequestImpl _value, $Res Function(_$UserRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? login = freezed,
    Object? name = freezed,
    Object? secondName = freezed,
    Object? surname = freezed,
    Object? phone = freezed,
    Object? phoneCode = freezed,
    Object? avatar = freezed,
  }) {
    return _then(_$UserRequestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      secondName: freezed == secondName
          ? _value.secondName
          : secondName // ignore: cast_nullable_to_non_nullable
              as String?,
      surname: freezed == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as int?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRequestImpl implements _UserRequest {
  const _$UserRequestImpl(
      {this.id,
      this.login,
      this.name,
      @JsonKey(name: 'second_name') this.secondName,
      this.surname,
      this.phone,
      @JsonKey(name: 'phone_code') this.phoneCode,
      this.avatar});

  factory _$UserRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRequestImplFromJson(json);

  @override
  final int? id;
  @override
  final String? login;
  @override
  final String? name;
  @override
  @JsonKey(name: 'second_name')
  final String? secondName;
  @override
  final String? surname;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'phone_code')
  final int? phoneCode;
  @override
  final String? avatar;

  @override
  String toString() {
    return 'UserRequest(id: $id, login: $login, name: $name, secondName: $secondName, surname: $surname, phone: $phone, phoneCode: $phoneCode, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.secondName, secondName) ||
                other.secondName == secondName) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, login, name, secondName,
      surname, phone, phoneCode, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRequestImplCopyWith<_$UserRequestImpl> get copyWith =>
      __$$UserRequestImplCopyWithImpl<_$UserRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRequestImplToJson(
      this,
    );
  }
}

abstract class _UserRequest implements UserRequest {
  const factory _UserRequest(
      {final int? id,
      final String? login,
      final String? name,
      @JsonKey(name: 'second_name') final String? secondName,
      final String? surname,
      final String? phone,
      @JsonKey(name: 'phone_code') final int? phoneCode,
      final String? avatar}) = _$UserRequestImpl;

  factory _UserRequest.fromJson(Map<String, dynamic> json) =
      _$UserRequestImpl.fromJson;

  @override
  int? get id;
  @override
  String? get login;
  @override
  String? get name;
  @override
  @JsonKey(name: 'second_name')
  String? get secondName;
  @override
  String? get surname;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'phone_code')
  int? get phoneCode;
  @override
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$UserRequestImplCopyWith<_$UserRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPasswordRequest _$UserPasswordRequestFromJson(Map<String, dynamic> json) {
  return _UserPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$UserPasswordRequest {
  @JsonKey(name: 'old_password')
  String get oldPassword => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPasswordRequestCopyWith<UserPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPasswordRequestCopyWith<$Res> {
  factory $UserPasswordRequestCopyWith(
          UserPasswordRequest value, $Res Function(UserPasswordRequest) then) =
      _$UserPasswordRequestCopyWithImpl<$Res, UserPasswordRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword, String password});
}

/// @nodoc
class _$UserPasswordRequestCopyWithImpl<$Res, $Val extends UserPasswordRequest>
    implements $UserPasswordRequestCopyWith<$Res> {
  _$UserPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPasswordRequestImplCopyWith<$Res>
    implements $UserPasswordRequestCopyWith<$Res> {
  factory _$$UserPasswordRequestImplCopyWith(_$UserPasswordRequestImpl value,
          $Res Function(_$UserPasswordRequestImpl) then) =
      __$$UserPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword, String password});
}

/// @nodoc
class __$$UserPasswordRequestImplCopyWithImpl<$Res>
    extends _$UserPasswordRequestCopyWithImpl<$Res, _$UserPasswordRequestImpl>
    implements _$$UserPasswordRequestImplCopyWith<$Res> {
  __$$UserPasswordRequestImplCopyWithImpl(_$UserPasswordRequestImpl _value,
      $Res Function(_$UserPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? password = null,
  }) {
    return _then(_$UserPasswordRequestImpl(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPasswordRequestImpl implements _UserPasswordRequest {
  const _$UserPasswordRequestImpl(
      {@JsonKey(name: 'old_password') required this.oldPassword,
      required this.password});

  factory _$UserPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPasswordRequestImplFromJson(json);

  @override
  @JsonKey(name: 'old_password')
  final String oldPassword;
  @override
  final String password;

  @override
  String toString() {
    return 'UserPasswordRequest(oldPassword: $oldPassword, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPasswordRequestImpl &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, oldPassword, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPasswordRequestImplCopyWith<_$UserPasswordRequestImpl> get copyWith =>
      __$$UserPasswordRequestImplCopyWithImpl<_$UserPasswordRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _UserPasswordRequest implements UserPasswordRequest {
  const factory _UserPasswordRequest(
      {@JsonKey(name: 'old_password') required final String oldPassword,
      required final String password}) = _$UserPasswordRequestImpl;

  factory _UserPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$UserPasswordRequestImpl.fromJson;

  @override
  @JsonKey(name: 'old_password')
  String get oldPassword;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$UserPasswordRequestImplCopyWith<_$UserPasswordRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserNotificationRequest _$UserNotificationRequestFromJson(
    Map<String, dynamic> json) {
  return _UserNotificationRequest.fromJson(json);
}

/// @nodoc
mixin _$UserNotificationRequest {
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserNotificationRequestCopyWith<UserNotificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNotificationRequestCopyWith<$Res> {
  factory $UserNotificationRequestCopyWith(UserNotificationRequest value,
          $Res Function(UserNotificationRequest) then) =
      _$UserNotificationRequestCopyWithImpl<$Res, UserNotificationRequest>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$UserNotificationRequestCopyWithImpl<$Res,
        $Val extends UserNotificationRequest>
    implements $UserNotificationRequestCopyWith<$Res> {
  _$UserNotificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNotificationRequestImplCopyWith<$Res>
    implements $UserNotificationRequestCopyWith<$Res> {
  factory _$$UserNotificationRequestImplCopyWith(
          _$UserNotificationRequestImpl value,
          $Res Function(_$UserNotificationRequestImpl) then) =
      __$$UserNotificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$UserNotificationRequestImplCopyWithImpl<$Res>
    extends _$UserNotificationRequestCopyWithImpl<$Res,
        _$UserNotificationRequestImpl>
    implements _$$UserNotificationRequestImplCopyWith<$Res> {
  __$$UserNotificationRequestImplCopyWithImpl(
      _$UserNotificationRequestImpl _value,
      $Res Function(_$UserNotificationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$UserNotificationRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNotificationRequestImpl implements _UserNotificationRequest {
  const _$UserNotificationRequestImpl({required this.token});

  factory _$UserNotificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNotificationRequestImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'UserNotificationRequest(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNotificationRequestImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNotificationRequestImplCopyWith<_$UserNotificationRequestImpl>
      get copyWith => __$$UserNotificationRequestImplCopyWithImpl<
          _$UserNotificationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNotificationRequestImplToJson(
      this,
    );
  }
}

abstract class _UserNotificationRequest implements UserNotificationRequest {
  const factory _UserNotificationRequest({required final String token}) =
      _$UserNotificationRequestImpl;

  factory _UserNotificationRequest.fromJson(Map<String, dynamic> json) =
      _$UserNotificationRequestImpl.fromJson;

  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$UserNotificationRequestImplCopyWith<_$UserNotificationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
