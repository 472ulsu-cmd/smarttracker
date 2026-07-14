import 'package:flutter/foundation.dart';

import '../../../../data/services/sync_config_service.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/app_session.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/sync_repository.dart';

/// Состояние аутентификации в жизненном цикле приложения.
enum AuthStatus {
  /// Идёт начальная проверка сессии.
  initial,

  /// Пользователь не аутентифицирован — показать экран входа.
  unauthenticated,

  /// Пользователь аутентифицирован.
  authenticated,
}

/// ViewModel экрана входа и глобального состояния аутентификации.
///
/// MVVM: хранит состояние UI, делегирует работу [AuthRepository],
/// уведомляет View через [notifyListeners].
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(
    this._repository,
    this._syncRepository,
    this._syncConfigService,
  );

  final AuthRepository _repository;
  final SyncRepository _syncRepository;
  final SyncConfigService _syncConfigService;

  Future<void> _fetchAndStoreSyncConfig() async {
    try {
      final config = await _syncRepository.fetchSyncConfig();
      await _syncConfigService.save(config);
    } catch (_) {
      // Оставляем последнее сохранённое значение или fallback.
    }
  }

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Проверка сохранённой сессии при запуске приложения.
  Future<void> checkSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _repository.checkSession();
      if (session != null) {
        _user = session.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        await _fetchAndStoreSyncConfig();
      } else {
        _user = null;
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _user = null;
      _status = AuthStatus.unauthenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Вход по паспорту (login) и паролю.
  Future<bool> login(String login, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _repository.login(login, password);
      _user = session.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      await _fetchAndStoreSyncConfig();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось войти. Попробуйте позже.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Выход из учётной записи.
  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  /// Сбросить сообщение об ошибке (например, при редактировании полей).
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Обновить пользователя после редактирования профиля.
  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }

  AppSession? get session {
    if (_status != AuthStatus.authenticated || _user == null) return null;
    return null; // токен хранится в SecureStorage, не дублируем в памяти
  }
}
