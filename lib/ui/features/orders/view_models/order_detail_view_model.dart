import 'package:flutter/foundation.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';

/// ViewModel деталей заявки.
class OrderDetailViewModel extends ChangeNotifier {
  OrderDetailViewModel(this.orderId, this._repository);

  final int orderId;
  final OrdersRepository _repository;

  OrderDetail? _order;
  OrderDetail? get order => _order;

  /// Последний статус, на который пытались перейти. Используется для retry.
  OrderStatus? _lastAttemptedStatus;
  OrderStatus? get lastAttemptedStatus => _lastAttemptedStatus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionInProgress = false;
  bool get isActionInProgress => _isActionInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _loadErrorMessage;
  String? get loadErrorMessage => _loadErrorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  /// Сбросить сообщение об успехе (экран зовёт после авто-затухания баннера).
  void clearSuccessMessage() {
    if (_successMessage != null) {
      _successMessage = null;
      notifyListeners();
    }
  }

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _loadErrorMessage = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _order = await _repository.fetchOrderDetail(orderId);
    } on AppException catch (e) {
      _loadErrorMessage = e.message;
    } catch (_) {
      _loadErrorMessage =
          'Не удалось загрузить заявку. Проверьте соединение и попробуйте снова.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Доступные действия в зависимости от статуса.
  ///
  /// Отказаться можно только от новой заявки (1).
  /// Завершить можно только заявку, которая погружена (5).
  List<OrderStatus> get availableActions {
    final status = _order?.status;
    switch (OrderStatus.fromId(status)) {
      case OrderStatus.newRequest:
        return const [
          OrderStatus.inProgress, // Принять в работу
          OrderStatus.rejected, // Отказ — только от новой
        ];
      case OrderStatus.inProgress:
        return const [
          OrderStatus.loaded, // Погружен
        ];
      case OrderStatus.loaded:
        return const [
          OrderStatus.completed, // Завершить — только погружённую
        ];
      default:
        return const [];
    }
  }

  /// Сменить статус. Возвращает true при успехе.
  Future<bool> changeStatus(OrderStatus next) async {
    if (_order == null || _isActionInProgress) return false;
    _isActionInProgress = true;
    _errorMessage = null;
    _loadErrorMessage = null;
    _successMessage = null;
    _lastAttemptedStatus = next;
    notifyListeners();

    try {
      await _repository.changeStatus(orderId, next.id);
      _order = await _repository.fetchOrderDetail(orderId);
      _successMessage = _successMessageFor(_order!.status);
      // Триггерим обновление списка заявок.
      getIt<OrdersRefreshBus>().notifyChanged();
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage =
          'Не удалось изменить статус заявки. Проверьте соединение и повторите.';
      notifyListeners();
      return false;
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  /// Повторить последнюю неудавшуюся смену статуса.
  Future<bool> retryLastAction() async {
    final status = _lastAttemptedStatus;
    if (status == null) return false;
    return changeStatus(status);
  }

  String _successMessageFor(int statusId) {
    switch (OrderStatus.fromId(statusId)) {
      case OrderStatus.inProgress:
        return 'Заявка принята в работу';
      case OrderStatus.loaded:
        return 'Погрузка подтверждена';
      case OrderStatus.completed:
        return 'Заявка завершена';
      case OrderStatus.rejected:
        return 'Заявка отклонена';
      default:
        return 'Статус заявки изменён';
    }
  }
}
