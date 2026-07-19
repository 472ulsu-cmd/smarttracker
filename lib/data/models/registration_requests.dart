/// `POST /registration` и `POST /restore`.
class RegistrationRequest {
  const RegistrationRequest({
    required this.login,
    required this.password,
    required this.phone,
    required this.phoneCodeId,
  });

  final String login;
  final String password;
  final String phone;
  final int phoneCodeId;

  Map<String, dynamic> toJson() => {
        'login': login,
        'password': password,
        'phone': phone,
        'phone_code_id': phoneCodeId,
      };
}

/// Запрос SMS-кода (`POST /user/send_phone_code`, `send_restoring_phone_code`).
class SendPhoneCodeRequest {
  const SendPhoneCodeRequest({
    required this.login,
    required this.phone,
    required this.phoneCodeId,
  });

  final String login;
  final String phone;
  final int phoneCodeId;

  Map<String, dynamic> toJson() => {
        'login': login,
        'phone': phone,
        'phone_code_id': phoneCodeId,
      };
}

/// Проверка SMS-кода (`POST /user/verify_phone_code`).
class VerifyPhoneCodeRequest {
  const VerifyPhoneCodeRequest({
    required this.login,
    required this.phone,
    required this.phoneCodeId,
    required this.code,
  });

  final String login;
  final String phone;
  final int phoneCodeId;
  final String code;

  Map<String, dynamic> toJson() => {
        'login': login,
        'phone': phone,
        'phone_code_id': phoneCodeId,
        'code': code,
      };
}
