import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
    // Сироты (файлы неудачных/забытых аплоадов) чистим best-effort.
    await cleanupOrphans();
  }

  /// Удаляет файлы фото старше [olderThan] из ApplicationDocuments/photos.
  ///
  /// Сироты копятся после сбоев аплоада. Файлы старше порога либо уже на
  /// сервере, либо их действие в офлайн-очереди давно помечено failed —
  /// удаление безопасно. Best-effort: любая ошибка → 0, запуск не ломаем.
  Future<int> cleanupOrphans({
    Duration olderThan = const Duration(days: 30),
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'photos'));
      if (!await photosDir.exists()) return 0;
      final cutoff = DateTime.now().subtract(olderThan);
      var removed = 0;
      await for (final entity in photosDir.list()) {
        if (entity is! File) continue;
        final stat = await entity.stat();
        if (stat.modified.isBefore(cutoff)) {
          await entity.delete();
          removed++;
        }
      }
      return removed;
    } catch (_) {
      return 0;
    }
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
