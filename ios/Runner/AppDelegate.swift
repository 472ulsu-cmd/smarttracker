import Flutter
import UIKit
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
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
    // Соответствие UNUserNotificationCenterDelegate объявлено здесь явно, а не
    // через `self as UNUserNotificationCenterDelegate`: в данном Flutter SDK
    // FlutterAppDelegate не соответствует этому протоколу, и force-cast упал бы
    // в runtime.
    UNUserNotificationCenter.current().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Показываем входящее уведомление, пока приложение открыто. Без этого
  /// foreground-пуши и локальные уведомления silently пропадают на iOS 10+.
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .list, .sound])
  }
}
