import 'package:flutter/foundation.dart';

import '../../../../data/services/local_photo_store.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order_photo.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../../domain/repositories/photo_repository.dart';

/// ViewModel экрана фото заявки.
///
/// Загружает фото из деталей заявки, обеспечивает загрузку и переотправку.
/// Экран фото доступен только для заявок, принятых в работу.
class PhotoViewModel extends ChangeNotifier {
  PhotoViewModel(
    this.orderId,
    this._photoRepo,
    this._ordersRepo,
    this._localPhotoStore,
  );

  final int orderId;
  final PhotoRepository _photoRepo;
  final OrdersRepository _ordersRepo;
  final LocalPhotoStore _localPhotoStore;

  List<OrderPhotoGroup> _groups = const [];
  List<OrderPhotoGroup> get groups => _groups;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> load() async {
    if (_disposed || _isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      final detail = await _ordersRepo.fetchOrderDetail(orderId);
      _groups = detail.photos;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Не удалось загрузить фото.';
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  /// Загрузить фото для группы по типу (камера/галерея).
  Future<bool> uploadForGroup(OrderPhotoGroup group, ImageSourceOption source) async {
    if (_disposed || _isUploading) return false;
    _isUploading = true;
    _errorMessage = null;
    _notify();

    try {
      final filePath = await _photoRepo.pickImage(source);
      if (filePath == null) return false;
      final newId = await _photoRepo.uploadPhotoByType(orderId, group.id, filePath);
      await _localPhotoStore.savePath(newId, filePath);
      await load(); // обновляем список
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Не удалось загрузить фото.';
      return false;
    } finally {
      _isUploading = false;
      _notify();
    }
  }

  /// Возвращает закэшированный локальный путь к фото, если файл ещё существует.
  String? cachedPath(int routePhotoId) =>
      _localPhotoStore.getExistingPath(routePhotoId);

  /// Возвращает сохранённую причину отклонения фото.
  String? rejectionReason(int routePhotoId) =>
      _localPhotoStore.getRejectionReason(routePhotoId);

  /// Переотправить ранее отклонённое фото.
  ///
  /// Если локальный путь сохранён в кэше, использует его; иначе,
  /// при переданном [source], предлагает выбрать новое фото.
  /// Возвращает `true`, если переотправка прошла успешно.
  Future<bool> resend(OrderPhoto photo, {ImageSourceOption? source}) async {
    if (_disposed || _isUploading) return false;
    _isUploading = true;
    _errorMessage = null;
    _notify();

    try {
      String? filePath = _localPhotoStore.getExistingPath(photo.id);
      if (filePath == null && source != null) {
        filePath = await _photoRepo.pickImage(source);
      }
      if (filePath == null) return false;
      await _photoRepo.uploadPhoto(orderId, photo.id, filePath);
      await _localPhotoStore.savePath(photo.id, filePath);
      await load();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage =
          'Не удалось переотправить фото. Проверьте подключение и попробуйте снова.';
      return false;
    } finally {
      _isUploading = false;
      _notify();
    }
  }
}
