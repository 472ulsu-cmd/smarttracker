import '../models/user.dart';

/// Контракт репозитория профиля.
abstract class ProfileRepository {
  /// Получить профиль (`GET /user`).
  Future<User> fetchProfile();

  /// Обновить профиль (`POST /user`, затем повторный `GET /user`).
  Future<User> updateProfile({
    String? login,
    String? name,
    String? secondName,
    String? surname,
    String? phone,
    int? phoneCode,
  });

  /// Смена пароля (`POST /user/password`).
  Future<void> changePassword(String oldPassword, String newPassword);

  /// Загрузить аватар (base64) (`POST /user/photo`).
  Future<void> uploadAvatar(String filePath);
}
