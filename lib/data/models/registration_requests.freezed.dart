// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegistrationRequest {
  String get login;
  String get password;
  String get phone;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegistrationRequestCopyWith<RegistrationRequest> get copyWith =>
      _$RegistrationRequestCopyWithImpl<RegistrationRequest>(
          this as RegistrationRequest, _$identity);

  /// Serializes this RegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegistrationRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, login, password, phone, phoneCodeId);

  @override
  String toString() {
    return 'RegistrationRequest(login: $login, password: $password, phone: $phone, phoneCodeId: $phoneCodeId)';
  }
}

/// @nodoc
abstract mixin class $RegistrationRequestCopyWith<$Res> {
  factory $RegistrationRequestCopyWith(
          RegistrationRequest value, $Res Function(RegistrationRequest) _then) =
      _$RegistrationRequestCopyWithImpl;
  @useResult
  $Res call(
      {String login,
      String password,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class _$RegistrationRequestCopyWithImpl<$Res>
    implements $RegistrationRequestCopyWith<$Res> {
  _$RegistrationRequestCopyWithImpl(this._self, this._then);

  final RegistrationRequest _self;
  final $Res Function(RegistrationRequest) _then;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_self.copyWith(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _RegistrationRequest implements RegistrationRequest {
  const _RegistrationRequest(
      {required this.login,
      required this.password,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId});
  factory _RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  @override
  final String login;
  @override
  final String password;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RegistrationRequestCopyWith<_RegistrationRequest> get copyWith =>
      __$RegistrationRequestCopyWithImpl<_RegistrationRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RegistrationRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RegistrationRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, login, password, phone, phoneCodeId);

  @override
  String toString() {
    return 'RegistrationRequest(login: $login, password: $password, phone: $phone, phoneCodeId: $phoneCodeId)';
  }
}

/// @nodoc
abstract mixin class _$RegistrationRequestCopyWith<$Res>
    implements $RegistrationRequestCopyWith<$Res> {
  factory _$RegistrationRequestCopyWith(_RegistrationRequest value,
          $Res Function(_RegistrationRequest) _then) =
      __$RegistrationRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String login,
      String password,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class __$RegistrationRequestCopyWithImpl<$Res>
    implements _$RegistrationRequestCopyWith<$Res> {
  __$RegistrationRequestCopyWithImpl(this._self, this._then);

  final _RegistrationRequest _self;
  final $Res Function(_RegistrationRequest) _then;

  /// Create a copy of RegistrationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? login = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_RegistrationRequest(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$SendPhoneCodeRequest {
  String get login;
  String get phone;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;

  /// Create a copy of SendPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendPhoneCodeRequestCopyWith<SendPhoneCodeRequest> get copyWith =>
      _$SendPhoneCodeRequestCopyWithImpl<SendPhoneCodeRequest>(
          this as SendPhoneCodeRequest, _$identity);

  /// Serializes this SendPhoneCodeRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendPhoneCodeRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId);

  @override
  String toString() {
    return 'SendPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId)';
  }
}

/// @nodoc
abstract mixin class $SendPhoneCodeRequestCopyWith<$Res> {
  factory $SendPhoneCodeRequestCopyWith(SendPhoneCodeRequest value,
          $Res Function(SendPhoneCodeRequest) _then) =
      _$SendPhoneCodeRequestCopyWithImpl;
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class _$SendPhoneCodeRequestCopyWithImpl<$Res>
    implements $SendPhoneCodeRequestCopyWith<$Res> {
  _$SendPhoneCodeRequestCopyWithImpl(this._self, this._then);

  final SendPhoneCodeRequest _self;
  final $Res Function(SendPhoneCodeRequest) _then;

  /// Create a copy of SendPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_self.copyWith(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SendPhoneCodeRequest implements SendPhoneCodeRequest {
  const _SendPhoneCodeRequest(
      {required this.login,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId});
  factory _SendPhoneCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendPhoneCodeRequestFromJson(json);

  @override
  final String login;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;

  /// Create a copy of SendPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SendPhoneCodeRequestCopyWith<_SendPhoneCodeRequest> get copyWith =>
      __$SendPhoneCodeRequestCopyWithImpl<_SendPhoneCodeRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SendPhoneCodeRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendPhoneCodeRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId);

  @override
  String toString() {
    return 'SendPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId)';
  }
}

/// @nodoc
abstract mixin class _$SendPhoneCodeRequestCopyWith<$Res>
    implements $SendPhoneCodeRequestCopyWith<$Res> {
  factory _$SendPhoneCodeRequestCopyWith(_SendPhoneCodeRequest value,
          $Res Function(_SendPhoneCodeRequest) _then) =
      __$SendPhoneCodeRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class __$SendPhoneCodeRequestCopyWithImpl<$Res>
    implements _$SendPhoneCodeRequestCopyWith<$Res> {
  __$SendPhoneCodeRequestCopyWithImpl(this._self, this._then);

  final _SendPhoneCodeRequest _self;
  final $Res Function(_SendPhoneCodeRequest) _then;

  /// Create a copy of SendPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_SendPhoneCodeRequest(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$VerifyPhoneCodeRequest {
  String get login;
  String get phone;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;
  String get code;

  /// Create a copy of VerifyPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerifyPhoneCodeRequestCopyWith<VerifyPhoneCodeRequest> get copyWith =>
      _$VerifyPhoneCodeRequestCopyWithImpl<VerifyPhoneCodeRequest>(
          this as VerifyPhoneCodeRequest, _$identity);

  /// Serializes this VerifyPhoneCodeRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerifyPhoneCodeRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId, code);

  @override
  String toString() {
    return 'VerifyPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId, code: $code)';
  }
}

/// @nodoc
abstract mixin class $VerifyPhoneCodeRequestCopyWith<$Res> {
  factory $VerifyPhoneCodeRequestCopyWith(VerifyPhoneCodeRequest value,
          $Res Function(VerifyPhoneCodeRequest) _then) =
      _$VerifyPhoneCodeRequestCopyWithImpl;
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId,
      String code});
}

/// @nodoc
class _$VerifyPhoneCodeRequestCopyWithImpl<$Res>
    implements $VerifyPhoneCodeRequestCopyWith<$Res> {
  _$VerifyPhoneCodeRequestCopyWithImpl(this._self, this._then);

  final VerifyPhoneCodeRequest _self;
  final $Res Function(VerifyPhoneCodeRequest) _then;

  /// Create a copy of VerifyPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
    Object? code = null,
  }) {
    return _then(_self.copyWith(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VerifyPhoneCodeRequest implements VerifyPhoneCodeRequest {
  const _VerifyPhoneCodeRequest(
      {required this.login,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId,
      required this.code});
  factory _VerifyPhoneCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyPhoneCodeRequestFromJson(json);

  @override
  final String login;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;
  @override
  final String code;

  /// Create a copy of VerifyPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VerifyPhoneCodeRequestCopyWith<_VerifyPhoneCodeRequest> get copyWith =>
      __$VerifyPhoneCodeRequestCopyWithImpl<_VerifyPhoneCodeRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VerifyPhoneCodeRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VerifyPhoneCodeRequest &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId, code);

  @override
  String toString() {
    return 'VerifyPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId, code: $code)';
  }
}

/// @nodoc
abstract mixin class _$VerifyPhoneCodeRequestCopyWith<$Res>
    implements $VerifyPhoneCodeRequestCopyWith<$Res> {
  factory _$VerifyPhoneCodeRequestCopyWith(_VerifyPhoneCodeRequest value,
          $Res Function(_VerifyPhoneCodeRequest) _then) =
      __$VerifyPhoneCodeRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId,
      String code});
}

/// @nodoc
class __$VerifyPhoneCodeRequestCopyWithImpl<$Res>
    implements _$VerifyPhoneCodeRequestCopyWith<$Res> {
  __$VerifyPhoneCodeRequestCopyWithImpl(this._self, this._then);

  final _VerifyPhoneCodeRequest _self;
  final $Res Function(_VerifyPhoneCodeRequest) _then;

  /// Create a copy of VerifyPhoneCodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
    Object? code = null,
  }) {
    return _then(_VerifyPhoneCodeRequest(
      login: null == login
          ? _self.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _self.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
