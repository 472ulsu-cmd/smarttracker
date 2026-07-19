import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/domain/models/app_exception.dart';
import 'package:smarttracker/domain/models/app_session.dart';
import 'package:smarttracker/domain/models/user.dart';
import 'package:smarttracker/domain/repositories/auth_repository.dart';
import 'package:smarttracker/ui/features/auth/view_models/auth_stepper_view_model.dart';

/// Фейковый [AuthRepository] со счётчиком отправок SMS и режимом сбоя.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.shouldFailSend = false});

  final bool shouldFailSend;
  int sendCodeCalls = 0;

  static const _demoUser = User(
    id: 7,
    login: '1234567890',
    name: 'Тест',
    surname: 'Тестов',
  );

  @override
  Future<AppSession> login(String login, String password) async =>
      const AppSession(token: 'tok', user: _demoUser);

  @override
  Future<User> fetchCurrentUser() async => _demoUser;

  @override
  Future<AppSession?> checkSession() async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<void> sendPhoneCode(String login, String phone,
      {int phoneCodeId = 1}) async {
    sendCodeCalls++;
    if (shouldFailSend) {
      throw const ServerException(message: 'Сервер недоступен');
    }
  }

  @override
  Future<void> sendRestoringPhoneCode(String login, String phone,
          {int phoneCodeId = 1}) =>
      sendPhoneCode(login, phone, phoneCodeId: phoneCodeId);

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
  }) =>
      this.login(login, password);

  @override
  Future<AppSession> recoverAndLogin({
    required String login,
    required String password,
    required String phone,
    int phoneCodeId = 1,
  }) =>
      this.login(login, password);
}

void main() {
  group('AuthStepperViewModel.back', () {
    test('идёт по шагам назад и не выходит за пределы passport', () {
      final vm =
          AuthStepperViewModel(_FakeAuthRepository(), AuthFlowMode.registration);
      expect(vm.step, AuthStep.passport);

      vm.back(); // уже на первом шаге — остаёмся
      expect(vm.step, AuthStep.passport);

      vm.goToStep(AuthStep.password);
      vm.back();
      expect(vm.step, AuthStep.sms);
      vm.back();
      expect(vm.step, AuthStep.phone);
      vm.back();
      expect(vm.step, AuthStep.passport);
      vm.dispose();
    });

    test('сбрасывает ошибку при возврате на предыдущий шаг', () {
      final vm =
          AuthStepperViewModel(_FakeAuthRepository(), AuthFlowMode.registration);
      vm.password = '123';
      vm.validatePassword(); // пишет errorMessage
      expect(vm.errorMessage, isNotNull);

      vm.goToStep(AuthStep.sms);
      vm.back();

      expect(vm.errorMessage, isNull);
      vm.dispose();
    });
  });

  group('AuthStepperViewModel SMS-код', () {
    test('requestSmsCode переводит на шаг sms и запускает кулдаун', () async {
      final repo = _FakeAuthRepository();
      final vm = AuthStepperViewModel(repo, AuthFlowMode.registration);
      vm.passport = '1234567890';
      vm.phone = '9001234567';

      final ok = await vm.requestSmsCode();

      expect(ok, isTrue);
      expect(vm.step, AuthStep.sms);
      expect(repo.sendCodeCalls, 1);
      expect(vm.canResend, isFalse);
      expect(vm.resendRemaining, greaterThan(0));
      vm.dispose();
    });

    test('resendCode заблокирован, пока кулдаун не истёк', () async {
      final repo = _FakeAuthRepository();
      final vm = AuthStepperViewModel(repo, AuthFlowMode.registration);
      await vm.requestSmsCode();
      expect(repo.sendCodeCalls, 1);

      final ok = await vm.resendCode();

      expect(ok, isFalse);
      expect(repo.sendCodeCalls, 1); // повторный запрос не ушёл
      vm.dispose();
    });

    test('resendCode после кулдауна отправляет код и перезапускает отсчёт', () {
      fakeAsync((async) {
        final repo = _FakeAuthRepository();
        final vm = AuthStepperViewModel(repo, AuthFlowMode.registration);

        var ok = false;
        vm.requestSmsCode().then((v) => ok = v);
        async.flushMicrotasks();
        expect(ok, isTrue);
        expect(vm.canResend, isFalse);

        async.elapse(
            const Duration(seconds: AuthStepperViewModel.resendCooldownSeconds + 1));
        expect(vm.resendRemaining, 0);
        expect(vm.canResend, isTrue);

        var resent = false;
        vm.resendCode().then((v) => resent = v);
        async.flushMicrotasks();

        expect(resent, isTrue);
        expect(repo.sendCodeCalls, 2);
        expect(vm.canResend, isFalse); // кулдаун перезапущен

        vm.dispose();
      });
    });

    test('ошибка отправки пишет errorMessage и не меняет шаг', () async {
      final repo = _FakeAuthRepository(shouldFailSend: true);
      final vm = AuthStepperViewModel(repo, AuthFlowMode.registration);

      final ok = await vm.requestSmsCode();

      expect(ok, isFalse);
      expect(vm.step, AuthStep.passport);
      expect(vm.errorMessage, 'Сервер недоступен');
      vm.dispose();
    });
  });

  group('AuthStepperViewModel.validatePassword', () {
    test('требует минимум 6 символов и совпадения полей', () {
      final vm =
          AuthStepperViewModel(_FakeAuthRepository(), AuthFlowMode.registration);
      vm.password = '123';
      vm.passwordConfirm = '123';
      expect(vm.validatePassword(), isFalse);
      expect(vm.errorMessage, contains('6'));

      vm.password = '123456';
      vm.passwordConfirm = '654321';
      expect(vm.validatePassword(), isFalse);
      expect(vm.errorMessage, contains('не совпадают'));

      vm.passwordConfirm = '123456';
      expect(vm.validatePassword(), isTrue);
      vm.dispose();
    });
  });
}
