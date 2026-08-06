import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/repositories/auth_repository.dart';

/// Шаги единого stepper-флоу (регистрация и восстановление пароля).
enum AuthStep { passport, phone, sms, password }

/// ViewModel 4-шагового флоу регистрации/восстановления пароля.
class AuthStepperViewModel extends ChangeNotifier {
  AuthStepperViewModel(this._repository, this.mode);

  final AuthRepository _repository;
  final AuthFlowMode mode;

  /// Кулдаун повторной отправки SMS-кода, секунд.
  static const int resendCooldownSeconds = 60;

  AuthStep _step = AuthStep.passport;
  AuthStep get step => _step;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Данные, собранные по шагам.
  String passport = '';
  String passportConfirm = '';
  String phone = '';
  String smsCode = '';
  String password = '';
  String passwordConfirm = '';

  // --- Повторная отправка SMS с кулдауном ---

  Timer? _cooldownTimer;
  int _resendRemaining = 0;

  /// Секунд до разблокировки повторной отправки (0 — можно отправлять).
  int get resendRemaining => _resendRemaining;

  /// Можно ли запросить код повторно прямо сейчас.
  bool get canResend => _resendRemaining == 0 && !_isLoading;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Шаг 1 → 2: проверка паспорта.
  bool validatePassport() {
    if (passport.length != 10) {
      _errorMessage = 'Введите 10 цифр серии и номера паспорта.';
      notifyListeners();
      return false;
    }
    if (mode == AuthFlowMode.registration && passport != passportConfirm) {
      _errorMessage = 'Паспортные данные не совпадают. Проверьте ввод.';
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Отправка SMS-кода (общее ядро для [requestSmsCode] и [resendCode]).
  Future<bool> _sendCode() async {
    try {
      if (mode == AuthFlowMode.registration) {
        await _repository.sendPhoneCode(passport, phone);
      } else {
        await _repository.sendRestoringPhoneCode(passport, phone);
      }
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось отправить код. Проверьте номер телефона и попробуйте ещё раз.';
      return false;
    }
  }

  /// Шаг 2 → 3: запрос SMS-кода.
  Future<bool> requestSmsCode() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final ok = await _sendCode();
    _isLoading = false;
    if (ok) {
      _step = AuthStep.sms;
      _startCooldown();
    }
    notifyListeners();
    return ok;
  }

  /// Повторная отправка кода с SMS-шага. Гейтится кулдауном —
  /// возвращает false, если кулдаун ещё не истёк.
  Future<bool> resendCode() async {
    if (!canResend) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final ok = await _sendCode();
    _isLoading = false;
    if (ok) {
      _startCooldown();
    }
    notifyListeners();
    return ok;
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

  /// Шаг 3 → 4: проверка SMS-кода.
  Future<bool> verifyCode() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.verifyPhoneCode(passport, phone, smsCode);
      _step = AuthStep.password;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось проверить код. Попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Валидация пароля перед финальным шагом.
  bool validatePassword() {
    if (password.length < 6) {
      _errorMessage = 'Пароль должен содержать не менее 6 символов.';
      notifyListeners();
      return false;
    }
    if (password != passwordConfirm) {
      _errorMessage = 'Пароли не совпадают. Введите одинаковые значения.';
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Завершить флоу: финальный запрос (register/recover) + вход.
  /// Возвращает true, если пользователь залогинен.
  Future<bool> finish() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (mode == AuthFlowMode.registration) {
        await _repository.registerAndLogin(
          login: passport,
          password: password,
          phone: phone,
        );
      } else {
        await _repository.recoverAndLogin(
          login: passport,
          password: password,
          phone: phone,
        );
      }
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось сохранить пароль. Попробуйте позже.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void goToStep(AuthStep s) {
    _step = s;
    notifyListeners();
  }

  /// Шаг назад по флоу с сохранением введённых данных.
  /// На первом шаге — no-op (выход из флоу обрабатывает экран).
  void back() {
    switch (_step) {
      case AuthStep.passport:
        break;
      case AuthStep.phone:
        _step = AuthStep.passport;
        break;
      case AuthStep.sms:
        _step = AuthStep.phone;
        break;
      case AuthStep.password:
        _step = AuthStep.sms;
        break;
    }
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
