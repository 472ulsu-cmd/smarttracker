// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      code: (json['code'] as num?)?.toInt(),
      token: json['token'] as String?,
      account: json['account'] == null
          ? null
          : AccountApiModel.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'token': instance.token,
      'account': instance.account,
    };

_$AccountApiModelImpl _$$AccountApiModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountApiModelImpl(
      id: (json['id'] as num?)?.toInt(),
      login: json['login'] as String?,
      name: json['name'] as String?,
      secondName: json['second_name'] as String?,
      surname: json['surname'] as String?,
      phone: json['phone'] as String?,
      phoneCode: (json['phone_code'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$AccountApiModelImplToJson(
        _$AccountApiModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'name': instance.name,
      'second_name': instance.secondName,
      'surname': instance.surname,
      'phone': instance.phone,
      'phone_code': instance.phoneCode,
      'avatar': instance.avatar,
    };
