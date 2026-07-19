/// Тело запроса обновления профиля (`POST /user`).
class UserRequest {
  const UserRequest({
    this.id,
    this.login,
    this.name,
    this.secondName,
    this.surname,
    this.phone,
    this.phoneCode,
    this.avatar,
  });

  final int? id;
  final String? login;
  final String? name;
  final String? secondName;
  final String? surname;
  final String? phone;
  final int? phoneCode;
  final String? avatar;

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'name': name,
        'second_name': secondName,
        'surname': surname,
        'phone': phone,
        'phone_code': phoneCode,
        'avatar': avatar,
      };
}

/// Тело запроса смены пароля (`POST /user/password`).
class UserPasswordRequest {
  const UserPasswordRequest({
    required this.oldPassword,
    required this.password,
  });

  final String oldPassword;
  final String password;

  Map<String, dynamic> toJson() => {
        'old_password': oldPassword,
        'password': password,
      };
}

/// Тело запроса отправки FCM-токена (`PUT /user/notification`).
class UserNotificationRequest {
  const UserNotificationRequest({required this.token});

  final String token;

  Map<String, dynamic> toJson() => {'token': token};
}
