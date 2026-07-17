// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRequest _$UserRequestFromJson(Map<String, dynamic> json) => _UserRequest(
      id: (json['id'] as num?)?.toInt(),
      login: json['login'] as String?,
      name: json['name'] as String?,
      secondName: json['second_name'] as String?,
      surname: json['surname'] as String?,
      phone: json['phone'] as String?,
      phoneCode: (json['phone_code'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UserRequestToJson(_UserRequest instance) =>
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

_UserPasswordRequest _$UserPasswordRequestFromJson(Map<String, dynamic> json) =>
    _UserPasswordRequest(
      oldPassword: json['old_password'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserPasswordRequestToJson(
        _UserPasswordRequest instance) =>
    <String, dynamic>{
      'old_password': instance.oldPassword,
      'password': instance.password,
    };

_UserNotificationRequest _$UserNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    _UserNotificationRequest(
      token: json['token'] as String,
    );

Map<String, dynamic> _$UserNotificationRequestToJson(
        _UserNotificationRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
