/// Ответ `GET /user` (профиль водителя).
class UserResponse {
  const UserResponse({
    this.id,
    this.login,
    this.name,
    this.secondName,
    this.surname,
    this.phone,
    this.phoneCode,
    this.avatar,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
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
