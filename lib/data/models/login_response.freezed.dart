// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  @JsonKey(name: 'code')
  int? get code => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  AccountApiModel? get account => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      String? token,
      AccountApiModel? account});

  $AccountApiModelCopyWith<$Res>? get account;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? token = freezed,
    Object? account = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as AccountApiModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AccountApiModelCopyWith<$Res>? get account {
    if (_value.account == null) {
      return null;
    }

    return $AccountApiModelCopyWith<$Res>(_value.account!, (value) {
      return _then(_value.copyWith(account: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      String? token,
      AccountApiModel? account});

  @override
  $AccountApiModelCopyWith<$Res>? get account;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? token = freezed,
    Object? account = freezed,
  }) {
    return _then(_$LoginResponseImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as AccountApiModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl(
      {@JsonKey(name: 'code') this.code, this.token, this.account});

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  @JsonKey(name: 'code')
  final int? code;
  @override
  final String? token;
  @override
  final AccountApiModel? account;

  @override
  String toString() {
    return 'LoginResponse(code: $code, token: $token, account: $account)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.account, account) || other.account == account));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, token, account);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
      {@JsonKey(name: 'code') final int? code,
      final String? token,
      final AccountApiModel? account}) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  @JsonKey(name: 'code')
  int? get code;
  @override
  String? get token;
  @override
  AccountApiModel? get account;
  @override
  @JsonKey(ignore: true)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountApiModel _$AccountApiModelFromJson(Map<String, dynamic> json) {
  return _AccountApiModel.fromJson(json);
}

/// @nodoc
mixin _$AccountApiModel {
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
  $AccountApiModelCopyWith<AccountApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountApiModelCopyWith<$Res> {
  factory $AccountApiModelCopyWith(
          AccountApiModel value, $Res Function(AccountApiModel) then) =
      _$AccountApiModelCopyWithImpl<$Res, AccountApiModel>;
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
class _$AccountApiModelCopyWithImpl<$Res, $Val extends AccountApiModel>
    implements $AccountApiModelCopyWith<$Res> {
  _$AccountApiModelCopyWithImpl(this._value, this._then);

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
abstract class _$$AccountApiModelImplCopyWith<$Res>
    implements $AccountApiModelCopyWith<$Res> {
  factory _$$AccountApiModelImplCopyWith(_$AccountApiModelImpl value,
          $Res Function(_$AccountApiModelImpl) then) =
      __$$AccountApiModelImplCopyWithImpl<$Res>;
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
class __$$AccountApiModelImplCopyWithImpl<$Res>
    extends _$AccountApiModelCopyWithImpl<$Res, _$AccountApiModelImpl>
    implements _$$AccountApiModelImplCopyWith<$Res> {
  __$$AccountApiModelImplCopyWithImpl(
      _$AccountApiModelImpl _value, $Res Function(_$AccountApiModelImpl) _then)
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
    return _then(_$AccountApiModelImpl(
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
class _$AccountApiModelImpl implements _AccountApiModel {
  const _$AccountApiModelImpl(
      {this.id,
      this.login,
      this.name,
      @JsonKey(name: 'second_name') this.secondName,
      this.surname,
      this.phone,
      @JsonKey(name: 'phone_code') this.phoneCode,
      this.avatar});

  factory _$AccountApiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountApiModelImplFromJson(json);

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
    return 'AccountApiModel(id: $id, login: $login, name: $name, secondName: $secondName, surname: $surname, phone: $phone, phoneCode: $phoneCode, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountApiModelImpl &&
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
  _$$AccountApiModelImplCopyWith<_$AccountApiModelImpl> get copyWith =>
      __$$AccountApiModelImplCopyWithImpl<_$AccountApiModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountApiModelImplToJson(
      this,
    );
  }
}

abstract class _AccountApiModel implements AccountApiModel {
  const factory _AccountApiModel(
      {final int? id,
      final String? login,
      final String? name,
      @JsonKey(name: 'second_name') final String? secondName,
      final String? surname,
      final String? phone,
      @JsonKey(name: 'phone_code') final int? phoneCode,
      final String? avatar}) = _$AccountApiModelImpl;

  factory _AccountApiModel.fromJson(Map<String, dynamic> json) =
      _$AccountApiModelImpl.fromJson;

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
  _$$AccountApiModelImplCopyWith<_$AccountApiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
