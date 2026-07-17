// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRequest {
  int? get id;
  String? get login;
  String? get name;
  @JsonKey(name: 'second_name')
  String? get secondName;
  String? get surname;
  String? get phone;
  @JsonKey(name: 'phone_code')
  int? get phoneCode;
  String? get avatar;

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserRequestCopyWith<UserRequest> get copyWith =>
      _$UserRequestCopyWithImpl<UserRequest>(this as UserRequest, _$identity);

  /// Serializes this UserRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserRequest &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, login, name, secondName,
      surname, phone, phoneCode, avatar);

  @override
  String toString() {
    return 'UserRequest(id: $id, login: $login, name: $name, secondName: $secondName, surname: $surname, phone: $phone, phoneCode: $phoneCode, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class $UserRequestCopyWith<$Res> {
  factory $UserRequestCopyWith(
          UserRequest value, $Res Function(UserRequest) _then) =
      _$UserRequestCopyWithImpl;
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
class _$UserRequestCopyWithImpl<$Res> implements $UserRequestCopyWith<$Res> {
  _$UserRequestCopyWithImpl(this._self, this._then);

  final UserRequest _self;
  final $Res Function(UserRequest) _then;

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
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
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      secondName: freezed == secondName
          ? _self.secondName
          : secondName // ignore: cast_nullable_to_non_nullable
              as String?,
      surname: freezed == surname
          ? _self.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _self.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as int?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserRequest implements UserRequest {
  const _UserRequest(
      {this.id,
      this.login,
      this.name,
      @JsonKey(name: 'second_name') this.secondName,
      this.surname,
      this.phone,
      @JsonKey(name: 'phone_code') this.phoneCode,
      this.avatar});
  factory _UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);

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

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserRequestCopyWith<_UserRequest> get copyWith =>
      __$UserRequestCopyWithImpl<_UserRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserRequest &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, login, name, secondName,
      surname, phone, phoneCode, avatar);

  @override
  String toString() {
    return 'UserRequest(id: $id, login: $login, name: $name, secondName: $secondName, surname: $surname, phone: $phone, phoneCode: $phoneCode, avatar: $avatar)';
  }
}

/// @nodoc
abstract mixin class _$UserRequestCopyWith<$Res>
    implements $UserRequestCopyWith<$Res> {
  factory _$UserRequestCopyWith(
          _UserRequest value, $Res Function(_UserRequest) _then) =
      __$UserRequestCopyWithImpl;
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
class __$UserRequestCopyWithImpl<$Res> implements _$UserRequestCopyWith<$Res> {
  __$UserRequestCopyWithImpl(this._self, this._then);

  final _UserRequest _self;
  final $Res Function(_UserRequest) _then;

  /// Create a copy of UserRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_UserRequest(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      login: freezed == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      secondName: freezed == secondName
          ? _self.secondName
          : secondName // ignore: cast_nullable_to_non_nullable
              as String?,
      surname: freezed == surname
          ? _self.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneCode: freezed == phoneCode
          ? _self.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as int?,
      avatar: freezed == avatar
          ? _self.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UserPasswordRequest {
  @JsonKey(name: 'old_password')
  String get oldPassword;
  String get password;

  /// Create a copy of UserPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserPasswordRequestCopyWith<UserPasswordRequest> get copyWith =>
      _$UserPasswordRequestCopyWithImpl<UserPasswordRequest>(
          this as UserPasswordRequest, _$identity);

  /// Serializes this UserPasswordRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserPasswordRequest &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, oldPassword, password);

  @override
  String toString() {
    return 'UserPasswordRequest(oldPassword: $oldPassword, password: $password)';
  }
}

/// @nodoc
abstract mixin class $UserPasswordRequestCopyWith<$Res> {
  factory $UserPasswordRequestCopyWith(
          UserPasswordRequest value, $Res Function(UserPasswordRequest) _then) =
      _$UserPasswordRequestCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword, String password});
}

