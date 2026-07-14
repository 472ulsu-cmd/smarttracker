import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/mappers/order_mapper.dart';
import 'package:smarttracker/data/models/orders_response.dart' as api;
import 'package:smarttracker/domain/models/order_status.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/ui/features/orders/view_models/orders_view_model.dart';

class _FakeOrdersRepo implements OrdersRepository {
  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [
        OrderListItem(
            id: 1, num: 'З-1', status: 1, route: 'А → Б'),
        OrderListItem(
            id: 2, num: 'З-2', status: 2, route: 'В → Г'),
        OrderListItem(
            id: 3, num: 'З-3', status: 5, route: 'Д → Е'),
      ];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [
        OrderListItem(
            id: 9, num: 'З-9', status: 4, route: 'Ж → З'),
      ];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async => OrderDetail(
        id: orderId,
        num: 'З-$orderId',
        status: 2,
        route: 'А → Б',
        cargoType: 'Генеральный',
      );

  @override
  Future<void> changeStatus(int orderId, int statusId) async {}
}

void main() {
  group('OrderMapper', () {
    test('toItem корректно маппит список', () {
      final item = OrderMapper.toItem(const api.OrdersResponseItem(
        id: 5,
        num: 'З-5',
        status: 3,
        route: 'X → Y',
        isWorking: 1,
      ));
      expect(item.id, 5);
      expect(item.isWorking, isTrue);
      expect(item.statusLabel, 'Отказ');
    });

    test('toDetail маппит детали с координатами и фото', () {
      final detail = OrderMapper.toDetail(const api.OrdersResponse(
        id: 7,
        num: 'З-7',
        status: 2,
        latStart: 55.75,
        lngStart: 37.62,
        client: api.OrdersResponseClient(org: 'ООО Ромашка'),
        photo: [
          api.OrdersResponseOrderPhoto(
            id: 1,
            type: 'Погрузка',
            routePhoto: [
              api.OrdersResponseOrderRoutePhoto(id: 10, url: 'http://x/1.jpg', status: 1),
            ],
          ),
        ],
      ));
      expect(detail.latStart, 55.75);
      expect(detail.client.org, 'ООО Ромашка');
      expect(detail.photos.single.type, 'Погрузка');
      expect(detail.photos.single.photos.single.id, 10);
    });
  });

  group('OrderStatus', () {
    test('listLabelForId скрывает «Новая заявка»', () {
      expect(OrderStatus.listLabelForId(1), isNull);
      expect(OrderStatus.listLabelForId(2), 'В работе');
      expect(OrderStatus.listLabelForId(999), 'Неизвестный статус');
    });

    test('isInProgressActive покрывает 2 и 5', () {
      expect(OrderStatus.inProgress.isInProgressActive, isTrue);
      expect(OrderStatus.loaded.isInProgressActive, isTrue);
      expect(OrderStatus.completed.isInProgressActive, isFalse);
    });
  });

  group('OrdersViewModel вкладки', () {
    test('loadAll распределяет заявки по вкладкам', () async {
      final vm = OrdersViewModel(_FakeOrdersRepo());
      await vm.loadAll();

      // Новые (status 1)
      expect(vm.ordersOf(OrdersTab.newOrders).single.num, 'З-1');
      // В работе (status 2 и 5)
      expect(vm.ordersOf(OrdersTab.inProgress).map((e) => e.num),
          ['З-2', 'З-3']);
      // Архив
      expect(vm.ordersOf(OrdersTab.archive).single.num, 'З-9');
    });
  });
}
