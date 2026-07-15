import 'package:flutter/foundation.dart';

import '../../../../data/services/local_photo_store.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order_photo.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../../domain/repositories/photo_repository.dart';

/// ViewModel экрана фото заявки.
///
/// Загружает фото из деталей заявки и обеспечивает их загрузку.
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

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final detail = await _ordersRepo.fetchOrderDetail(orderId);
      _groups = detail.photos;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage =
          'Не удалось обновить список фото. Проверьте подключение и попробуйте снова.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загрузить фото для группы по типу (камера/галерея).
  Future<bool> uploadForGroup(OrderPhotoGroup group, ImageSourceOption source) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final filePath = await _photoRepo.pickImage(source);
      if (filePath == null) {
        _isUploading = false;
        notifyListeners();
        return false;
      }
      final newId = await _photoRepo.uploadPhotoByType(orderId, group.id, filePath);
      await _localPhotoStore.savePath(newId, filePath);
      await load(); // обновляем список
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage =
          'Не удалось отправить фото. Проверьте подключение и попробуйте снова.';
      notifyListeners();
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Возвращает сохранённую причину отклонения фото.
  String? rejectionReason(int routePhotoId) =>
      _localPhotoStore.getRejectionReason(routePhotoId);
}
