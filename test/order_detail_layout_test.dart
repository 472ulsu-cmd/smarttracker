import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttracker/config/refresh_bus.dart';
import 'package:smarttracker/config/service_locator.dart';
import 'package:smarttracker/data/services/settings_service.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/ui/features/orders/views/order_detail_screen.dart';

class _OrderDetailRepository implements OrdersRepository {
  _OrderDetailRepository(this.detail);

  final OrderDetail detail;

  @override
  Future<void> changeStatus(int orderId, int statusId) async {}

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async => detail;
}

const _completeDetail = OrderDetail(
  id: 42,
  num: 'З-42',
  status: 2,
  route: 'Москва → Казань',
  cargoType: 'Промышленное оборудование',
  mass: '12',
  volume: '24',
  routeDetails: [
    OrderRouteDetail(routeDetailId: 1, operationType: 1, city: 'Москва'),
    OrderRouteDetail(routeDetailId: 2, operationType: 2, city: 'Казань'),
  ],
  client: OrderClient(
    org: 'ООО «Транспортные системы»',
    manager: 'Иван Петров',
    phone: '+7 900 000-00-00',
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> registerDependencies(OrderDetail detail) async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.init();
    await settings.markOnboardingHintSeen(OnboardingHint.orderRouteEntry);
    await settings.markOnboardingHintSeen(OnboardingHint.orderPhotoEntry);
    getIt.registerSingleton<SettingsService>(settings);
    getIt.registerSingleton<OrdersRepository>(_OrderDetailRepository(detail));
    getIt.registerSingleton<OrdersRefreshBus>(OrdersRefreshBus());
  }

  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('груз, маршрут и контакты логиста — отдельные плитки по порядку', (
    tester,
  ) async {
    await registerDependencies(_completeDetail);
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: OrderDetailScreen(orderId: 42)),
    );
    await tester.pumpAndSettle();

    final status = tester.getTopLeft(
      find.byKey(const ValueKey('order-detail-status')),
    );
    final cargo = tester.getTopLeft(
      find.byKey(const ValueKey('order-detail-cargo')),
    );
    final route = tester.getTopLeft(find.text('Маршрут'));
    final client = tester
        .getTopLeft(find.byKey(const ValueKey('order-detail-client')))
        .dy;

    expect(status.dx, greaterThan(cargo.dx));
    expect((status.dy - cargo.dy).abs(), lessThan(12));
    // Плитки идут по порядку: груз → маршрут → контакты логиста.
    expect(cargo.dy, lessThan(route.dy));
    expect(route.dy, lessThan(client));
    // Бывший раздел «Заказчик» переименован.
    expect(find.text('Контакты логиста'), findsOneWidget);
    expect(find.text('Заказчик'), findsNothing);
    expect(find.text('Москва → Казань'), findsNothing);

    // Сводка погрузок/разгрузок центрирована относительно ширины экрана.
    // Границы рана: слева крайний элемент — иконка первого маркера
    // (Icons.circle 8px, первые два в дереве — маркеры сводки, ниже
    // идут 12px-маркеры точек), справа — текст второго счётчика.
    final dots = find.byIcon(Icons.circle);
    final summaryLeft = tester.getTopLeft(dots.at(0)).dx;
    final summaryRight = tester
        .getTopRight(find.text('1 разгрузка'))
        .dx;
    final summaryCenter = (summaryLeft + summaryRight) / 2;
    expect((summaryCenter - 390 / 2).abs(), lessThan(1));
  });

  testWidgets('длинные сведения не вызывают переполнение на узком экране', (
    tester,
  ) async {
    await registerDependencies(
      const OrderDetail(
        id: 42,
        num: 'З-42',
        status: 2,
        route:
            'Екатеринбург, улица Промышленная, 125 → Набережные Челны, Производственный проезд, 48',
        cargoType:
            'Комплект промышленного оборудования в усиленной транспортной упаковке',
        mass: '12345,67',
        volume: '98765,43',
        client: OrderClient(
          org:
              'Общество с ограниченной ответственностью «Межрегиональные транспортные технологии»',
          manager: 'Александр Константинопольский',
          phone: '+7 900 000-00-00',
        ),
      ),
    );
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: OrderDetailScreen(orderId: 42)),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('пустые разделы не оставляют пустые блоки', (tester) async {
    await registerDependencies(
      const OrderDetail(id: 42, num: 'З-42', status: 2, route: ''),
    );

    await tester.pumpWidget(
      const MaterialApp(home: OrderDetailScreen(orderId: 42)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('order-detail-status')), findsOneWidget);
    expect(find.byKey(const ValueKey('order-detail-cargo')), findsNothing);
    expect(find.byKey(const ValueKey('order-detail-client')), findsNothing);
  });
}
