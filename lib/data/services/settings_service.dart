import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Локальные настройки приложения (без backend).
///
/// Хранит флаг включённости push-уведомлений. По умолчанию включены.
class SettingsService extends ChangeNotifier {
  SettingsService();

  SharedPreferences? _prefs;

  bool _pushEnabled = true;
  bool get pushEnabled => _pushEnabled;

  static const _keyPush = 'push_enabled';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _pushEnabled = _prefs?.getBool(_keyPush) ?? true;
    notifyListeners();
  }

  Future<void> setPushEnabled(bool value) async {
    _pushEnabled = value;
    await _prefs?.setBool(_keyPush, value);
    notifyListeners();
  }
}
