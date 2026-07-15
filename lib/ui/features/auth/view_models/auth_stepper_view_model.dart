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

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Шаг 1 → 2: проверка паспорта.
  bool validatePassport() {
    if (passport.length != 10 || passport != passportConfirm) {
      _errorMessage = 'Введите 10 цифр серии и номера паспорта. Оба поля должны совпадать.';
      notifyListeners();
      return false;
    }
    return true;
  }

  /// Шаг 2 → 3: запрос SMS-кода.
  Future<bool> requestSmsCode() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      if (mode == AuthFlowMode.registration) {
        await _repository.sendPhoneCode(passport, phone);
      } else {
        await _repository.sendRestoringPhoneCode(passport, phone);
      }
      _step = AuthStep.sms;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось отправить код. Проверьте номер телефона и попробуйте ещё раз.';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}
