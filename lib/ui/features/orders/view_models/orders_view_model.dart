import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';

/// Индекс вкладки списка заявок.
enum OrdersTab { newOrders, inProgress, archive }

/// Направление сортировки списка заявок.
enum OrdersSortMode {
  /// Сначала новые (по дате погрузки по убыванию).
  newestFirst,
  /// Сначала старые (по дате погрузки по возрастанию).
  oldestFirst,
}

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

  OrdersSortMode _sortMode = OrdersSortMode.newestFirst;
  OrdersSortMode get sortMode => _sortMode;

  List<OrderListItem> ordersOf(OrdersTab tab) {
    final list = _orders[tab] ?? const [];
    // Поиск по частичному совпадению сразу по всем полям: номеру, маршруту
    // (включая точки from/to) и заказчику.
    final filtered = _searchQuery.isEmpty
        ? list
        : list.where((o) {
            final hay = <String>[
              o.num,
              o.route,
              o.routeFrom,
              o.routeTo,
              o.client.org,
            ].join(' ').toLowerCase();
            return hay.contains(_searchQuery);
          });
    // Сортировка по дате погрузки. Заявки без даты уходят в конец списка.
    final sorted = filtered.toList()
      ..sort((a, b) {
        final cmp = _compareByLoadingDate(a, b);
        return _sortMode == OrdersSortMode.newestFirst
            ? -cmp // новые (позже) — первыми
            : cmp; // старые (раньше) — первыми
      });
    return sorted;
  }

  /// Сравнение заявок по дате погрузки для сортировки.
  /// Возвращает отрицательное/0/положительное как [DateTime.compare].
  /// Заявки без даты считаются «самыми старыми» — уходят в конец при
  /// возрастающей сортировке.
  int _compareByLoadingDate(OrderListItem a, OrderListItem b) {
    final ta = _tryParseDate(a.loadingDate);
    final tb = _tryParseDate(b.loadingDate);
    if (ta == null && tb == null) return 0;
    if (ta == null) return 1;
    if (tb == null) return -1;
    return ta.compareTo(tb);
  }

  DateTime? _tryParseDate(String input) {
    if (input.isEmpty) return null;
    try {
      // Нормализуем "YYYY-MM-DD HH:MM:SS" под DateTime.parse.
      final iso = input.length >= 11 && input[10] == ' '
          ? '${input.substring(0, 10)}T${input.substring(11)}'
          : input;
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }

  bool isLoadingOf(OrdersTab tab) => _loading[tab] ?? false;
  String? errorOf(OrdersTab tab) => _errors[tab];

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setSortMode(OrdersSortMode mode) {
    if (_sortMode == mode) return;
    _sortMode = mode;
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