/// @nodoc
class _$UserPasswordRequestCopyWithImpl<$Res>
    implements $UserPasswordRequestCopyWith<$Res> {
  _$UserPasswordRequestCopyWithImpl(this._self, this._then);

  final UserPasswordRequest _self;
  final $Res Function(UserPasswordRequest) _then;

  /// Create a copy of UserPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? password = null,
  }) {
    return _then(_self.copyWith(
      oldPassword: null == oldPassword
          ? _self.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserPasswordRequest implements UserPasswordRequest {
  const _UserPasswordRequest(
      {@JsonKey(name: 'old_password') required this.oldPassword,
      required this.password});
  factory _UserPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UserPasswordRequestFromJson(json);

  @override
  @JsonKey(name: 'old_password')
  final String oldPassword;
  @override
  final String password;

  /// Create a copy of UserPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserPasswordRequestCopyWith<_UserPasswordRequest> get copyWith =>
      __$UserPasswordRequestCopyWithImpl<_UserPasswordRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserPasswordRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserPasswordRequest &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, oldPassword, password);

  @override
  String toString() {
    return 'UserPasswordRequest(oldPassword: $oldPassword, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$UserPasswordRequestCopyWith<$Res>
    implements $UserPasswordRequestCopyWith<$Res> {
  factory _$UserPasswordRequestCopyWith(_UserPasswordRequest value,
          $Res Function(_UserPasswordRequest) _then) =
      __$UserPasswordRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword, String password});
}

/// @nodoc
class __$UserPasswordRequestCopyWithImpl<$Res>
    implements _$UserPasswordRequestCopyWith<$Res> {
  __$UserPasswordRequestCopyWithImpl(this._self, this._then);

  final _UserPasswordRequest _self;
  final $Res Function(_UserPasswordRequest) _then;

  /// Create a copy of UserPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? oldPassword = null,
    Object? password = null,
  }) {
    return _then(_UserPasswordRequest(
      oldPassword: null == oldPassword
          ? _self.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UserNotificationRequest {
  String get token;

  /// Create a copy of UserNotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserNotificationRequestCopyWith<UserNotificationRequest> get copyWith =>
      _$UserNotificationRequestCopyWithImpl<UserNotificationRequest>(
          this as UserNotificationRequest, _$identity);

  /// Serializes this UserNotificationRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserNotificationRequest &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString() {
    return 'UserNotificationRequest(token: $token)';
  }
}

/// @nodoc
abstract mixin class $UserNotificationRequestCopyWith<$Res> {
  factory $UserNotificationRequestCopyWith(UserNotificationRequest value,
          $Res Function(UserNotificationRequest) _then) =
      _$UserNotificationRequestCopyWithImpl;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$UserNotificationRequestCopyWithImpl<$Res>
    implements $UserNotificationRequestCopyWith<$Res> {
  _$UserNotificationRequestCopyWithImpl(this._self, this._then);

  final UserNotificationRequest _self;
  final $Res Function(UserNotificationRequest) _then;

  /// Create a copy of UserNotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserNotificationRequest implements UserNotificationRequest {
  const _UserNotificationRequest({required this.token});
  factory _UserNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationRequestFromJson(json);

  @override
  final String token;

  /// Create a copy of UserNotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserNotificationRequestCopyWith<_UserNotificationRequest> get copyWith =>
      __$UserNotificationRequestCopyWithImpl<_UserNotificationRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserNotificationRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserNotificationRequest &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  @override
  String toString() {
    return 'UserNotificationRequest(token: $token)';
  }
}

/// @nodoc
abstract mixin class _$UserNotificationRequestCopyWith<$Res>
    implements $UserNotificationRequestCopyWith<$Res> {
  factory _$UserNotificationRequestCopyWith(_UserNotificationRequest value,
          $Res Function(_UserNotificationRequest) _then) =
      __$UserNotificationRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$UserNotificationRequestCopyWithImpl<$Res>
    implements _$UserNotificationRequestCopyWith<$Res> {
  __$UserNotificationRequestCopyWithImpl(this._self, this._then);

  final _UserNotificationRequest _self;
  final $Res Function(_UserNotificationRequest) _then;

  /// Create a copy of UserNotificationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
  }) {
    return _then(_UserNotificationRequest(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
