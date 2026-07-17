import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_request.freezed.dart';
part 'user_request.g.dart';

/// Тело запроса обновления профиля (`POST /user`).
@freezed
abstract class UserRequest with _$UserRequest {
  const factory UserRequest({
    int? id,
    String? login,
    String? name,
    @JsonKey(name: 'second_name') String? secondName,
    String? surname,
    String? phone,
    @JsonKey(name: 'phone_code') int? phoneCode,
    String? avatar,
  }) = _UserRequest;

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);
}

/// Тело запроса смены пароля (`POST /user/password`).
@freezed
abstract class UserPasswordRequest with _$UserPasswordRequest {
  const factory UserPasswordRequest({
    @JsonKey(name: 'old_password') required String oldPassword,
    required String password,
  }) = _UserPasswordRequest;

  factory UserPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$UserPasswordRequestFromJson(json);
}

/// Тело запроса отправки FCM-токена (`PUT /user/notification`).
@freezed
abstract class UserNotificationRequest with _$UserNotificationRequest {
  const factory UserNotificationRequest({
    required String token,
  }) = _UserNotificationRequest;

  factory UserNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationRequestFromJson(json);
}
