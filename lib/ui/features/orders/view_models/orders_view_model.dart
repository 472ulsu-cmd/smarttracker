import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';

/// Индекс вкладки списка заявок.
enum OrdersTab { newOrders, inProgress, archive }

/// ViewModel списка заявок с тремя вкладками.
///
/// «Новые»: status == 1.
/// «В работе»: status == 2 || status == 5.
/// «Архив»: всё из /orders/history.
class OrdersViewModel extends ChangeNotifier {
  OrdersViewModel(this._repository);

  final OrdersRepository _repository;

  final Map<OrdersTab, List<OrderListItem>> _orders = {
    OrdersTab.newOrders: const [],
    OrdersTab.inProgress: const [],
    OrdersTab.archive: const [],
  };

  final Map<OrdersTab, bool> _loading = {
    for (final t in OrdersTab.values) t: false,
  };
  final Map<OrdersTab, String?> _errors = {
    for (final t in OrdersTab.values) t: null,
  };

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<OrderListItem> ordersOf(OrdersTab tab) {
    final list = _orders[tab] ?? const [];
    if (_searchQuery.isEmpty) return list;
    return list.where((o) {
      return o.num.toLowerCase().contains(_searchQuery) ||
          o.route.toLowerCase().contains(_searchQuery) ||
          o.routeFrom.toLowerCase().contains(_searchQuery) ||
          o.routeTo.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  bool isLoadingOf(OrdersTab tab) => _loading[tab] ?? false;
  String? errorOf(OrdersTab tab) => _errors[tab];

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  Future<void> loadAll() async {
    await Future.wait([
      _loadActiveTabs(),
      loadTab(OrdersTab.archive),
    ]);
  }

  /// Загружает активные заявки один раз и распределяет по вкладкам Новые/В работе.
  Future<void> _loadActiveTabs() async {
    if (_loading[OrdersTab.newOrders] == true ||
        _loading[OrdersTab.inProgress] == true) {
      return;
    }
    _loading[OrdersTab.newOrders] = true;
    _loading[OrdersTab.inProgress] = true;
    _errors[OrdersTab.newOrders] = null;
    _errors[OrdersTab.inProgress] = null;
    notifyListeners();

    try {
      final all = await _repository.fetchActiveOrders();
      _orders[OrdersTab.newOrders] =
          all.where((o) => o.status == OrderStatus.newRequest.id).toList();
      _orders[OrdersTab.inProgress] = all
          .where((o) =>
              OrderStatus.fromId(o.status)?.isInProgressActive ?? false)
          .toList();
    } on AppException catch (e) {
      _errors[OrdersTab.newOrders] = e.message;
      _errors[OrdersTab.inProgress] = e.message;
    } catch (_) {
      _errors[OrdersTab.newOrders] =
          'Не удалось загрузить заявки. Проверьте соединение и попробуйте снова.';
      _errors[OrdersTab.inProgress] =
          'Не удалось загрузить заявки. Проверьте соединение и попробуйте снова.';
    } finally {
      _loading[OrdersTab.newOrders] = false;
      _loading[OrdersTab.inProgress] = false;
      notifyListeners();
    }
  }

  Future<void> loadTab(OrdersTab tab) async {
    if (_loading[tab] == true) return;
    _loading[tab] = true;
    _errors[tab] = null;
    notifyListeners();

    try {
      if (tab == OrdersTab.archive) {
        _orders[tab] = await _repository.fetchHistoryOrders();
      } else {
        final all = await _repository.fetchActiveOrders();
        _orders[OrdersTab.newOrders] =
            all.where((o) => o.status == OrderStatus.newRequest.id).toList();
        _orders[OrdersTab.inProgress] = all
            .where((o) => OrderStatus.fromId(o.status)?.isInProgressActive ??
                false)
            .toList();
      }
    } on AppException catch (e) {
      _errors[tab] = e.message;
    } catch (_) {
      _errors[tab] =
          'Не удалось загрузить заявки. Проверьте соединение и попробуйте снова.';
    } finally {
      _loading[tab] = false;
      notifyListeners();
    }
  }
}
