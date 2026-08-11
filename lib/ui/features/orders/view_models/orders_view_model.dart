import 'package:flutter/foundation.dart';

import '../../../../domain/models/app_exception.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/models/order_status.dart';
import '../../../../domain/repositories/orders_repository.dart';

/// Индекс вкладки списка заявок.
enum OrdersTab { newOrders, inProgress, archive }

/// Направление сортировки списка заявок по дате погрузки.
enum OrdersSortMode {
  /// Ближайшая погрузка наверху (ранняя дата по возрастанию).
  loadingSoonest,
  /// Отдалённая погрузка наверху (поздняя дата по убыванию).
  loadingLatest,
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

  OrdersSortMode _sortMode = OrdersSortMode.loadingSoonest;
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
    // Сортировка по дате погрузки. Заявки без даты всегда уходят в конец
    // списка — независимо от направления.
    //   loadingSoonest — по возрастанию: самая ранняя из имеющихся вверху.
    //   loadingLatest  — по убыванию:   самая поздняя из имеющихся вверху.
    final asc = _sortMode == OrdersSortMode.loadingSoonest;
    final sorted = filtered.toList()
      ..sort((a, b) => _compareByLoadingDate(a, b, asc));
    return sorted;
  }

  /// Сравнение заявок по дате погрузки.
  ///
  /// При [asc] = true — по возрастанию (раньше — первыми),
  /// при false — по убыванию (позже — первыми).
  /// Заявки без даты всегда считаются «больше» и уходят в конец списка
  /// независимо от направления; между собой сравниваются как равные.
  int _compareByLoadingDate(OrderListItem a, OrderListItem b, bool asc) {
    final ta = _tryParseDate(a.loadingDate);
    final tb = _tryParseDate(b.loadingDate);
    if (ta == null && tb == null) return 0;
    if (ta == null) return 1; // a без даты → в конец
    if (tb == null) return -1; // b без даты → в конец
    return asc
        ? ta.compareTo(tb) // возрастание: раньше — первыми
        : tb.compareTo(ta); // убывание: позже — первыми
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
