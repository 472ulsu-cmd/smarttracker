import 'package:shared_preferences/shared_preferences.dart';

/// Хранилище флагов "приложение было активировано из background-пуша
/// и нужно перезагрузить списки".
class PendingRefreshStore {
  PendingRefreshStore._();
  static final PendingRefreshStore instance = PendingRefreshStore._();

  static const _ordersKey = 'pending_refresh_orders';
  static const _notificationsKey = 'pending_refresh_notifications';

  Future<void> setOrdersNeedRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ordersKey, true);
  }

  Future<void> setNotificationsNeedRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, true);
  }

  Future<bool> consumeOrdersNeedRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_ordersKey) ?? false;
    if (value) await prefs.remove(_ordersKey);
    return value;
  }

  Future<bool> consumeNotificationsNeedRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_notificationsKey) ?? false;
    if (value) await prefs.remove(_notificationsKey);
    return value;
  }
}
