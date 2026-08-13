import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttracker/core/background/notification_permission_gate.dart';
import 'package:smarttracker/data/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'разрешение запрашивается только после завершения swipe-онбординга',
    () async {
      SharedPreferences.setMockInitialValues({});
      final settings = SettingsService();
      await settings.init();
      var requestCount = 0;
      final gate = NotificationPermissionGate(
        settings: settings,
        requestPermission: () async => requestCount++,
      )..start();
      addTearDown(gate.dispose);

      expect(requestCount, 0);

      await settings.markOnboardingHintSeen(OnboardingHint.routeMap);
      expect(requestCount, 0);

      await settings.markOnboardingHintSeen(OnboardingHint.newOrderSwipe);
      expect(requestCount, 1);

      await settings.setPushEnabled(false);
      expect(requestCount, 1);
    },
  );

  test(
    'для прошедшего онбординг разрешение запрашивается при старте',
    () async {
      SharedPreferences.setMockInitialValues({
        OnboardingHint.newOrderSwipe.storageKey: true,
      });
      final settings = SettingsService();
      await settings.init();
      var requestCount = 0;
      final gate = NotificationPermissionGate(
        settings: settings,
        requestPermission: () async => requestCount++,
      )..start();
      addTearDown(gate.dispose);

      expect(requestCount, 1);
    },
  );

  test('остановленный gate не реагирует на завершение онбординга', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.init();
    var requestCount = 0;
    final gate = NotificationPermissionGate(
      settings: settings,
      requestPermission: () async => requestCount++,
    )..start();

    gate.dispose();
    await settings.markOnboardingHintSeen(OnboardingHint.newOrderSwipe);

    expect(requestCount, 0);
  });
}
