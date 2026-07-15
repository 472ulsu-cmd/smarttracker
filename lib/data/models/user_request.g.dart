// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRequestImpl _$$UserRequestImplFromJson(Map<String, dynamic> json) =>
    _$UserRequestImpl(
      id: (json['id'] as num?)?.toInt(),
      login: json['login'] as String?,
      name: json['name'] as String?,
      secondName: json['second_name'] as String?,
      surname: json['surname'] as String?,
      phone: json['phone'] as String?,
      phoneCode: (json['phone_code'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$UserRequestImplToJson(_$UserRequestImpl instance) =>
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

_$UserPasswordRequestImpl _$$UserPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPasswordRequestImpl(
      oldPassword: json['old_password'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$UserPasswordRequestImplToJson(
        _$UserPasswordRequestImpl instance) =>
    <String, dynamic>{
      'old_password': instance.oldPassword,
      'password': instance.password,
    };

_$UserNotificationRequestImpl _$$UserNotificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UserNotificationRequestImpl(
      token: json['token'] as String,
    );

Map<String, dynamic> _$$UserNotificationRequestImplToJson(
        _$UserNotificationRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
