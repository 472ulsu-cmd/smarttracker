import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/ui/core/widgets/swipeable_order_tile.dart';

const _newOrder = OrderListItem(
  id: 1,
  num: 'З-1',
  status: 1,
  route: 'Москва → Казань',
);

Widget _app(Widget child, {bool disableAnimations = false}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(
        body: Center(child: SizedBox(width: 360, child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets('preview свайпа не меняет статус заявки', (tester) async {
    var accepted = 0;
    var rejected = 0;

    await tester.pumpWidget(
      _app(
        SwipeableOrderTile(
          order: _newOrder,
          previewSwipe: true,
          onAccept: () => accepted++,
          onReject: () => rejected++,
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 200));
    final preview = tester.widget<Transform>(
      find.byKey(const ValueKey('swipe-preview-1')),
    );
    expect(preview.transform.getTranslation().x, isNot(0));
    await tester.pump(const Duration(milliseconds: 1900));

    expect(accepted, 0);
    expect(rejected, 0);
  });

  testWidgets('Reduce Motion оставляет карточку без preview-анимации', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SwipeableOrderTile(order: _newOrder, previewSwipe: true),
        disableAnimations: true,
      ),
    );

    await tester.pump(const Duration(seconds: 3));

    final preview = tester.widget<Transform>(
      find.byKey(const ValueKey('swipe-preview-1')),
    );
    expect(preview.transform.getTranslation().x, 0);
  });

  testWidgets('свайпы открывают правильное подтверждение', (tester) async {
    await tester.pumpWidget(
      _app(
        SwipeableOrderTile(order: _newOrder, onAccept: () {}, onReject: () {}),
      ),
    );

    await tester.drag(find.byType(SwipeableOrderTile), const Offset(260, 0));
    await tester.pumpAndSettle();
    expect(find.text('Принять в работу'), findsOneWidget);

    await tester.tap(find.byTooltip('Закрыть'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(SwipeableOrderTile), const Offset(-260, 0));
    await tester.pumpAndSettle();
    expect(find.text('Отказаться от заявки'), findsOneWidget);
  });
}
