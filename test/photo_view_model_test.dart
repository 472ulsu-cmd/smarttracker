import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/local_photo_store.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
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
    this.shouldFailUpload = false,
  });

  String? pickedPath;
  int nextUploadedByTypeId;
  bool shouldFailUpload;

  int? lastUploadOrderId;
  int? lastUploadRoutePhotoId;
  String? lastUploadFilePath;
  ImageSourceOption? lastPickSource;

  @override
  Future<int> uploadPhotoByType(
    int orderId,
    int routePhotoTypeId,
    String filePath,
  ) async {
    if (shouldFailUpload) {
      throw const ValidationException(message: 'Ошибка загрузки по типу.');
    }
    return nextUploadedByTypeId;
  }

  @override
  Future<String> uploadPhoto(
    int orderId,
    int routePhotoId,
    String filePath,
  ) async {
    if (shouldFailUpload) {
      throw const ValidationException(message: 'Ошибка переотправки.');
    }
    lastUploadOrderId = orderId;
    lastUploadRoutePhotoId = routePhotoId;
    lastUploadFilePath = filePath;
    return 'http://example.com/$routePhotoId';
  }

  @override
  Future<String?> pickImage(ImageSourceOption source) async {
    lastPickSource = source;
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

    test('cachedPath и rejectionReason возвращают сохранённые значения', () {
      final localStore = _FakeLocalPhotoStore()
        ..savePath(10, '/tmp/10.jpg')
        ..saveRejectionReason(10, 'Размыто');
      final vm = PhotoViewModel(
        42,
        _FakePhotoRepo(),
        _FakeOrdersRepo(),
        localStore,
      );

      expect(vm.cachedPath(10), '/tmp/10.jpg');
      expect(vm.rejectionReason(10), 'Размыто');
      expect(vm.cachedPath(999), isNull);
      expect(vm.rejectionReason(999), isNull);
    });

    test('resend использует закэшированный путь без повторного выбора', () async {
      const photo = OrderPhoto(id: 20, url: 'http://x/20.jpg');
      final localStore = _FakeLocalPhotoStore()
        ..savePath(20, '/cached/20.jpg');
      final photoRepo = _FakePhotoRepo();
      final vm = PhotoViewModel(
        42,
        photoRepo,
        _FakeOrdersRepo(),
        localStore,
      );

      final ok = await vm.resend(photo);

      expect(ok, isTrue);
      expect(photoRepo.lastPickSource, isNull);
      expect(photoRepo.lastUploadOrderId, 42);
      expect(photoRepo.lastUploadRoutePhotoId, 20);
      expect(photoRepo.lastUploadFilePath, '/cached/20.jpg');
      expect(localStore.getExistingPath(20), '/cached/20.jpg');
    });

    test('resend выбирает новое фото, если кэш отсутствует и передан source',
        () async {
      const photo = OrderPhoto(id: 21, url: 'http://x/21.jpg');
      final localStore = _FakeLocalPhotoStore();
      final photoRepo = _FakePhotoRepo(pickedPath: '/new/21.jpg');
      final vm = PhotoViewModel(
        42,
        photoRepo,
        _FakeOrdersRepo(),
        localStore,
      );

      final ok = await vm.resend(
        photo,
        source: ImageSourceOption.gallery,
      );

      expect(ok, isTrue);
      expect(photoRepo.lastPickSource, ImageSourceOption.gallery);
      expect(photoRepo.lastUploadRoutePhotoId, 21);
      expect(localStore.getExistingPath(21), '/new/21.jpg');
    });

    test('resend возвращает false, если нет кэша и source не передан', () async {
      const photo = OrderPhoto(id: 22, url: 'http://x/22.jpg');
      final photoRepo = _FakePhotoRepo();
      final vm = PhotoViewModel(
        42,
        photoRepo,
        _FakeOrdersRepo(),
        _FakeLocalPhotoStore(),
      );

      final ok = await vm.resend(photo);

      expect(ok, isFalse);
      expect(photoRepo.lastUploadRoutePhotoId, isNull);
    });

    test('resend пишет errorMessage при ошибке репозитория', () async {
      const photo = OrderPhoto(id: 23, url: 'http://x/23.jpg');
      final localStore = _FakeLocalPhotoStore()
        ..savePath(23, '/cached/23.jpg');
      final vm = PhotoViewModel(
        42,
        _FakePhotoRepo(shouldFailUpload: true),
        _FakeOrdersRepo(),
        localStore,
      );

      final ok = await vm.resend(photo);

      expect(ok, isFalse);
      expect(vm.errorMessage, 'Ошибка переотправки.');
      expect(vm.isUploading, isFalse);
    });
  });
}
