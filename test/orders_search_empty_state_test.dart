import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttracker/config/refresh_bus.dart';
import 'package:smarttracker/config/service_locator.dart';
import 'package:smarttracker/data/services/settings_service.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/ui/features/orders/view_models/orders_view_model.dart';
import 'package:smarttracker/ui/features/orders/views/orders_screen.dart';

class _SearchOrdersRepository implements OrdersRepository {
  @override
  Future<void> changeStatus(int orderId, int statusId) async {}

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [
    OrderListItem(id: 1, num: 'З-1', status: 1, route: 'Москва → Казань'),
  ];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsService();
    await settings.init();
    final repository = _SearchOrdersRepository();
    getIt.registerSingleton<SettingsService>(settings);
    getIt.registerSingleton<OrdersRefreshBus>(OrdersRefreshBus());
    getIt.registerFactory<OrdersViewModel>(() => OrdersViewModel(repository));
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('подсказка свайпа сохраняется только после завершения', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    expect(
      find.text('Смахните карточку: влево — отклонить, вправо — принять'),
      findsOneWidget,
    );
    expect(
      getIt<SettingsService>().hasSeenOnboardingHint(
        OnboardingHint.newOrderSwipe,
      ),
      isFalse,
    );

    await tester.tap(find.text('Понятно'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      find.text('Смахните карточку: влево — отклонить, вправо — принять'),
      findsNothing,
    );
    expect(
      getIt<SettingsService>().hasSeenOnboardingHint(
        OnboardingHint.newOrderSwipe,
      ),
      isTrue,
    );
  });

  testWidgets('пустой поиск можно очистить вместе с текстом поля', (
    tester,
  ) async {
    await getIt<SettingsService>().markOnboardingHintSeen(
      OnboardingHint.newOrderSwipe,
    );
    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'несуществующая заявка');
    await tester.pump();
    expect(find.text('Ничего не найдено'), findsOneWidget);

    await tester.tap(find.text('Очистить поиск'));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(find.text('№ З-1'), findsOneWidget);
  });

  testWidgets('spotlight пропускает реальный свайп по выделенной карточке', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pumpAndSettle();

    await tester.drag(find.text('№ З-1'), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Принять в работу'), findsOneWidget);
    expect(
      find.text('Смахните карточку: влево — отклонить, вправо — принять'),
      findsNothing,
    );
    expect(
      getIt<SettingsService>().hasSeenOnboardingHint(
        OnboardingHint.newOrderSwipe,
      ),
      isTrue,
    );
  });
}
