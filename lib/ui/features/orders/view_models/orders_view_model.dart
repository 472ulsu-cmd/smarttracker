import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';

/// Индекс вкладки списка заявок.
enum OrdersTab { newOrders, inProgress, archive }

/// Область поиска по списку заявок.
enum OrdersSearchScope { number, route, customer }

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

  OrdersSearchScope _searchScope = OrdersSearchScope.number;
  OrdersSearchScope get searchScope => _searchScope;

  List<OrderListItem> ordersOf(OrdersTab tab) {
    final list = _orders[tab] ?? const [];
    if (_searchQuery.isEmpty) return list;
    return list.where((o) {
      switch (_searchScope) {
        case OrdersSearchScope.number:
          return o.num.toLowerCase().contains(_searchQuery);
        case OrdersSearchScope.route:
          return o.route.toLowerCase().contains(_searchQuery) ||
              o.routeFrom.toLowerCase().contains(_searchQuery) ||
              o.routeTo.toLowerCase().contains(_searchQuery);
        case OrdersSearchScope.customer:
          return o.client.org.toLowerCase().contains(_searchQuery);
      }
    }).toList();
  }

  bool isLoadingOf(OrdersTab tab) => _loading[tab] ?? false;
  String? errorOf(OrdersTab tab) => _errors[tab];

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setSearchScope(OrdersSearchScope scope) {
    if (_searchScope == scope) return;
    _searchScope = scope;
    notifyListeners();
  }

  Future<void> loadAll() async {
    await Future.wait([
      _loadActiveTabs(),
      loadTab(OrdersTab.archive),
    ]);
  }

  /// Загружает активные заявки один раз и распределяет по вкладкам Новые/В работе.
  Future<void> _loadActiveTabs() =>
      _loadTabs(const [OrdersTab.newOrders, OrdersTab.inProgress]);

  Future<void> loadTab(OrdersTab tab) => _loadTabs([tab]);

  /// Общая загрузка вкладок: выставляет loading/ошибки и обновляет списки.
  ///
  /// Для любой не-архивной вкладки активные заявки запрашиваются один раз
  /// и раскладываются по «Новым» и «В работе».
  Future<void> _loadTabs(List<OrdersTab> tabs) async {
    if (tabs.any((tab) => _loading[tab] == true)) return;
    for (final tab in tabs) {
      _loading[tab] = true;
      _errors[tab] = null;
    }
    notifyListeners();

    try {
      if (tabs.length == 1 && tabs.first == OrdersTab.archive) {
        _orders[OrdersTab.archive] = await _repository.fetchHistoryOrders();
      } else {
        final all = await _repository.fetchActiveOrders();
        _orders[OrdersTab.newOrders] =
            all.where((o) => o.status == OrderStatus.newRequest.id).toList();
        _orders[OrdersTab.inProgress] = all
            .where((o) =>
                OrderStatus.fromId(o.status)?.isInProgressActive ?? false)
            .toList();
      }
    } on AppException catch (e) {
      for (final tab in tabs) {
        _errors[tab] = e.message;
      }
    } catch (_) {
      for (final tab in tabs) {
        _errors[tab] =
            'Не удалось загрузить заявки. Проверьте соединение и попробуйте снова.';
      }
    } finally {
      for (final tab in tabs) {
        _loading[tab] = false;
      }
      notifyListeners();
    }
  }
}
