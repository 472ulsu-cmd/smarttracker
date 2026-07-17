import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_requests.freezed.dart';
part 'registration_requests.g.dart';

/// `POST /registration` и `POST /restore`.
@freezed
abstract class RegistrationRequest with _$RegistrationRequest {
  const factory RegistrationRequest({
    required String login,
    required String password,
    required String phone,
    @JsonKey(name: 'phone_code_id') required int phoneCodeId,
  }) = _RegistrationRequest;

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);
}

/// Запрос SMS-кода (`POST /user/send_phone_code`, `send_restoring_phone_code`).
@freezed
abstract class SendPhoneCodeRequest with _$SendPhoneCodeRequest {
  const factory SendPhoneCodeRequest({
    required String login,
    required String phone,
    @JsonKey(name: 'phone_code_id') required int phoneCodeId,
  }) = _SendPhoneCodeRequest;

  factory SendPhoneCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendPhoneCodeRequestFromJson(json);
}

/// Проверка SMS-кода (`POST /user/verify_phone_code`).
@freezed
abstract class VerifyPhoneCodeRequest with _$VerifyPhoneCodeRequest {
  const factory VerifyPhoneCodeRequest({
    required String login,
    required String phone,
    @JsonKey(name: 'phone_code_id') required int phoneCodeId,
    required String code,
  }) = _VerifyPhoneCodeRequest;

  factory VerifyPhoneCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyPhoneCodeRequestFromJson(json);
}
