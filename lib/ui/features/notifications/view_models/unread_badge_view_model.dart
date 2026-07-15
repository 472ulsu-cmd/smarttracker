import 'package:flutter/foundation.dart';

import '../../../../domain/repositories/notifications_repository.dart';

/// Глобальный счётчик непрочитанных уведомлений для бейджа в нижней навигации.
class UnreadBadgeViewModel extends ChangeNotifier {
  UnreadBadgeViewModel(this._repository);

  final NotificationsRepository _repository;

  int _count = 0;
  int get count => _count;

  bool _isLoading = false;

  Future<void> refresh() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final items = await _repository.fetchNotifications();
      final newCount = items.where((n) => !n.isRead).length;
      if (newCount != _count) {
        _count = newCount;
        notifyListeners();
      }
    } catch (_) {
      // Тихо игнорируем — бейдж не критичен.
    } finally {
      _isLoading = false;
    }
  }
}
