/// Источник изображения (камера/галерея).
enum ImageSourceOption { camera, gallery }

/// Пользователь отказал в доступе к камере или галерее.
///
/// Выделено отдельным типом (вне sealed-иерархии AppException), чтобы
/// UI мог предложить переход в системные настройки.
class PhotoAccessDeniedException implements Exception {
  const PhotoAccessDeniedException(this.message);

  /// Понятное пользователю сообщение на русском.
  final String message;

  @override
  String toString() => 'PhotoAccessDeniedException: $message';
}

/// Контракт репозитория фото заявки.
abstract class PhotoRepository {
  /// Загрузить фото по типу (`POST /orders/{id}/photo_type/{typeId}/photo`).
  /// Возвращает id загруженного фото.
  Future<int> uploadPhotoByType(int orderId, int routePhotoTypeId, String filePath);

  /// Загрузить фото по id (`POST /orders/{id}/photo/{routePhotoId}`).
  Future<String> uploadPhoto(int orderId, int routePhotoId, String filePath);

  /// Выбрать изображение (камера/галерея), скопировать в ApplicationDocuments.
  /// Возвращает абсолютный путь к локальному файлу или null при отмене.
  Future<String?> pickImage(ImageSourceOption source);
}
