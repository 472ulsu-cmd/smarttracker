import 'package:flutter/foundation.dart';

import 'notifications_view_model.dart';

/// Глобальный счётчик непрочитанных уведомлений для бейджа в нижней навигации.
///
/// Единственный источник правды о непрочитанных — [NotificationsViewModel]
/// (singleton). Этот бейдж — его проекция: слушает VM и выводит `count` из
/// `unreadCount`, поэтому мгновенно реагирует на markAsRead/markAllRead, а не
/// только на полный refresh при перезаходе на вкладку.
///
/// `refresh()` сохранён для двух внешних триггеров, где данных в VM ещё нет:
/// холодный старт (вкладка ещё не открывалась — список мог не загрузиться) и
/// приход нового пуша ([PushService]). В этих случаях тянем свежий список
/// через репозиторий VM.
class UnreadBadgeViewModel extends ChangeNotifier {
  UnreadBadgeViewModel(this._notifications);

  final NotificationsViewModel _notifications;

  int _count = 0;
  int get count => _count;

  bool _isLoading = false;

  /// Подписка уже навешана. addListener во Flutter не дедуплицирует, поэтому
  /// гардуем сами: повторный вызов syncFromNotifications не регистрирует
  /// слушатель дважды (иначе dispose снимет только одну копию — утечка).
  bool _subscribed = false;

  @override
  void dispose() {
    if (_subscribed) {
      _notifications.removeListener(_onNotificationsChanged);
      _subscribed = false;
    }
    super.dispose();
  }

  /// Слушатель изменений списка уведомлений: пересчитывает бейдж из
  /// актуального `unreadCount` VM. Вызывается на markAsRead/markAllRead/load.
  void _onNotificationsChanged() {
    final newCount = _notifications.unreadCount;
    if (newCount != _count) {
      _count = newCount;
      notifyListeners();
    }
  }

  /// Подписать бейдж на NotificationsVM и синхронизировать count из уже
  /// загруженного списка (без запроса). Идемпотентна: повторные вызовы
  /// безопасны. Вызывается при первом показе бейджа (MainShell.initState).
  void syncFromNotifications() {
    if (_subscribed) return;
    _notifications.addListener(_onNotificationsChanged);
    _subscribed = true;
    _onNotificationsChanged();
  }

  /// Перечитать непрочитанные с сервера. Используется там, где данных в VM
  /// может ещё не быть: холодный старт до первого открытия вкладки и приход
  /// нового пуша. load() VM обновит и список, и бейдж (через подписку
  /// _onNotificationsChanged); syncFromNotifications навешивает подписку.
  Future<void> refresh() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      // load() дёрнет notifyListeners → _onNotificationsChanged обновит _count.
      // Подписка должна быть уже навешана (syncFromNotifications в MainShell);
      // если вдруг нет — навешиваем здесь, иначе обновление не дойдёт.
      syncFromNotifications();
      await _notifications.load();
    } catch (_) {
      // Тихо игнорируем — бейдж не критичен.
    } finally {
      _isLoading = false;
    }
  }
}
