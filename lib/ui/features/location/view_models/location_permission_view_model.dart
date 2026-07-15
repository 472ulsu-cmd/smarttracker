import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Состояние разрешения геолокации.
enum LocationPermissionStatus {
  /// Ещё не проверяли.
  unknown,

  /// Разрешение «Всегда» выдано.
  granted,

  /// Разрешение не выдано (denied / deniedForever / не «always»).
  denied,
}

/// ViewModel разрешения геолокации.
///
/// Приложение требует `LocationPermission.always` для фоновой передачи
/// координат. Без этого разрешения работа в приложении блокируется.
class LocationPermissionViewModel extends ChangeNotifier {
  LocationPermissionStatus _status = LocationPermissionStatus.unknown;
  LocationPermissionStatus get status => _status;

  bool _isRequesting = false;
  bool get isRequesting => _isRequesting;

  bool _isOpeningSettings = false;
  bool get isOpeningSettings => _isOpeningSettings;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isGranted => _status == LocationPermissionStatus.granted;

  /// Проверить текущее разрешение без показа диалога.
  Future<void> check() async {
    try {
      final permission = await Geolocator.checkPermission();
      _applyPermission(permission);
    } catch (_) {
      _errorMessage =
          'Не удалось проверить разрешение геолокации. Повторите попытку.';
      _status = LocationPermissionStatus.denied;
    }
    notifyListeners();
  }

  /// Запросить разрешение геолокации через нативные диалоги.
  /// Сначала foreground, затем background (always), затем fallback в настройки.
  Future<bool> request() async {
    _isRequesting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Foreground-диалог.
      var permission = await Geolocator.requestPermission();

      // 2. Если не "always", запрашиваем background через permission_handler.
      if (permission != LocationPermission.always) {
        final backgroundStatus = await Permission.locationAlways.request();
        if (backgroundStatus.isGranted) {
          permission = LocationPermission.always;
        }
      }

      _applyPermission(permission);

      // 3. Fallback в настройки приложения.
      if (!isGranted) {
        await Geolocator.openAppSettings();
        permission = await Geolocator.checkPermission();
        _applyPermission(permission);
      }

      if (!isGranted) {
        _errorMessage =
            'В настройках приложения выберите «Разрешать всегда» для геолокации.';
      }
      _isRequesting = false;
      notifyListeners();
      return isGranted;
    } catch (_) {
      _errorMessage =
          'Не удалось запросить разрешение. Откройте настройки и выберите «Разрешать всегда» для геолокации.';
      _status = LocationPermissionStatus.denied;
      _isRequesting = false;
      notifyListeners();
      return false;
    }
  }

  /// Открыть настройки приложения (когда выдан deniedForever).
  Future<void> openAppSettings() async {
    _isOpeningSettings = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Geolocator.openAppSettings();
    } catch (_) {
      _errorMessage =
          'Не удалось открыть настройки. Откройте их вручную и выберите «Разрешать всегда» для геолокации.';
    } finally {
      _isOpeningSettings = false;
      notifyListeners();
    }
  }

  void _applyPermission(LocationPermission permission) {
    _status = permission == LocationPermission.always
        ? LocationPermissionStatus.granted
        : LocationPermissionStatus.denied;
  }
}
