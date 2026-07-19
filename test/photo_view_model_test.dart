import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/local_photo_store.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/order.dart';
import 'package:smarttracker/domain/models/order_photo.dart';
import 'package:smarttracker/domain/models/pending_action.dart';
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
    this.pickError,
    this.uploadByTypeError,
  });

  String? pickedPath;
  int nextUploadedByTypeId;
  Object? pickError;
  Object? uploadByTypeError;
  int uploadByTypeCalls = 0;

  @override
  Future<int> uploadPhotoByType(
    int orderId,
    int routePhotoTypeId,
    String filePath,
  ) async {
    uploadByTypeCalls++;
    final error = uploadByTypeError;
    if (error != null) throw error;
    return nextUploadedByTypeId;
  }

  @override
  Future<String> uploadPhoto(
    int orderId,
    int routePhotoId,
    String filePath,
  ) async =>
      'http://x/$routePhotoId.jpg';

  @override
  Future<String?> pickImage(ImageSourceOption source) async {
    final error = pickError;
    if (error != null) throw error;
    return pickedPath;
  }
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

  group('PhotoViewModel офлайн-очередь и разрешения', () {
    const group = OrderPhotoGroup(id: 5, type: 'Погрузка');

    test('uploadForGroup при сетевом сбое ставит фото в очередь', () async {
      final enqueued = <PendingAction>[];
      final vm = PhotoViewModel(
        42,
        _FakePhotoRepo(
          pickedPath: '/tmp/photo.jpg',
          uploadByTypeError: const NetworkException(),
        ),
        _FakeOrdersRepo(detail: _detailWithPhotos(const [])),
        _FakeLocalPhotoStore(),
        enqueueAction: (action) async => enqueued.add(action),
      );

      final ok = await vm.uploadForGroup(group, ImageSourceOption.camera);

      expect(ok, isFalse);
      expect(vm.queuedOffline, isTrue);
      expect(vm.accessDenied, isFalse);
      expect(vm.errorMessage, contains('отправится автоматически'));
      expect(enqueued, hasLength(1));
      expect(enqueued.single.type, PendingActionType.photoUpload);
      expect(enqueued.single.payload, {
        'orderId': 42,
        'routePhotoTypeId': 5,
        'filePath': '/tmp/photo.jpg',
      });
    });

    test('отказ в доступе к камере выставляет accessDenied без очереди', () async {
      final vm = PhotoViewModel(
        42,
        _FakePhotoRepo(
          pickError: const PhotoAccessDeniedException('Нет доступа к камере.'),
        ),
        _FakeOrdersRepo(),
        _FakeLocalPhotoStore(),
        enqueueAction: (_) async => fail('очередь не должна вызываться'),
      );

      final ok = await vm.uploadForGroup(group, ImageSourceOption.camera);

      expect(ok, isFalse);
      expect(vm.accessDenied, isTrue);
      expect(vm.queuedOffline, isFalse);
      expect(vm.errorMessage, contains('камере'));
    });

    test('retryLastAction повторяет последний неудачный аплоад', () async {
      final photoRepo = _FakePhotoRepo(
        pickedPath: '/tmp/photo.jpg',
        nextUploadedByTypeId: 100,
        uploadByTypeError: const NetworkException(),
      );
      final enqueued = <PendingAction>[];
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
        _FakeLocalPhotoStore(),
        enqueueAction: (action) async => enqueued.add(action),
      );

      expect(await vm.uploadForGroup(group, ImageSourceOption.camera), isFalse);
      expect(enqueued, hasLength(1));

      // «Сеть появилась»: убираем сбой и повторяем тем же действием.
      photoRepo.uploadByTypeError = null;
      final ok = await vm.retryLastAction();

      expect(ok, isTrue);
      expect(vm.groups.single.photos.single.id, 100);
    });
  });
}
