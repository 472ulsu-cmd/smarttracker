import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Одноразовые контекстные подсказки рабочего процесса заявки.
enum OnboardingHint {
  newOrderSwipe('new_order_swipe_hint_v1'),
  orderRouteEntry('order_route_entry_hint_v1'),
  routeMap('route_map_hint_v1'),
  orderPhotoEntry('order_photo_entry_hint_v1');

  const OnboardingHint(this.storageKey);

  final String storageKey;
}

/// Локальные настройки приложения (без backend).
///
/// Хранит флаг включённости push-уведомлений и просмотренные подсказки.
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

  /// Была ли уже показана конкретная версия контекстной подсказки.
  bool hasSeenOnboardingHint(OnboardingHint hint) =>
      _prefs?.getBool(hint.storageKey) ?? false;

  /// Запоминает показ подсказки на этом устройстве.
  Future<void> markOnboardingHintSeen(OnboardingHint hint) async {
    if (hasSeenOnboardingHint(hint)) return;
    await _prefs?.setBool(hint.storageKey, true);
    notifyListeners();
  }
}
