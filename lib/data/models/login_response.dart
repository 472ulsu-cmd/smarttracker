/// Ответ `POST /login`.
///
/// При успехе `code == 200` и поля `token`/`account` заполнены.
/// При ошибке `code < 0` (например -4, -10) — учётные данные неверны.
class LoginResponse {
  const LoginResponse({this.code, this.token, this.account});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: (json['code'] as num?)?.toInt(),
        token: json['token'] as String?,
        account: json['account'] is Map<String, dynamic>
            ? AccountApiModel.fromJson(json['account'] as Map<String, dynamic>)
            : null,
      );

  final int? code;
  final String? token;
  final AccountApiModel? account;
}

/// Вложенная модель аккаунта из ответа `/login`.
class AccountApiModel {
  const AccountApiModel({
    this.id,
    this.login,
    this.name,
    this.secondName,
    this.surname,
    this.phone,
    this.phoneCode,
    this.avatar,
  });

  factory AccountApiModel.fromJson(Map<String, dynamic> json) =>
      AccountApiModel(
        id: (json['id'] as num?)?.toInt(),
        login: json['login'] as String?,
        name: json['name'] as String?,
        secondName: json['second_name'] as String?,
        surname: json['surname'] as String?,
        phone: json['phone'] as String?,
        phoneCode: (json['phone_code'] as num?)?.toInt(),
        avatar: json['avatar'] as String?,
      );

  final int? id;
  final String? login;
  final String? name;
  final String? secondName;
  final String? surname;
  final String? phone;
  final int? phoneCode;
  final String? avatar;
}
