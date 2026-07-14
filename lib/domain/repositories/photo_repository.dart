/// Источник изображения (камера/галерея).
enum ImageSourceOption { camera, gallery }

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
