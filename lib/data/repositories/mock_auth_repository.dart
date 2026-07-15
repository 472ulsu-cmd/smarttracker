import 'dart:async';

import '../../domain/models/app_exception.dart';
import '../../domain/models/app_session.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Заглушка [AuthRepository] для демонстрации без backend.
///
/// Тестовая учётная запись: логин `1234567890`, пароль `123456`.
/// Любые другие учётные данные → [ValidationException].
class MockAuthRepository implements AuthRepository {
  MockAuthRepository();

  static const _testLogin = '1234567890';
  static const _testPassword = '123456';
  static const _mockToken = 'mock.jwt.token';

  User? _currentUser;

  @override
  Future<AppSession> login(String login, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (login.trim() != _testLogin || password != _testPassword) {
      throw const ValidationException(message: 'Неверный паспорт или пароль.');
    }
    final user = _demoUser();
    _currentUser = user;
    return AppSession(token: _mockToken, user: user);
  }

  @override
  Future<User> fetchCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = _currentUser ?? _demoUser();
    _currentUser = user;
    return user;
  }

  @override
  Future<AppSession?> checkSession() async {
    // В mock-режиме сессию не восстанавливаем — всегда требуем вход.
    return null;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<void> sendPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> sendRestoringPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> verifyPhoneCode(
    String login,
    String phone,
    String code, {
    int phoneCodeId = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // В mock-режиме принимаем любой 4-значный код.
    if (code.length != 4) {
      throw const ValidationException(message: 'Неверный код из SMS.');
    }
  }

  @override
  Future<AppSession> registerAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async {
    return this.login(login, password);
  }

  @override
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async {
    return this.login(login, password);
  }

  User _demoUser() => const User(
        id: 1,
        login: _testLogin,
        name: 'Иван',
        secondName: 'Иванович',
        surname: 'Иванов',
        phone: '9001234567',
        phoneCode: 1,
        avatar: '',
      );
}
