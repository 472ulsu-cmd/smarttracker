import 'package:flutter/foundation.dart';

import '../../../../config/service_locator.dart';
import '../../../../data/services/settings_service.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/notification_item.dart';
import '../../../../domain/repositories/notifications_repository.dart';

/// ViewModel экрана уведомлений.
///
/// Поддерживает оптимистичное обновление при mark-as-read и undo.
class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel(this._repository)
      : settings = getIt<SettingsService>();

  final NotificationsRepository _repository;
  final SettingsService settings;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Безопасный notifyListeners: не вызывает после dispose,
  /// чтобы избежать AssertionError при уходе с экрана во время async-операции.
  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  List<NotificationItem> _items = const [];
  List<NotificationItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  /// Занят ли ViewModel любой асинхронной операцией (загрузкой или изменением).
  bool get isBusy => _isLoading || _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _actionErrorMessage;
  String? get actionErrorMessage => _actionErrorMessage;

  /// Возвращает и сбрасывает сообщение об ошибке пользовательского действия.
  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  /// Возвращает и сбрасывает сообщение об ошибке загрузки, если список не пуст.
  /// Для пустого списка ошибка остаётся для отображения inline.
  String? takeTransientError() {
    if (_errorMessage != null && _items.isNotEmpty) {
      final message = _errorMessage;
      _errorMessage = null;
      return message;
    }
    return null;
  }

  int get unreadCount => items.where((n) => !n.isRead).length;

  Future<void> load() async {
    if (_isLoading || _isSaving) return;
    _isLoading = true;
    _errorMessage = null;
    _actionErrorMessage = null;
    _safeNotify();

    try {
      final loaded = await _repository.fetchNotifications();
      // Сортировка от новейших к старейшим (по datetime по убыванию).
      _items = loaded..sort(_compareNewestFirst);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Не удалось загрузить уведомления. Проверьте подключение к интернету.';
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  /// Отметить одно прочитанным (оптимистично + undo).
  Future<void> markAsRead(int id) async {
    if (_isLoading || _isSaving) return;
    final index = _items.indexWhere((n) => n.id == id);
    if (index < 0) return;
    final previous = _items[index];
    if (previous.isRead) return;

    // Оптимистичное обновление UI.
    _items = List.of(_items)..[index] = previous.copyWith(isRead: true);
    _isSaving = true;
    _actionErrorMessage = null;
    _safeNotify();

    try {
      await _repository.markAsRead(id);
    } catch (_) {
      // Undo при ошибке.
      _items = List.of(_items)..[index] = previous;
      _actionErrorMessage = 'Не удалось отметить уведомление прочитанным. Попробуйте ещё раз.';
      _safeNotify();
    } finally {
      _isSaving = false;
      _safeNotify();
    }
  }

  /// Отметить все непрочитанные прочитанными.
  Future<void> markAllRead() async {
    if (_isLoading || _isSaving) return;
    final unreadIds = items.where((n) => !n.isRead).map((n) => n.id).toList();
    if (unreadIds.isEmpty) return;

    final previous = List<NotificationItem>.of(_items);
    _items = _items
        .map((n) => n.isRead ? n : n.copyWith(isRead: true))
        .toList();
    _isSaving = true;
    _actionErrorMessage = null;
    _safeNotify();

    try {
      await _repository.markAllAsRead(unreadIds);
    } catch (_) {
      _items = previous;
      _actionErrorMessage = 'Не удалось отметить уведомления прочитанными. Попробуйте ещё раз.';
      _safeNotify();
    } finally {
      _isSaving = false;
      _safeNotify();
    }
  }

  /// Переключатель push-уведомлений (локально).
  Future<void> togglePush(bool value) async {
    if (_isLoading || _isSaving) return;
    _isSaving = true;
    _actionErrorMessage = null;
    _safeNotify();

    try {
      await settings.setPushEnabled(value);
    } catch (_) {
      _actionErrorMessage = 'Не удалось сохранить настройку push-уведомлений. Попробуйте ещё раз.';
      _safeNotify();
    } finally {
      _isSaving = false;
      _safeNotify();
    }
  }

  /// Сравнение для сортировки: новейшие первыми (по убыванию datetime).
  int _compareNewestFirst(NotificationItem a, NotificationItem b) {
    final ta = _tryParse(a.datetime);
    final tb = _tryParse(b.datetime);
    // null-значения считаем «самыми старыми» — уходят в конец.
    if (ta == null && tb == null) return 0;
    if (ta == null) return 1;
    if (tb == null) return -1;
    // По убыванию: b раньше a → b первыми.
    return tb.compareTo(ta);
  }

  DateTime? _tryParse(String input) {
    try {
      // Нормализуем "YYYY-MM-DD HH:MM:SS" под DateTime.parse.
      final iso = input.length >= 11 && input[10] == ' '
          ? '${input.substring(0, 10)}T${input.substring(11)}'
          : input;
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }
}
