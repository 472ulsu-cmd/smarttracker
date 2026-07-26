import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:smarttracker/data/repositories/mock_repositories.dart';
import 'package:smarttracker/data/services/sync_config_service.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/app_session.dart';
import 'package:smarttracker/domain/models/user.dart';
import 'package:smarttracker/domain/repositories/auth_repository.dart';
import 'package:smarttracker/domain/repositories/profile_repository.dart';
import 'package:smarttracker/ui/features/auth/view_models/auth_view_model.dart';
import 'package:smarttracker/ui/features/profile/view_models/profile_view_model.dart';

/// Фейковый [ProfileRepository], запоминающий последний сохранённый профиль.
class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._user);

  User _user;
  int updateCalls = 0;
  Object? error;

  @override
  Future<User> fetchProfile() async => _user;

  @override
  Future<User> updateProfile({
    String? login,
    String? name,
    String? secondName,
    String? surname,
    String? phone,
    int? phoneCode,
  }) async {
    updateCalls++;
    final e = error;
    if (e != null) throw e;
    _user = _user.copyWith(
      login: login,
      name: name,
      secondName: secondName,
      surname: surname,
      phone: phone,
      phoneCode: phoneCode,
    );
    return _user;
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {}

  @override
  Future<void> uploadAvatar(String filePath) async {}
}

/// Фейковый [AuthRepository] для тестов SMS-флоу: запоминает отправленные
/// коды и управляет успехом/провалом verifyPhoneCode.
class _FakeAuthRepository implements AuthRepository {
  /// Записи запросов кода: пары (login, phone).
  final List<({String login, String phone})> sentCodes = [];

  /// Какой код считать верным (по умолчанию '1234').
  String validCode = '1234';

  /// Принудительная ошибка при sendPhoneCode (null — успех).
  Object? sendError;

  /// Принудительная ошибка при verifyPhoneCode (null — по логике validCode).
  Object? verifyError;

  @override
  Future<AppSession> login(String login, String password) async =>
      throw UnimplementedError();

  @override
  Future<User> fetchCurrentUser() async =>
      throw UnimplementedError();

  @override
  Future<AppSession?> checkSession() async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> sendPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    final e = sendError;
    if (e != null) throw e;
    sentCodes.add((login: login, phone: phone));
  }

  @override
  Future<void> sendRestoringPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {}

  @override
  Future<void> verifyPhoneCode(
    String login,
    String phone,
    String code, {
    int phoneCodeId = 1,
  }) async {
    final e = verifyError;
    if (e != null) throw e;
    if (code != validCode) {
      throw const ValidationException(message: 'Неверный код подтверждения.');
    }
  }

  @override
  Future<AppSession> registerAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async => throw UnimplementedError();

  @override
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) async => throw UnimplementedError();
}

