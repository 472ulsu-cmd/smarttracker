import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

/// Локальный кэш путей загруженных фото заявки и причин отклонения.
/// routePhotoId -> абсолютный путь к файлу / причина отклонения.
class LocalPhotoStore {
  LocalPhotoStore();

  static final LocalPhotoStore instance = LocalPhotoStore();

  SharedPreferences? _prefs;
  static const _pathPrefix = 'local_photo_path_';
  static const _reasonPrefix = 'local_photo_reason_';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> savePath(int routePhotoId, String path) async {
    await _prefs?.setString('$_pathPrefix$routePhotoId', path);
  }

  String? getPath(int routePhotoId) {
    return _prefs?.getString('$_pathPrefix$routePhotoId');
  }

  Future<void> removePath(int routePhotoId) async {
    await _prefs?.remove('$_pathPrefix$routePhotoId');
  }

  /// Возвращает путь, только если файл реально существует.
  String? getExistingPath(int routePhotoId) {
    final path = getPath(routePhotoId);
    if (path == null) return null;
    if (!File(path).existsSync()) {
      removePath(routePhotoId);
      return null;
    }
    return path;
  }

  Future<void> saveRejectionReason(int routePhotoId, String reason) async {
    await _prefs?.setString('$_reasonPrefix$routePhotoId', reason);
  }

  String? getRejectionReason(int routePhotoId) {
    return _prefs?.getString('$_reasonPrefix$routePhotoId');
  }
}
