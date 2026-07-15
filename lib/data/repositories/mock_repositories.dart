import '../../domain/models/geo_point.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_photo.dart';
import '../../domain/models/sync_config.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/sync_repository.dart';

/// Mock-реализация [OrdersRepository] с демонстрационными заявками.
class MockOrdersRepository implements OrdersRepository {
  static final _active = <OrderListItem>[
    const OrderListItem(
        id: 101, num: 'З-1001', status: 1, route: 'Москва → Казань',
        routeFrom: 'Москва', routeTo: 'Казань',
        loadingDate: '2024-06-15', unloadingDate: '2024-06-16',
        client: OrderClient(org: 'ООО Грузоотправитель №1')),
    const OrderListItem(
        id: 102, num: 'З-1002', status: 2, route: 'Санкт-Петербург → Псков',
        routeFrom: 'Санкт-Петербург', routeTo: 'Псков',
        loadingDate: '2024-06-17', unloadingDate: '2024-06-17',
        client: OrderClient(org: 'ООО Грузоотправитель №2')),
    const OrderListItem(
        id: 103, num: 'З-1003', status: 5, route: 'Тула → Рязань',
        routeFrom: 'Тула', routeTo: 'Рязань',
        loadingDate: '2024-06-18', unloadingDate: '2024-06-18',
        client: OrderClient(org: 'ООО Грузоотправитель №3')),
  ];

  static final _history = <OrderListItem>[
    const OrderListItem(
        id: 901, num: 'З-0901', status: 4, route: 'Воронеж → Тамбов',
        loadingDate: '2024-05-20', unloadingDate: '2024-05-21',
        client: OrderClient(org: 'ООО Грузоотправитель №4')),
    const OrderListItem(
        id: 902, num: 'З-0902', status: 3, route: 'Самара → Уфа',
        loadingDate: '2024-05-10', unloadingDate: '2024-05-11',
        client: OrderClient(org: 'ООО Грузоотправитель №5')),
  ];

  int _statusOf101 = 1;

  @override
  Future<List<OrderListItem>> fetchActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _active.map((e) => e.id == 101
        ? OrderListItem(
            id: e.id,
            num: e.num,
            status: _statusOf101,
            route: e.route,
            routeFrom: e.routeFrom,
            routeTo: e.routeTo,
            loadingDate: e.loadingDate,
            unloadingDate: e.unloadingDate,
            isWorking: e.isWorking,
            client: e.client,
          )
        : e).toList();
  }

  @override
  Future<List<OrderListItem>> fetchHistoryOrders() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.of(_history);
  }

  @override
  Future<OrderDetail> fetchOrderDetail(int orderId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final status = orderId == 101 ? _statusOf101 : _active.firstWhere((e) => e.id == orderId,
        orElse: () => _history.firstWhere((e) => e.id == orderId,
            orElse: () => _active.first)).status;
    return OrderDetail(
      id: orderId,
      num: 'З-$orderId',
      status: status,
      route: 'Москва → Казань',
      cargoType: 'Генеральный',
      mass: '20000',
      volume: '80',
      loadingDate: '2024-06-15',
      unloadingDate: '2024-06-16',
      client: const OrderClient(
          org: 'ООО Тест', manager: 'Иванов', phone: '+79990000000'),
      routeDetails: const [
        OrderRouteDetail(
          routeDetailId: 1,
          operationType: 0,
          city: 'Москва',
          address: 'ул. Ленина, 1',
          date: '2024-06-15',
          timeFrom: '08:00',
          timeTo: '12:00',
          loadingMethod: 'Задняя',
          client: OrderClient(
            org: 'ООО Грузоотправитель',
            manager: 'Петров Сергей',
            phone: '+7 (495) 111-22-33',
          ),
        ),
        OrderRouteDetail(
          routeDetailId: 2,
          operationType: 1,
          city: 'Казань',
          address: 'ул. Пушкина, 10',
          date: '2024-06-16',
          timeFrom: '09:00',
          timeTo: '13:00',
          client: OrderClient(
            org: 'ООО Грузополучатель',
            manager: 'Иванова Анна',
            phone: '+7 (843) 222-33-44',
          ),
        ),
      ],
      photos: const [
        OrderPhotoGroup(id: 1, type: 'Погрузка'),
        OrderPhotoGroup(id: 2, type: 'Разгрузка'),
      ],
    );
  }

  @override
  Future<void> changeStatus(int orderId, int statusId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (orderId == 101) _statusOf101 = statusId;
  }
}

/// Mock-реализация [PhotoRepository].
class MockPhotoRepository implements PhotoRepository {
  int _nextId = 500;

  @override
  Future<int> uploadPhotoByType(int orderId, int typeId, String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _nextId++;
  }

  @override
  Future<String> uploadPhoto(int orderId, int routePhotoId, String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'https://mock.local/photo_$routePhotoId.jpg';
  }

  @override
  Future<String?> pickImage(ImageSourceOption source) async => null;
}

/// Mock-реализация [NotificationsRepository].
class MockNotificationsRepository implements NotificationsRepository {
  final _items = <NotificationItem>[
    const NotificationItem(
        id: 1, message: 'Новая заявка З-1001', datetime: '2024-06-15T10:30:00.000',
        isRead: false, orderId: 101),
    const NotificationItem(
        id: 2, message: 'Заявка принята в работу', datetime: '2024-06-15T11:00:00.000',
        isRead: false, orderId: 102),
    const NotificationItem(
        id: 3, message: 'Заявка завершена', datetime: '2024-06-14T18:00:00.000',
        isRead: true, orderId: 901),
  ];

  @override
  Future<List<NotificationItem>> fetchNotifications({int typeId = 2}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.of(_items);
  }

  @override
  Future<void> markAsRead(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) _items[i] = _items[i].copyWith(isRead: true);
  }

  @override
  Future<void> markAllAsRead(Iterable<int> ids) async {
    for (final id in ids) {
      await markAsRead(id);
    }
  }

  @override
  Future<void> sendFcmToken(String token) async {}
}

/// Mock-реализация [ProfileRepository].
class MockProfileRepository implements ProfileRepository {
  User _user = const User(
    id: 1, login: '1234567890', name: 'Иван', secondName: 'Иванович',
    surname: 'Иванов', phone: '9001234567', phoneCode: 1, avatar: '',
  );

  @override
  Future<User> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _user;
  }

  @override
  Future<User> updateProfile({
    String? name, String? secondName, String? surname,
    String? phone, int? phoneCode, String? login,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _user = _user.copyWith(
      login: login,
      name: name, secondName: secondName, surname: surname,
      phone: phone, phoneCode: phoneCode,
    );
    return _user;
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> uploadAvatar(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = _user.copyWith(avatar: 'https://mock.local/avatar.jpg');
  }
}

/// Mock-реализация [SyncRepository].
class MockSyncRepository implements SyncRepository {
  @override
  Future<void> sendCoordinates(List<GeoPoint> points) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<SyncConfig> fetchSyncConfig() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const SyncConfig();
  }
}

/// Mock-реализация [FeedbackRepository].
class MockFeedbackRepository implements FeedbackRepository {
  @override
  Future<void> sendFeedback(String message) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
