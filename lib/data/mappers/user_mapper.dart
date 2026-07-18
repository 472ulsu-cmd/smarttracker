import '../../domain/models/user.dart';
import '../models/login_response.dart';
import '../models/user_response.dart';

/// Преобразование API-моделей пользователя в доменную [User].
class UserMapper {
  UserMapper._();

  /// Аккаунт из ответа `/login`.
  static User fromAccount(AccountApiModel a) {
    return User(
      id: a.id ?? 0,
      login: a.login ?? '',
      name: a.name ?? '',
      secondName: a.secondName ?? '',
      surname: a.surname ?? '',
      phone: a.phone ?? '',
      phoneCode: a.phoneCode ?? 1,
      avatar: a.avatar ?? '',
    );
  }

  /// Профиль из ответа `/user`.
  static User fromResponse(UserResponse u) {
    return User(
      id: u.id ?? 0,
      login: u.login ?? '',
      name: u.name ?? '',
      secondName: u.secondName ?? '',
      surname: u.surname ?? '',
      phone: u.phone ?? '',
      phoneCode: u.phoneCode ?? 1,
      avatar: u.avatar ?? '',
    );
  }
}
