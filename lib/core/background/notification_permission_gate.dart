import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/services/settings_service.dart';

/// Запускает системный запрос уведомлений только после swipe-онбординга.
///
/// Инициализация push-сервиса остаётся независимой от наличия новой заявки,
/// а системный диалог не конкурирует за внимание с первой подсказкой.
class NotificationPermissionGate {
  NotificationPermissionGate({
    required SettingsService settings,
    required Future<void> Function() requestPermission,
  }) : _settings = settings,
       _requestPermission = requestPermission;

  final SettingsService _settings;
  final Future<void> Function() _requestPermission;

  bool _isListening = false;
  bool _requestTriggered = false;

  void start() {
    if (_isListening) return;
    _isListening = true;
    _settings.addListener(_onSettingsChanged);
    _maybeRequestPermission();
  }

  void dispose() {
    if (!_isListening) return;
    _settings.removeListener(_onSettingsChanged);
    _isListening = false;
  }

  void _onSettingsChanged() => _maybeRequestPermission();

  void _maybeRequestPermission() {
    if (!_isListening ||
        _requestTriggered ||
        !_settings.hasSeenOnboardingHint(OnboardingHint.newOrderSwipe)) {
      return;
    }

    _requestTriggered = true;
    unawaited(_runRequest());
  }

  Future<void> _runRequest() async {
    try {
      await _requestPermission();
    } catch (error, stackTrace) {
      debugPrint(
        'push: запрос разрешения после онбординга завершился ошибкой: '
        '$error\n$stackTrace',
      );
    }
  }
}
