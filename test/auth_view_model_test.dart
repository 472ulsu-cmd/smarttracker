import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/data/services/sync_config_service.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/app_session.dart';
import 'package:smarttracker/domain/models/geo_point.dart';
import 'package:smarttracker/domain/models/sync_config.dart';
import 'package:smarttracker/domain/models/user.dart';
import 'package:smarttracker/domain/repositories/auth_repository.dart';
import 'package:smarttracker/domain/repositories/sync_repository.dart';
import 'package:smarttracker/ui/features/auth/view_models/auth_view_model.dart';

/// Тестовый mock [AuthRepository] с управляемым поведением.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.shouldFailLogin = false,
    this.sessionOnCheck,
  });

  final bool shouldFailLogin;
  final AppSession? sessionOnCheck;

  static const _demoUser = User(
    id: 7,
    login: '1234567890',
    name: 'Тест',
    secondName: 'Тестович',
    surname: 'Тестов',
    phone: '9001234567',
    phoneCode: 1,
  );

  @override
  Future<AppSession> login(String login, String password) async {
    await Future.delayed(const Duration(milliseconds: 5));
    if (shouldFailLogin) {
      throw const ValidationException(message: 'Неверный паспорт или пароль.');
    }
    return const AppSession(token: 'tok', user: _demoUser);
  }

  @override
  Future<User> fetchCurrentUser() async => _demoUser;

  @override
  Future<AppSession?> checkSession() async => sessionOnCheck;

  @override
  Future<void> logout() async {}

  @override
  Future<void> sendPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {}

  @override
  Future<void> sendRestoringPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {}

  @override
  Future<void> verifyPhoneCode(
    String login,
    String phone,
    String code, {
    int phoneCodeId = 1,
  }) async {}

  @override
  Future<AppSession> registerAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async =>
      this.login(login, password);

  @override
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async =>
      this.login(login, password);
}

class _FakeSyncRepository implements SyncRepository {
  @override
  Future<void> sendCoordinates(List<GeoPoint> points) async {}

  @override
  Future<SyncConfig> fetchSyncConfig() async =>
      const SyncConfig(coordinatesPeriodSec: 60, syncPeriodSec: 900);
}

class _FakeSyncConfigService implements SyncConfigService {
  SyncConfig? lastSaved;

  @override
  Future<void> init() async {}

  @override
  Future<void> save(SyncConfig config) async {
    lastSaved = config;
  }

  @override
  SyncConfig load() => lastSaved ?? const SyncConfig();
}

AuthViewModel _createViewModel(_FakeAuthRepository repo) =>
    AuthViewModel(repo, _FakeSyncRepository(), _FakeSyncConfigService());

void main() {
  group('User domain model', () {
    test('fullName объединяет ФИО без лишних пробелов', () {
      const user = User(
        id: 1,
        login: '1',
        name: ' Иван ',
        secondName: 'Иванович',
        surname: 'Иванов',
      );
      expect(user.fullName, 'Иванов Иван Иванович');
    });

    test('initials берёт первые буквы фамилии и имени', () {
      const user = User(
        id: 1,
        login: '1',
        name: 'Антон',
        surname: 'Собянин',
      );
      expect(user.initials, 'СА');
    });

    test('formattedPhone форматирует 10 цифр в +7 (XXX) XXX-XX-XX', () {
      const user = User(id: 1, login: '1', phone: '9001234567');
      expect(user.formattedPhone, '+7 (900) 123-45-67');
    });
  });

  group('AuthViewModel', () {
    test('успешный вход переводит статус в authenticated и хранит user', () async {
      final vm = _createViewModel(_FakeAuthRepository());
      expect(vm.status, AuthStatus.initial);

      final ok = await vm.login('1234567890', '123456');

      expect(ok, isTrue);
      expect(vm.status, AuthStatus.authenticated);
      expect(vm.user, isNotNull);
      expect(vm.user!.login, '1234567890');
      expect(vm.errorMessage, isNull);
    });

    test('ошибка входа оставляет unauthenticated и пишет errorMessage', () async {
      final vm = _createViewModel(_FakeAuthRepository(shouldFailLogin: true));

      final ok = await vm.login('wrong', 'wrong');

      expect(ok, isFalse);
      expect(vm.isAuthenticated, isFalse);
      expect(vm.errorMessage, 'Неверный паспорт или пароль.');
    });

    test('checkSession без сохранённой сессии → unauthenticated', () async {
      final vm = _createViewModel(_FakeAuthRepository(sessionOnCheck: null));

      await vm.checkSession();

      expect(vm.status, AuthStatus.unauthenticated);
      expect(vm.user, isNull);
    });

    test('checkSession с валидной сессией → authenticated', () async {
      const session = AppSession(
        token: 't',
        user: User(id: 1, login: 'L'),
      );
      final vm = _createViewModel(_FakeAuthRepository(sessionOnCheck: session));

      await vm.checkSession();

      expect(vm.status, AuthStatus.authenticated);
      expect(vm.user?.login, 'L');
    });

    test('clearError сбрасывает сообщение', () async {
      final vm = _createViewModel(_FakeAuthRepository(shouldFailLogin: true));
      await vm.login('x', 'y');
      expect(vm.errorMessage, isNotNull);

      vm.clearError();

      expect(vm.errorMessage, isNull);
    });
  });
}
