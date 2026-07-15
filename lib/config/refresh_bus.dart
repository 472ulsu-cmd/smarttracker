import 'package:flutter/foundation.dart';

/// Общая шина обновлений списка заявок.
///
/// Позволяет триггерить перезагрузку списка из любого места
/// (после смены статуса заявки, при новом FCM-уведомлении).
class OrdersRefreshBus extends ChangeNotifier {
  void notifyChanged() => notifyListeners();
}

/// Общая шина обновлений списка уведомлений.
class NotificationsRefreshBus extends ChangeNotifier {
  void notifyChanged() => notifyListeners();
}
