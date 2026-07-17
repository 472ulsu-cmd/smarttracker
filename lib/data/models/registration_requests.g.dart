// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) =>
    _RegistrationRequest(
      login: json['login'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
    );

Map<String, dynamic> _$RegistrationRequestToJson(
        _RegistrationRequest instance) =>
    <String, dynamic>{
      'login': instance.login,
      'password': instance.password,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
    };

_SendPhoneCodeRequest _$SendPhoneCodeRequestFromJson(
        Map<String, dynamic> json) =>
    _SendPhoneCodeRequest(
      login: json['login'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
    );

Map<String, dynamic> _$SendPhoneCodeRequestToJson(
        _SendPhoneCodeRequest instance) =>
    <String, dynamic>{
      'login': instance.login,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
    };

_VerifyPhoneCodeRequest _$VerifyPhoneCodeRequestFromJson(
        Map<String, dynamic> json) =>
    _VerifyPhoneCodeRequest(
      login: json['login'] as String,
      phone: json['phone'] as String,
      phoneCodeId: (json['phone_code_id'] as num).toInt(),
      code: json['code'] as String,
    );

Map<String, dynamic> _$VerifyPhoneCodeRequestToJson(
        _VerifyPhoneCodeRequest instance) =>
    <String, dynamic>{
      'login': instance.login,
      'phone': instance.phone,
      'phone_code_id': instance.phoneCodeId,
      'code': instance.code,
    };
