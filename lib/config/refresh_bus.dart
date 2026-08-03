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

/// Носитель pending deep-link: тап по пушу → открыть заявку.
///
/// [PushService] не имеет [BuildContext] и не может навигировать сам,
/// поэтому он пишет целевой путь сюда через [request], а `_SmartTrackerApp`
/// слушает шину и зовёт `GoRouter.go` при срабатывании [consume].
class DeepLinkBus extends ChangeNotifier {
  String? _pendingPath;

  /// Одноразово возвращает накопленный путь и очищает поле,
  /// чтобы повторные notifyListeners без нового [request] не переоткрывали экран.
  String? consume() {
    final p = _pendingPath;
    _pendingPath = null;
    return p;
  }

  /// Запросить переход на [path] (вызовет notifyListeners).
  void request(String path) {
    _pendingPath = path;
    notifyListeners();
  }
}
