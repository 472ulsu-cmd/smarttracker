import 'package:flutter/foundation.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/user.dart';
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
}
