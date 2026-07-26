import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/profile_repository.dart';
import '../../../features/auth/view_models/auth_view_model.dart';

/// ViewModel профиля: загрузка, редактирование, смена пароля, аватар.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._repository);

  final ProfileRepository _repository;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- Подтверждение нового телефона по SMS (смена телефона в профиле) ---

  /// Кулдаун повторной отправки SMS-кода, секунд. Совпадает с auth-флоу.
  static const int resendCooldownSeconds = 30;

  /// Номер, на который отправили код (для UI и resend).
  String? _pendingPhone;
  String? get pendingPhone => _pendingPhone;

  bool _isVerifying = false;
  bool get isVerifying => _isVerifying;

  Timer? _cooldownTimer;
  int _resendRemaining = 0;

  /// Секунд до разблокировки повторной отправки (0 — можно отправлять).
  int get resendRemaining => _resendRemaining;

  /// Можно ли запросить код повторно прямо сейчас.
  bool get canResend => _resendRemaining == 0 && !_isVerifying;

  AuthRepository get _authRepository => getIt<AuthRepository>();

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.fetchProfile();
      getIt<AuthViewModel>().updateUser(_user!);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Не удалось загрузить профиль. Проверьте подключение и обновите экран.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String secondName,
    required String surname,
    required String phone,
    required int phoneCode,
    required String login,
  }) async {
    if (_isSaving) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.updateProfile(
        login: login,
        name: name,
        secondName: secondName,
        surname: surname,
        phone: phone,
        phoneCode: phoneCode,
      );
      getIt<AuthViewModel>().updateUser(_user!);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось сохранить изменения. Проверьте данные и попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_isSaving) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.changePassword(oldPassword, newPassword);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось сменить пароль. Проверьте текущий пароль и попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> uploadAvatar(String filePath) async {
    if (_isSaving) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.uploadAvatar(filePath);
      _user = await _repository.fetchProfile();
      getIt<AuthViewModel>().updateUser(_user!);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось загрузить фото профиля. Проверьте подключение и попробуйте другое изображение.';
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // --- Смена телефона с подтверждением по SMS ---

  /// Шаг 1: отправить SMS-код на [newPhone] (под текущим логином).
  /// Сервер (`/user/send_phone_code`) отправляет код реальному абоненту.
  /// Возвращает true при успехе и запускает кулдаун повторной отправки.
  Future<bool> requestPhoneCode(String newPhone) async {
    if (_isVerifying) return false;
    _isVerifying = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authRepository.sendPhoneCode(_user!.login, newPhone);
      _pendingPhone = newPhone;
      _startCooldown();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _pendingPhone = null;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось отправить код. Проверьте номер телефона и попробуйте ещё раз.';
      _pendingPhone = null;
      notifyListeners();
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  /// Повторная отправка кода на [_pendingPhone]. Гейтится кулдауном —
  /// возвращает false, если кулдаун ещё не истёк или номер неизвестён.
  Future<bool> resendPhoneCode() async {
    final phone = _pendingPhone;
    if (phone == null || !canResend) return false;
    _isVerifying = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authRepository.sendPhoneCode(_user!.login, phone);
      _startCooldown();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось отправить код. Попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  /// Шаги 2+3: проверить SMS-код и при успехе сохранить профиль с новым
  /// телефоном. Сервер требует подтверждения номера до `POST /user`
  /// (иначе `code:-14 «The phone unconfirmed»`).
  Future<bool> confirmPhoneAndSave({
    required String code,
    required String newPhone,
    required String name,
    required String secondName,
    required String surname,
    required String login,
  }) async {
    if (_isVerifying) return false;
    _isVerifying = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Сначала проверяем код — без этого POST /user отклонит смену телефона.
      await _authRepository.verifyPhoneCode(_user!.login, newPhone, code);
      // Код верный → сохраняем профиль (телефон уже подтверждён сервером).
      _user = await _repository.updateProfile(
        login: login,
        name: name,
        secondName: secondName,
        surname: surname,
        phone: newPhone,
        phoneCode: 1,
      );
      getIt<AuthViewModel>().updateUser(_user!);
      _pendingPhone = null;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось сохранить профиль. Попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  /// Сброс SMS-флоу (при отмене) — чистит ожидающий номер и ошибку.
  void resetPhoneConfirmation() {
    _pendingPhone = null;
    _errorMessage = null;
    _cooldownTimer?.cancel();
    _resendRemaining = 0;
    notifyListeners();
  }

  /// Запуск/перезапуск отсчёта кулдауна после успешной отправки кода.
  /// Отсчёт по тикам таймера: в худшем случае (пауза приложения в фоне)
  /// кулдаун длится чуть дольше — это безопасная сторона ошибки.
  void _startCooldown() {
    _resendRemaining = resendCooldownSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendRemaining <= 1) {
        _resendRemaining = 0;
        timer.cancel();
      } else {
        _resendRemaining -= 1;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
