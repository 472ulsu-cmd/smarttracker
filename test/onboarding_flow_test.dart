import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttracker/config/refresh_bus.dart';
import 'package:smarttracker/config/service_locator.dart';
import 'package:smarttracker/data/services/settings_service.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/ui/features/orders/views/order_detail_screen.dart';
import 'package:smarttracker/ui/features/orders/views/order_route_screen.dart';

class _OnboardingOrdersRepository implements OrdersRepository {
  _OnboardingOrdersRepository({int initialStatus = 2})
    : _status = initialStatus;

  int _status;

  @override
  Future<void> changeStatus(int orderId, int statusId) async {
    _status = statusId;
  }

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async => OrderDetail(
    id: orderId,
    num: 'З-$orderId',
    status: _status,
    route: 'Москва → Казань',
    routeDetails: const [
      OrderRouteDetail(
        routeDetailId: 1,
        operationType: 1,
        city: 'Москва',
        address: 'ул. Ленина, 1',
        lat: 55.75,
        lon: 37.62,
      ),
      OrderRouteDetail(
        routeDetailId: 2,
        operationType: 2,
        city: 'Владимир',
        address: 'Промышленный проезд, 8',
      ),
      OrderRouteDetail(
        routeDetailId: 3,
        operationType: 1,
        city: 'Нижний Новгород',
        address: 'Московское шоссе, 52',
      ),
      OrderRouteDetail(
        routeDetailId: 4,
        operationType: 2,
        city: 'Казань',
        address: 'ул. Техническая, 17',
      ),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.init();
    getIt.registerSingleton<SettingsService>(settings);
    getIt.registerSingleton<OrdersRepository>(_OnboardingOrdersRepository());
    getIt.registerSingleton<OrdersRefreshBus>(OrdersRefreshBus());
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('подсказки ведут из заявки в маршрут, карту и фото', (
    tester,
  ) async {
    // Маршрут специально длиннее экрана: ссылка на фото изначально ниже
    // видимой области и должна быть поднята автоматической прокруткой.
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late final GoRouter router;
    router = GoRouter(
      initialLocation: '/main/orders/42',
      routes: [
        GoRoute(
          path: '/main/orders/:id',
          builder: (context, state) => const OrderDetailScreen(orderId: 42),
          routes: [
            GoRoute(
              path: 'route',
              builder: (context, state) => const OrderRouteScreen(orderId: 42),
            ),
            GoRoute(
              path: 'photos',
              builder: (context, state) =>
                  const Scaffold(body: Text('Экран прикрепления фото')),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(
      find.text('Нажмите «Подробнее», чтобы открыть весь маршрут'),
      findsOneWidget,
    );
    expect(
      find.text('Нажмите «Фото по заявке», чтобы добавить снимки'),
      findsNothing,
    );
    expect(find.text('Понятно'), findsOneWidget);
    expect(find.text('Москва → Казань'), findsNothing);
    expect(find.text('Погрузка — Москва'), findsOneWidget);
    expect(find.text('Разгрузка — Казань'), findsOneWidget);
    expect(find.textContaining('Владимир'), findsNothing);
    expect(find.textContaining('Нижний Новгород'), findsNothing);
    // Сводка точек маршрута: 2 погрузки и 2 разгрузки (Владимир и Н.Новгород
    // свёрнуты — состав маршрута виден по счётчикам, а не по скрытым точкам).
    expect(find.text('2 погрузки'), findsOneWidget);
    expect(find.text('2 разгрузки'), findsOneWidget);

    // Целевой контрол остаётся активным внутри spotlight-выреза.
    await tester.tap(find.text('Подробнее'));
    await tester.pumpAndSettle();

    expect(
      find.text('Нажмите «На карте», чтобы открыть точку в навигаторе'),
      findsOneWidget,
    );
    expect(find.text('На карте'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    expect(
      find.text('Нажмите «Фото по заявке», чтобы добавить снимки'),
      findsOneWidget,
    );
    final photoLink = find.widgetWithText(ListTile, 'Фото по заявке');
    final photoRect = tester.getRect(photoLink);
    expect(photoRect.top, greaterThanOrEqualTo(0));
    expect(photoRect.bottom, lessThanOrEqualTo(700));

    // Ручная ensureVisible здесь намеренно не используется.
    await tester.tap(photoLink);
    await tester.pumpAndSettle();
    expect(find.text('Экран прикрепления фото'), findsOneWidget);

    final settings = getIt<SettingsService>();
    expect(
      settings.hasSeenOnboardingHint(OnboardingHint.orderRouteEntry),
      isTrue,
    );
    expect(settings.hasSeenOnboardingHint(OnboardingHint.routeMap), isTrue);
    expect(
      settings.hasSeenOnboardingHint(OnboardingHint.orderPhotoEntry),
      isTrue,
    );
  });

  testWidgets('после принятия заявки экран прокручивается к ссылке на фото', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await getIt.unregister<OrdersRepository>();
    getIt.registerSingleton<OrdersRepository>(
      _OnboardingOrdersRepository(initialStatus: 1),
    );
    await getIt<SettingsService>().markOnboardingHintSeen(
      OnboardingHint.orderRouteEntry,
    );

    await tester.pumpWidget(
      const MaterialApp(home: OrderDetailScreen(orderId: 42)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Принять в работу'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Фото по заявке'), findsOneWidget);
    expect(
      getIt<SettingsService>().hasSeenOnboardingHint(
        OnboardingHint.orderPhotoEntry,
      ),
      isTrue,
    );
    expect(
      find.text('Нажмите «Фото по заявке», чтобы добавить снимки'),
      findsOneWidget,
    );
    final photoLink = find.widgetWithText(ListTile, 'Фото по заявке');
    final photoRect = tester.getRect(photoLink);
    expect(photoRect.top, greaterThanOrEqualTo(0));
    expect(photoRect.bottom, lessThanOrEqualTo(700));
  });
}
