import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Регистрируем AppDelegate делегатом центра уведомлений ДО регистрации
    // плагинов. iOS по умолчанию прячет уведомления, пока приложение на переднем
    // плане, — явный делегат это снимает. flutter_local_notifications при вызове
    // initialize() перехватит делегат себе и будет форвардить вызовы к прежнему
    // делегату, поэтому firebase_messaging (onMessage/onMessageOpenedApp) и
    // flutter_local_notifications (onDidReceiveNotificationResponse) продолжают
    // работать совместно.
    //
    // В Flutter 3.44.6 FlutterAppDelegate уже соответствует
    // UNUserNotificationCenterDelegate, поэтому протокол отдельно не объявляем —
    // достаточно назначить self делегатом и переопределить willPresent.
    UNUserNotificationCenter.current().delegate = self

    // Регистрируем callback для flutter_foreground_task: без этого плагин не
    // сможет запустить TaskHandler в фоновом изоляте на iOS (через
    // BGTaskScheduler) — onStart/onRepeatEvent не вызовутся, координаты не
    // будут отправляться. На Android это не требуется (там foreground service).
    SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// Показываем входящее уведомление, пока приложение открыто. Без этого
  /// foreground-пуши и локальные уведомления silently пропадают на iOS 10+.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .list, .sound])
  }
}