void main() {
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    // ProfileViewModel дёргает getIt<AuthViewModel>() (синхронизация сессии)
    // и getIt<AuthRepository>() (SMS-флоу) — регистрируем как в
    // setupDependencies(). AuthRepository заменяем фейком в тестах SMS.
    getIt.registerSingleton<AuthViewModel>(
      AuthViewModel(
        _FakeAuthRepository(),
        MockSyncRepository(),
        SyncConfigService(),
      ),
    );
  });

  tearDown(() async => getIt.reset());

  group('ProfileViewModel.updateProfile — смена телефона', () {
    test('сохраняет новый телефон с phoneCode=1 и возвращает true', () async {
      final repo = _FakeProfileRepository(const User(
        id: 5,
        login: '5809445566',
        name: 'Тест',
        secondName: 'Тестович',
        surname: 'Тестов',
        phone: '9001234567',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);

      final ok = await vm.updateProfile(
        login: '5809445566',
        name: 'Тест',
        secondName: 'Тестович',
        surname: 'Тестов',
        phone: '9123456789',
        phoneCode: 1,
      );

      expect(ok, isTrue);
      // VM держит обновлённый профиль после сохранения.
      expect(vm.user!.phone, '9123456789');
      expect(vm.user!.phoneCode, 1);
      // Репозиторий получил запрос ровно с новым телефоном.
      expect(repo.updateCalls, 1);
      expect(repo._user.phone, '9123456789');
      expect(vm.errorMessage, isNull);
    });

    test('синхронизирует свежего пользователя с глобальной сессией', () async {
      // Суть бага: профиль обновлялся в одном экземпляре VM, а экран профиля
      // читал другой. Теперь VM — singleton, и после updateProfile() общий
      // _user доступен всем слушателям. Проверяем, что updateUser() позвал
      // AuthViewModel (через getIt), иначе экран профиля не перерисуется.
      final auth = getIt<AuthViewModel>();
      final repo = _FakeProfileRepository(const User(
        id: 5,
        login: '5809445566',
        phone: '9001234567',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);

      await vm.updateProfile(
        login: '5809445566',
        name: '',
        secondName: '',
        surname: '',
        phone: '9990001122',
        phoneCode: 1,
      );

      expect(auth.user, isNotNull);
      expect(auth.user!.phone, '9990001122');
      expect(auth.user!.phoneCode, 1);
    });

    test('при сетевой ошибке возвращает false и не затирает телефон', () async {
      final repo = _FakeProfileRepository(const User(
        id: 5,
        login: '5809445566',
        phone: '9001234567',
        phoneCode: 1,
      ));
      repo.error = const NetworkException();
      final vm = ProfileViewModel(repo);
      // Профиль должен быть загружен до попытки сохранения — иначе при ошибке
      // VM нечего показать на экране.
      await vm.load();

      final ok = await vm.updateProfile(
        login: '5809445566',
        name: 'Тест',
        secondName: 'Тестович',
        surname: 'Тестов',
        phone: '9123456789',
        phoneCode: 1,
      );

      expect(ok, isFalse);
      // Старый телефон не затёрт.
      expect(vm.user!.phone, '9001234567');
      expect(repo._user.phone, '9001234567');
      expect(vm.errorMessage, isNotNull);
    });

    test('формат телефона отображается как +7 (XXX) XXX-XX-XX', () async {
      // Экран профиля показывает user.formattedPhone — проверяем, что новый
      // 10-значный телефон форматируется корректно (то, что увидит водитель).
      final repo = _FakeProfileRepository(const User(
        id: 5,
        login: '5809445566',
        phone: '9001234567',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);

      await vm.updateProfile(
        login: '5809445566',
        name: '',
        secondName: '',
        surname: '',
        phone: '9123456789',
        phoneCode: 1,
      );

      expect(vm.user!.formattedPhone, '+7 (912) 345-67-89');
    });
  });

  group('ProfileViewModel — смена телефона с подтверждением по SMS', () {
    // Один общий фейк AuthRepository: его использует и ProfileViewModel
    // (через getIt<AuthRepository>()), и мы — для ассертов.
    late _FakeAuthRepository auth;

    setUp(() {
      auth = _FakeAuthRepository();
      getIt.registerSingleton<AuthRepository>(auth);
    });

    test('requestPhoneCode отправляет код на новый телефон и стартует кулдаун',
        () async {
      final repo = _FakeProfileRepository(const User(
        id: 8,
        login: '5809445566',
        phone: '9056384158',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);
      await vm.load();

      final ok = await vm.requestPhoneCode('9001112233');

      expect(ok, isTrue);
      expect(auth.sentCodes.single.login, '5809445566');
      expect(auth.sentCodes.single.phone, '9001112233');
      expect(vm.pendingPhone, '9001112233');
      // Кулдаун запущен — повторная отправка заблокирована сразу после запроса.
      expect(vm.resendRemaining, ProfileViewModel.resendCooldownSeconds);
      expect(vm.canResend, isFalse);
    });

    test('confirmPhoneAndSave с верным кодом проверяет его и сохраняет профиль',
        () async {
      auth.validCode = '4444';
      final repo = _FakeProfileRepository(const User(
        id: 8,
        login: '5809445566',
        name: 'Семен',
        surname: 'Семенов',
        secondName: 'Семенович',
        phone: '9056384158',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);
      await vm.load();

      final ok = await vm.confirmPhoneAndSave(
        code: '4444',
        newPhone: '9001112233',
        login: '5809445566',
        name: 'Семен',
        secondName: 'Семенович',
        surname: 'Семенов',
      );

      expect(ok, isTrue);
      // Телефон обновлён и проброшен в глобальную сессию.
      expect(vm.user!.phone, '9001112233');
      expect(getIt<AuthViewModel>().user!.phone, '9001112233');
      // Профиль сохранён ровно с новым телефоном.
      expect(repo.updateCalls, 1);
      expect(repo._user.phone, '9001112233');
      expect(vm.pendingPhone, isNull);
      expect(vm.errorMessage, isNull);
    });

    test('confirmPhoneAndSave с неверным кодом не сохраняет профиль (-12)',
        () async {
      final repo = _FakeProfileRepository(const User(
        id: 8,
        login: '5809445566',
        phone: '9056384158',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);
      await vm.load();

      final ok = await vm.confirmPhoneAndSave(
        code: '0000', // неверный (validCode по умолчанию '1234')
        newPhone: '9001112233',
        login: '5809445566',
        name: 'Семен',
        secondName: 'Семенович',
        surname: 'Семенов',
      );

      expect(ok, isFalse);
      // Профиль не сохранён, телефон прежний.
      expect(repo.updateCalls, 0);
      expect(vm.user!.phone, '9056384158');
      expect(vm.errorMessage, 'Неверный код подтверждения.');
    });

    test('resendPhoneCode блокируется кулдауном сразу после запроса', () async {
      final repo = _FakeProfileRepository(const User(
        id: 8,
        login: '5809445566',
        phone: '9056384158',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);
      await vm.load();

      await vm.requestPhoneCode('9001112233');
      // Кулдаун активен — повторная отправка должна отклониться.
      final ok = await vm.resendPhoneCode();

      expect(ok, isFalse);
      expect(auth.sentCodes, hasLength(1));
    });

    test('resetPhoneConfirmation чистит ожидающий номер и ошибку', () async {
      final repo = _FakeProfileRepository(const User(
        id: 8,
        login: '5809445566',
        phone: '9056384158',
        phoneCode: 1,
      ));
      final vm = ProfileViewModel(repo);
      await vm.load();

      await vm.requestPhoneCode('9001112233');
      // Симулируем неверный код → ошибка и pendingPhone.
      await vm.confirmPhoneAndSave(
        code: '0000',
        newPhone: '9001112233',
        login: '5809445566',
        name: '',
        secondName: '',
        surname: '',
      );
      expect(vm.errorMessage, isNotNull);

      vm.resetPhoneConfirmation();

      expect(vm.pendingPhone, isNull);
      expect(vm.errorMessage, isNull);
      expect(vm.resendRemaining, 0);
    });
  });
}
