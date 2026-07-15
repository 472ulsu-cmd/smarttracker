import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Ответ `POST /login`.
///
/// При успехе `code == 200` и поля `token`/`account` заполнены.
/// При ошибке `code < 0` (например -4, -10) — учётные данные неверны.
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'code') int? code,
    String? token,
    AccountApiModel? account,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Вложенная модель аккаунта из ответа `/login`.
@freezed
class AccountApiModel with _$AccountApiModel {
  const factory AccountApiModel({
    int? id,
    String? login,
    String? name,
    @JsonKey(name: 'second_name') String? secondName,
    String? surname,
    String? phone,
    @JsonKey(name: 'phone_code') int? phoneCode,
    String? avatar,
  }) = _AccountApiModel;

  factory AccountApiModel.fromJson(Map<String, dynamic> json) =>
      _$AccountApiModelFromJson(json);
}
