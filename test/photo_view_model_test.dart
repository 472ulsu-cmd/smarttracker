import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/local_photo_store.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/models/order_photo.dart';
import 'package:smarttracker/domain/repositories/orders_repository.dart';
import 'package:smarttracker/domain/repositories/photo_repository.dart';
import 'package:smarttracker/ui/features/photos/view_models/photo_view_model.dart';

class _FakeOrdersRepo implements OrdersRepository {
  _FakeOrdersRepo({this.detail});

  final OrderDetail? detail;

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async => const [];

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async => const [];

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async =>
      detail ??
      OrderDetail(
        id: orderId,
        num: 'З-$orderId',
        status: 2,
        route: 'А → Б',
        photos: const [],
      );

  @override
  Future<void> changeStatus(int orderId, int statusId) async {}
}

class _FakePhotoRepo implements PhotoRepository {
  _FakePhotoRepo({
    this.pickedPath,
    this.nextUploadedByTypeId = 1,
  });

  String? pickedPath;
  int nextUploadedByTypeId;

  @override
  Future<int> uploadPhotoByType(
    int orderId,
    int routePhotoTypeId,
    String filePath,
  ) async {
    return nextUploadedByTypeId;
  }

  @override
  Future<String> uploadPhoto(
    int orderId,
    int routePhotoId,
    String filePath,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<String?> pickImage(ImageSourceOption source) async => pickedPath;
}

class _FakeLocalPhotoStore extends LocalPhotoStore {
  final Map<int, String> _paths = {};
  final Map<int, String> _reasons = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> savePath(int routePhotoId, String path) async {
    _paths[routePhotoId] = path;
  }

  @override
  String? getPath(int routePhotoId) => _paths[routePhotoId];

  @override
  String? getExistingPath(int routePhotoId) => _paths[routePhotoId];

  @override
  Future<void> removePath(int routePhotoId) async {
    _paths.remove(routePhotoId);
  }

  @override
  Future<void> saveRejectionReason(int routePhotoId, String reason) async {
    _reasons[routePhotoId] = reason;
  }

  @override
  String? getRejectionReason(int routePhotoId) => _reasons[routePhotoId];
}

OrderDetail _detailWithPhotos(List<OrderPhotoGroup> groups) => OrderDetail(
      id: 42,
      num: 'З-42',
      status: 2,
      route: 'А → Б',
      photos: groups,
    );

void main() {
  group('PhotoViewModel', () {
    test('uploadForGroup кэширует путь загруженного фото и перезагружает список',
        () async {
      const group = OrderPhotoGroup(id: 5, type: 'Погрузка');
      const localPath = '/tmp/photo.jpg';
      final photoRepo = _FakePhotoRepo(
        pickedPath: localPath,
        nextUploadedByTypeId: 100,
      );
      final localStore = _FakeLocalPhotoStore();
      final vm = PhotoViewModel(
        42,
        photoRepo,
        _FakeOrdersRepo(
          detail: _detailWithPhotos([
            const OrderPhotoGroup(
              id: 5,
              type: 'Погрузка',
              photos: [OrderPhoto(id: 100, url: 'http://x/100.jpg')],
            ),
          ]),
        ),
        localStore,
      );

      final ok = await vm.uploadForGroup(group, ImageSourceOption.camera);

      expect(ok, isTrue);
      expect(localStore.getExistingPath(100), localPath);
      expect(vm.groups.single.photos.single.id, 100);
    });

    test('rejectionReason возвращает сохранённое значение', () {
      final localStore = _FakeLocalPhotoStore()
        ..saveRejectionReason(10, 'Размыто');
      final vm = PhotoViewModel(
        42,
        _FakePhotoRepo(),
        _FakeOrdersRepo(),
        localStore,
      );

      expect(vm.rejectionReason(10), 'Размыто');
      expect(vm.rejectionReason(999), isNull);
    });
  });
}
