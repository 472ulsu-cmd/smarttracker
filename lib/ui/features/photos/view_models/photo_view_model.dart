import 'package:flutter/foundation.dart';

import '../../../../data/services/local_photo_store.dart';
import '../../../../data/services/pending_action_store.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order_photo.dart';
import '../../../../domain/models/pending_action.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../../domain/repositories/photo_repository.dart';

/// ViewModel экрана фото заявки.
///
/// Загружает фото из деталей заявки, обеспечивает загрузку новых фото.
/// Экран фото доступен только для заявок, принятых в работу.
///
/// При сетевом сбое аплоада фото не теряется: действие ставится в
/// офлайн-очередь [PendingActionStore] и доотправляется фоновой
/// синхронизацией при появлении сети.
class PhotoViewModel extends ChangeNotifier {
  PhotoViewModel(
    this.orderId,
    this._photoRepo,
    this._ordersRepo,
    this._localPhotoStore, {
    Future<void> Function(PendingAction action)? enqueueAction,
  }) : _enqueueAction =
            enqueueAction ?? PendingActionStore.instance.enqueue;

  final int orderId;
  final PhotoRepository _photoRepo;
  final OrdersRepository _ordersRepo;
  final LocalPhotoStore _localPhotoStore;
  final Future<void> Function(PendingAction action) _enqueueAction;

  List<OrderPhotoGroup> _groups = const [];
  List<OrderPhotoGroup> get groups => _groups;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Последняя ошибка — отказ в доступе к камере/галерее
  /// (UI предлагает переход в настройки).
  bool _accessDenied = false;
  bool get accessDenied => _accessDenied;

  /// Фото поставлено в офлайн-очередь (ошибка носит информационный характер,
  /// повторное действие не требуется).
  bool _queuedOffline = false;
  bool get queuedOffline => _queuedOffline;

  /// Повтор последнего неудачного действия (аплоад).
  Future<bool> Function()? _lastRetry;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _resetErrorFlags() {
    _errorMessage = null;
    _accessDenied = false;
    _queuedOffline = false;
  }

  /// Повторить последнее неудачное действие (или перезагрузить список).
  Future<bool> retryLastAction() {
    final retry = _lastRetry;
    if (retry != null) return retry();
    return load().then((_) => _errorMessage == null);
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
  Future<bool> uploadForGroup(
      OrderPhotoGroup group, ImageSourceOption source) async {
    if (_disposed || _isUploading) return false;
    _isUploading = true;
    _resetErrorFlags();
    _lastRetry = () => uploadForGroup(group, source);
    _notify();

    final filePath = await _pickSafe(source);
    if (filePath == null) {
      _isUploading = false;
      _notify();
      return false;
    }

    try {
      final newId =
          await _photoRepo.uploadPhotoByType(orderId, group.id, filePath);
      await _localPhotoStore.savePath(newId, filePath);
      await load(); // обновляем список
      return true;
    } on NetworkException {
      // Нет сети: файл на месте — ставим в офлайн-очередь.
      await _enqueueAction(PendingAction(
        type: PendingActionType.photoUpload,
        payload: {
          'orderId': orderId,
          'routePhotoTypeId': group.id,
          'filePath': filePath,
        },
      ));
      _queuedOffline = true;
      _errorMessage =
          'Нет соединения. Фото сохранено и отправится автоматически при появлении сети.';
      return false;
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

  /// Выбор изображения с корректной обработкой отказа в разрешении.
  /// Возвращает null при отмене; ошибки пишет в [_errorMessage].
  Future<String?> _pickSafe(ImageSourceOption source) async {
    try {
      return await _photoRepo.pickImage(source);
    } on PhotoAccessDeniedException catch (e) {
      _accessDenied = true;
      _errorMessage = e.message;
      return null;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _errorMessage = 'Не удалось получить изображение.';
      return null;
    }
  }
}
