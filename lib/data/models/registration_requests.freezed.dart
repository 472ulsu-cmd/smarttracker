// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) {
  return _RegistrationRequest.fromJson(json);
}

/// @nodoc
mixin _$RegistrationRequest {
  String get login => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationRequestCopyWith<RegistrationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationRequestCopyWith<$Res> {
  factory $RegistrationRequestCopyWith(
          RegistrationRequest value, $Res Function(RegistrationRequest) then) =
      _$RegistrationRequestCopyWithImpl<$Res, RegistrationRequest>;
  @useResult
  $Res call(
      {String login,
      String password,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class _$RegistrationRequestCopyWithImpl<$Res, $Val extends RegistrationRequest>
    implements $RegistrationRequestCopyWith<$Res> {
  _$RegistrationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_value.copyWith(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationRequestImplCopyWith<$Res>
    implements $RegistrationRequestCopyWith<$Res> {
  factory _$$RegistrationRequestImplCopyWith(_$RegistrationRequestImpl value,
          $Res Function(_$RegistrationRequestImpl) then) =
      __$$RegistrationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String login,
      String password,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class __$$RegistrationRequestImplCopyWithImpl<$Res>
    extends _$RegistrationRequestCopyWithImpl<$Res, _$RegistrationRequestImpl>
    implements _$$RegistrationRequestImplCopyWith<$Res> {
  __$$RegistrationRequestImplCopyWithImpl(_$RegistrationRequestImpl _value,
      $Res Function(_$RegistrationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_$RegistrationRequestImpl(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationRequestImpl implements _RegistrationRequest {
  const _$RegistrationRequestImpl(
      {required this.login,
      required this.password,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId});

  factory _$RegistrationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationRequestImplFromJson(json);

  @override
  final String login;
  @override
  final String password;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;

  @override
  String toString() {
    return 'RegistrationRequest(login: $login, password: $password, phone: $phone, phoneCodeId: $phoneCodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationRequestImpl &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, login, password, phone, phoneCodeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      __$$RegistrationRequestImplCopyWithImpl<_$RegistrationRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationRequestImplToJson(
      this,
    );
  }
}

abstract class _RegistrationRequest implements RegistrationRequest {
  const factory _RegistrationRequest(
          {required final String login,
          required final String password,
          required final String phone,
          @JsonKey(name: 'phone_code_id') required final int phoneCodeId}) =
      _$RegistrationRequestImpl;

  factory _RegistrationRequest.fromJson(Map<String, dynamic> json) =
      _$RegistrationRequestImpl.fromJson;

  @override
  String get login;
  @override
  String get password;
  @override
  String get phone;
  @override
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationRequestImplCopyWith<_$RegistrationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SendPhoneCodeRequest _$SendPhoneCodeRequestFromJson(Map<String, dynamic> json) {
  return _SendPhoneCodeRequest.fromJson(json);
}

/// @nodoc
mixin _$SendPhoneCodeRequest {
  String get login => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SendPhoneCodeRequestCopyWith<SendPhoneCodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendPhoneCodeRequestCopyWith<$Res> {
  factory $SendPhoneCodeRequestCopyWith(SendPhoneCodeRequest value,
          $Res Function(SendPhoneCodeRequest) then) =
      _$SendPhoneCodeRequestCopyWithImpl<$Res, SendPhoneCodeRequest>;
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class _$SendPhoneCodeRequestCopyWithImpl<$Res,
        $Val extends SendPhoneCodeRequest>
    implements $SendPhoneCodeRequestCopyWith<$Res> {
  _$SendPhoneCodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_value.copyWith(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SendPhoneCodeRequestImplCopyWith<$Res>
    implements $SendPhoneCodeRequestCopyWith<$Res> {
  factory _$$SendPhoneCodeRequestImplCopyWith(_$SendPhoneCodeRequestImpl value,
          $Res Function(_$SendPhoneCodeRequestImpl) then) =
      __$$SendPhoneCodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId});
}

/// @nodoc
class __$$SendPhoneCodeRequestImplCopyWithImpl<$Res>
    extends _$SendPhoneCodeRequestCopyWithImpl<$Res, _$SendPhoneCodeRequestImpl>
    implements _$$SendPhoneCodeRequestImplCopyWith<$Res> {
  __$$SendPhoneCodeRequestImplCopyWithImpl(_$SendPhoneCodeRequestImpl _value,
      $Res Function(_$SendPhoneCodeRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
  }) {
    return _then(_$SendPhoneCodeRequestImpl(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SendPhoneCodeRequestImpl implements _SendPhoneCodeRequest {
  const _$SendPhoneCodeRequestImpl(
      {required this.login,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId});

  factory _$SendPhoneCodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendPhoneCodeRequestImplFromJson(json);

  @override
  final String login;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;

  @override
  String toString() {
    return 'SendPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendPhoneCodeRequestImpl &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SendPhoneCodeRequestImplCopyWith<_$SendPhoneCodeRequestImpl>
      get copyWith =>
          __$$SendPhoneCodeRequestImplCopyWithImpl<_$SendPhoneCodeRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SendPhoneCodeRequestImplToJson(
      this,
    );
  }
}

abstract class _SendPhoneCodeRequest implements SendPhoneCodeRequest {
  const factory _SendPhoneCodeRequest(
          {required final String login,
          required final String phone,
          @JsonKey(name: 'phone_code_id') required final int phoneCodeId}) =
      _$SendPhoneCodeRequestImpl;

  factory _SendPhoneCodeRequest.fromJson(Map<String, dynamic> json) =
      _$SendPhoneCodeRequestImpl.fromJson;

  @override
  String get login;
  @override
  String get phone;
  @override
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;
  @override
  @JsonKey(ignore: true)
  _$$SendPhoneCodeRequestImplCopyWith<_$SendPhoneCodeRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerifyPhoneCodeRequest _$VerifyPhoneCodeRequestFromJson(
    Map<String, dynamic> json) {
  return _VerifyPhoneCodeRequest.fromJson(json);
}

/// @nodoc
mixin _$VerifyPhoneCodeRequest {
  String get login => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerifyPhoneCodeRequestCopyWith<VerifyPhoneCodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyPhoneCodeRequestCopyWith<$Res> {
  factory $VerifyPhoneCodeRequestCopyWith(VerifyPhoneCodeRequest value,
          $Res Function(VerifyPhoneCodeRequest) then) =
      _$VerifyPhoneCodeRequestCopyWithImpl<$Res, VerifyPhoneCodeRequest>;
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId,
      String code});
}

/// @nodoc
class _$VerifyPhoneCodeRequestCopyWithImpl<$Res,
        $Val extends VerifyPhoneCodeRequest>
    implements $VerifyPhoneCodeRequestCopyWith<$Res> {
  _$VerifyPhoneCodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
    Object? code = null,
  }) {
    return _then(_value.copyWith(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyPhoneCodeRequestImplCopyWith<$Res>
    implements $VerifyPhoneCodeRequestCopyWith<$Res> {
  factory _$$VerifyPhoneCodeRequestImplCopyWith(
          _$VerifyPhoneCodeRequestImpl value,
          $Res Function(_$VerifyPhoneCodeRequestImpl) then) =
      __$$VerifyPhoneCodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String login,
      String phone,
      @JsonKey(name: 'phone_code_id') int phoneCodeId,
      String code});
}

/// @nodoc
class __$$VerifyPhoneCodeRequestImplCopyWithImpl<$Res>
    extends _$VerifyPhoneCodeRequestCopyWithImpl<$Res,
        _$VerifyPhoneCodeRequestImpl>
    implements _$$VerifyPhoneCodeRequestImplCopyWith<$Res> {
  __$$VerifyPhoneCodeRequestImplCopyWithImpl(
      _$VerifyPhoneCodeRequestImpl _value,
      $Res Function(_$VerifyPhoneCodeRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? login = null,
    Object? phone = null,
    Object? phoneCodeId = null,
    Object? code = null,
  }) {
    return _then(_$VerifyPhoneCodeRequestImpl(
      login: null == login
          ? _value.login
          : login // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCodeId: null == phoneCodeId
          ? _value.phoneCodeId
          : phoneCodeId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyPhoneCodeRequestImpl implements _VerifyPhoneCodeRequest {
  const _$VerifyPhoneCodeRequestImpl(
      {required this.login,
      required this.phone,
      @JsonKey(name: 'phone_code_id') required this.phoneCodeId,
      required this.code});

  factory _$VerifyPhoneCodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyPhoneCodeRequestImplFromJson(json);

  @override
  final String login;
  @override
  final String phone;
  @override
  @JsonKey(name: 'phone_code_id')
  final int phoneCodeId;
  @override
  final String code;

  @override
  String toString() {
    return 'VerifyPhoneCodeRequest(login: $login, phone: $phone, phoneCodeId: $phoneCodeId, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyPhoneCodeRequestImpl &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCodeId, phoneCodeId) ||
                other.phoneCodeId == phoneCodeId) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, login, phone, phoneCodeId, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyPhoneCodeRequestImplCopyWith<_$VerifyPhoneCodeRequestImpl>
      get copyWith => __$$VerifyPhoneCodeRequestImplCopyWithImpl<
          _$VerifyPhoneCodeRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyPhoneCodeRequestImplToJson(
      this,
    );
  }
}

abstract class _VerifyPhoneCodeRequest implements VerifyPhoneCodeRequest {
  const factory _VerifyPhoneCodeRequest(
      {required final String login,
      required final String phone,
      @JsonKey(name: 'phone_code_id') required final int phoneCodeId,
      required final String code}) = _$VerifyPhoneCodeRequestImpl;

  factory _VerifyPhoneCodeRequest.fromJson(Map<String, dynamic> json) =
      _$VerifyPhoneCodeRequestImpl.fromJson;

  @override
  String get login;
  @override
  String get phone;
  @override
  @JsonKey(name: 'phone_code_id')
  int get phoneCodeId;
  @override
  String get code;
  @override
  @JsonKey(ignore: true)
  _$$VerifyPhoneCodeRequestImplCopyWith<_$VerifyPhoneCodeRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
