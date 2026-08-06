import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/local_photo_store.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/domain/repositories/photo_repository.dart';
import 'package:smarttracker/domain/models/order_photo.dart';
import 'package:smarttracker/ui/features/photos/view_models/photo_view_model.dart';
import 'package:smarttracker/ui/features/photos/views/photo_screen.dart';

class _NoopOrdersRepository implements OrdersRepository {
  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async =>
      throw UnimplementedError();

  @override
  Future<void> changeStatus(int orderId, int statusId) async {}
}

class _NoopPhotoRepository implements PhotoRepository {
  @override
  Future<int> uploadPhotoByType(
    int orderId,
    int routePhotoTypeId,
    String filePath,
  ) async => 1;

  @override
  Future<String> uploadPhoto(
    int orderId,
    int routePhotoId,
    String filePath,
  ) async => '';

  @override
  Future<String?> pickImage(ImageSourceOption source) async => null;
}

class _EmptyLocalPhotoStore extends LocalPhotoStore {
  @override
  String? getExistingPath(int routePhotoId) => null;

  @override
  String? getRejectionReason(int routePhotoId) => null;
}

void main() {
  testWidgets('tap on photo thumbnail invokes its open callback', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    var taps = 0;
    final viewModel = PhotoViewModel(
      42,
      _NoopPhotoRepository(),
      _NoopOrdersRepository(),
      _EmptyLocalPhotoStore(),
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhotoThumbnail(
            photo: const OrderPhoto(id: 1, url: ''),
            index: 0,
            total: 1,
            onTap: () => taps++,
            viewModel: viewModel,
          ),
        ),
      ),
    );

    final thumbnail = find.bySemanticsLabel(RegExp(r'Открыть фото 1 из 1'));
    expect(thumbnail, findsOneWidget);

    await tester.tap(thumbnail);
    expect(taps, 1);
    semantics.dispose();
  });
}
