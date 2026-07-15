// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestImpl _$$RegistrationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestImpl(
      login: json['login'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
    );

Map<String, dynamic> _$$RegistrationRequestImplToJson(
        _$RegistrationRequestImpl instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
    };

_$SendPhoneCodeRequestImpl _$$SendPhoneCodeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendPhoneCodeRequestImpl(
      login: json['login'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
    );

Map<String, dynamic> _$$SendPhoneCodeRequestImplToJson(
        _$SendPhoneCodeRequestImpl instance) =>
    <String, dynamic>{
      'login': instance.login,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
    };

_$VerifyPhoneCodeRequestImpl _$$VerifyPhoneCodeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyPhoneCodeRequestImpl(
      login: json['login'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
      code: json['code'] as String,
    );

Map<String, dynamic> _$$VerifyPhoneCodeRequestImplToJson(
        _$VerifyPhoneCodeRequestImpl instance) =>
    <String, dynamic>{
      'login': instance.login,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
      'code': instance.code,
    };
