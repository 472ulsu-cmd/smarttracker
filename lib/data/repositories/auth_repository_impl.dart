import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';
import '../../domain/models/app_session.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/registration_requests.dart';
import '../models/user_response.dart';
import '../services/secure_storage_service.dart';

/// Реализация [AuthRepository] поверх реального API.
///
/// Токен сохраняется в [SecureStorageService]; ко всем защищённым запросам
/// `AuthInterceptor` автоматически добавляет Bearer-заголовок.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required Dio dio, required SecureStorageService storage})
      : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final SecureStorageService _storage;

  @override
  Future<AppSession> login(String login, String password) async {
    try {
      final response = await _dio.post<dynamic>(
        '/login',
        data: LoginRequest(login: login, password: password),
      );
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = LoginResponse.fromJson(data);
      final code = parsed.code;

      // API возвращает code < 0 при неверных учётных данных.
      if (code == null || code < 0 || parsed.token == null) {
        throw ValidationException(message: _validationMessage(code));
      }

      await _storage.saveToken(parsed.token!);
      final account = parsed.account;
      final user = account != null
          ? _accountToUser(account)
          : await fetchCurrentUser();
      return AppSession(token: parsed.token!, user: user);
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<User> fetchCurrentUser() async {
    try {
      final response = await _dio.get<dynamic>('/user');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = UserResponse.fromJson(data);
      return _userResponseToUser(parsed);
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<AppSession?> checkSession() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) return null;
    try {
      final user = await fetchCurrentUser();
      return AppSession(token: token, user: user);
    } on UnauthorizedException {
      await _storage.deleteToken();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/logout');
    } catch (_) {
      // Игнорируем ошибку сети при выходе — токен всё равно чистим локально.
    }
    await _storage.deleteToken();
  }

  @override
  Future<void> sendPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    try {
      await _dio.post<dynamic>(
        '/user/send_phone_code',
        data: SendPhoneCodeRequest(
            login: login, phone: phone, phoneCodeId: phoneCodeId),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> sendRestoringPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    try {
      await _dio.post<dynamic>(
        '/user/send_restoring_phone_code',
        data: SendPhoneCodeRequest(
            login: login, phone: phone, phoneCodeId: phoneCodeId),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> verifyPhoneCode(
    String login,
    String phone,
    String code, {
    int phoneCodeId = 1,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/user/verify_phone_code',
        data: VerifyPhoneCodeRequest(
          login: login,
          phone: phone,
          phoneCodeId: phoneCodeId,
          code: code,
        ),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<AppSession> registerAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/registration',
        data: RegistrationRequest(
          login: login,
          password: password,
          phone: phone,
          phoneCodeId: phoneCodeId,
        ),
      );
      return await _doLogin(login, password);
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/restore',
        data: RegistrationRequest(
          login: login,
          password: password,
          phone: phone,
          phoneCodeId: phoneCodeId,
        ),
      );
      return await _doLogin(login, password);
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  /// Внутренний helper входа после регистрации/восстановления.
  Future<AppSession> _doLogin(String login, String password) async {
    return this.login(login, password);
  }

  // --- Маппинг API → домен ---

  User _accountToUser(AccountApiModel a) {
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

  User _userResponseToUser(UserResponse u) {
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

  String _validationMessage(int? code) {
    switch (code) {
      case -4:
      case -10:
        return 'Неверный паспорт или пароль. Проверьте введённые данные.';
      default:
        return 'Неверный паспорт или пароль. Проверьте введённые данные.';
    }
  }

  /// Достаёт доменное исключение из DioException (ErrorInterceptor кладёт его в `error`).
  Never _rethrowDio(DioException e) {
    final cause = e.error;
    if (cause is AppException) {
      throw cause;
    }
    throw const NetworkException();
  }
}
