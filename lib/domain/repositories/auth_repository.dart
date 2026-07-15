import '../models/app_session.dart';
import '../models/user.dart';

/// Режим stepper-флоу: регистрация или восстановление пароля.
enum AuthFlowMode { registration, recovery }

/// Контракт репозитория аутентификации (доменный интерфейс).
///
/// Реализации: [AuthRepositoryImpl] (реальный API) и
/// [MockAuthRepository] (заглушка для отладки без сервера).
abstract class AuthRepository {
  /// Вход по паспорту (login) и паролю.
  /// Возвращает сессию с токеном и пользователем.
  /// Бросает [AppException] при ошибке.
  Future<AppSession> login(String login, String password);

  /// Текущий профиль пользователя по сохранённому токену (`GET /user`).
  Future<User> fetchCurrentUser();

  /// Проверка восстановленной сессии: токен есть → профиль валиден.
  /// Возвращает сессию или null, если не аутентифицирован.
  Future<AppSession?> checkSession();

  /// Выход: очистка токена.
  Future<void> logout();

  /// Запрос SMS-кода для регистрации (`POST /user/send_phone_code`).
  Future<void> sendPhoneCode(String login, String phone, {int phoneCodeId = 1});

  /// Запрос SMS-кода для восстановления (`POST /user/send_restoring_phone_code`).
  Future<void> sendRestoringPhoneCode(String login, String phone,
      {int phoneCodeId = 1});

  /// Проверка SMS-кода (`POST /user/verify_phone_code`).
  Future<void> verifyPhoneCode(
    String login,
    String phone,
    String code, {
    int phoneCodeId = 1,
  });

  /// Регистрация и автоматический вход (`POST /registration`, затем `/login`).
  Future<AppSession> registerAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  });

  /// Восстановление пароля и автоматический вход (`POST /restore`, затем `/login`).
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  });
}
