import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../view_models/auth_view_model.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/error_banner.dart';
import '../view_models/auth_stepper_view_model.dart';

/// Единый 4-шаговый экран регистрации и восстановления пароля.
///
/// Шаги: паспорт → телефон → SMS-код → пароль.
/// Назад (AppBar и системный жест) ходит по шагам без потери ввода;
/// выход из флоу — только с первого шага.
class AuthStepperScreen extends StatefulWidget {
  const AuthStepperScreen({super.key, required this.mode});

  /// Регистрация или восстановление пароля.
  final AuthFlowMode mode;

  @override
  State<AuthStepperScreen> createState() => _AuthStepperScreenState();
}

class _AuthStepperScreenState extends State<AuthStepperScreen> {
  late final AuthStepperViewModel _vm;

  // Контроллеры сохраняют ввод при переходах между шагами.
  final _passportCtrl = TextEditingController();
  final _passportConfirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _smsCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = AuthStepperViewModel(getIt<AuthRepository>(), widget.mode);
    _vm.addListener(_onChanged);
  }

  @override
  void dispose() {
    _vm.removeListener(_onChanged);
    _vm.dispose();
    _passportCtrl.dispose();
    _passportConfirmCtrl.dispose();
    _phoneCtrl.dispose();
    _smsCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  String get _title => widget.mode == AuthFlowMode.registration
      ? 'Регистрация'
      : 'Восстановление пароля';

  /// Назад: по шагам флоу; выход — только с первого шага.
  void _onBack() {
    if (_vm.step == AuthStep.passport) {
      Navigator.of(context).maybePop();
    } else {
      _vm.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _vm.step == AuthStep.passport,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _vm.back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _onBack),
          title: Text(_title),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _StepIndicator(current: _vm.step),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._buildStep(),
                      if (_vm.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        ErrorBanner(message: _vm.errorMessage!),
                      ],
                      const SizedBox(height: 24),
                      _PrimaryButton(
                        isLoading: _vm.isLoading,
                        label: _buttonLabel(),
                        onPressed: _next,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStep() {
    switch (_vm.step) {
      case AuthStep.passport:
        return [
          Text(
            'Шаг 1 из 4. Паспорт',
            style: AppTextStyles.headlineMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Введите серию и номер паспорта (10 цифр)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          _DigitsField(
            controller: _passportCtrl,
            label: 'Серия и номер паспорта',
            length: 10,
            onChanged: (v) => _vm.passport = v,
          ),
          const SizedBox(height: 12),
          _DigitsField(
            controller: _passportConfirmCtrl,
            label: 'Подтвердите паспорт',
            length: 10,
            onChanged: (v) => _vm.passportConfirm = v,
          ),
        ];
      case AuthStep.phone:
        return [
          Text(
            'Шаг 2 из 4. Телефон',
            style: AppTextStyles.headlineMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Укажите номер телефона (10 цифр, код +7)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(
              labelText: 'Телефон',
              hintText: '9001234567',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            onChanged: (v) => _vm.phone = v.trim(),
          ),
        ];
      case AuthStep.sms:
        return [
          Text(
            'Шаг 3 из 4. SMS-код',
            style: AppTextStyles.headlineMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Мы отправили код на номер +7 ${_vm.phone}',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          _DigitsField(
            controller: _smsCtrl,
            label: 'Код из SMS',
            length: 4,
            center: true,
            autofillHints: const [AutofillHints.oneTimeCode],
            onChanged: (v) => _vm.smsCode = v,
          ),
          const SizedBox(height: 8),
          _ResendSection(
            vm: _vm,
            onChangePhone: _vm.back,
          ),
        ];
      case AuthStep.password:
        return [
          Text(
            'Шаг 4 из 4. Пароль',
            style: AppTextStyles.headlineMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Придумайте пароль (минимум 6 символов)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PasswordField(
                  controller: _passwordCtrl,
                  label: 'Пароль',
                  errorText: _passwordError,
                  onChanged: (v) {
                    _vm.password = v;
                    // Пересобираем, чтобы field-ошибки обновлялись живьём.
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  controller: _passwordConfirmCtrl,
                  label: 'Повторите пароль',
                  errorText: _passwordConfirmError,
                  onChanged: (v) {
                    _vm.passwordConfirm = v;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ];
    }
  }

  /// Field-level диагностика первого поля пароля (показываем после ввода).
  String? get _passwordError {
    final p = _vm.password;
    if (p.isNotEmpty && p.length < 6) return 'Минимум 6 символов';
    return null;
  }

  /// Field-level диагностика подтверждения (когда оба поля непустые).
  String? get _passwordConfirmError {
    final p = _vm.password;
    final c = _vm.passwordConfirm;
    if (p.isNotEmpty && c.isNotEmpty && p != c) return 'Пароли не совпадают';
    return null;
  }

  String _buttonLabel() {
    switch (_vm.step) {
      case AuthStep.passport:
        return 'Далее';
      case AuthStep.phone:
        return 'Получить код';
      case AuthStep.sms:
        return 'Подтвердить код';
      case AuthStep.password:
        return widget.mode == AuthFlowMode.registration
            ? 'Зарегистрироваться'
            : 'Восстановить пароль';
    }
  }

  Future<void> _next() async {
    bool ok;
    switch (_vm.step) {
      case AuthStep.passport:
        ok = _vm.validatePassport();
        if (ok) _vm.goToStep(AuthStep.phone);
        break;
      case AuthStep.phone:
        if (_vm.phone.length != 10) {
          _vm.clearError();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Введите 10 цифр номера телефона')));
          return;
        }
        ok = await _vm.requestSmsCode();
        break;
      case AuthStep.sms:
        ok = await _vm.verifyCode();
        break;
      case AuthStep.password:
        if (!_vm.validatePassword()) return;
        ok = await _vm.finish();
        if (ok && mounted) {
          // Peak-end: подтверждаем успех до навигации (дальше роутер
          // сразу попросит геолокацию).
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.mode == AuthFlowMode.registration
                    ? 'Готово! Вы вошли в приложение'
                    : 'Пароль обновлён. Вы вошли в приложение',
              ),
            ),
          );
          // Синхронизируем глобальный AuthViewModel: после registerAndLogin
          // токен сохранён в SecureStorage — восстановим сессию.
          await getIt<AuthViewModel>().checkSession();
          if (mounted) context.go('/main/orders');
        }
        break;
    }
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current});
  final AuthStep current;

  @override
  Widget build(BuildContext context) {
    const steps = AuthStep.values;
    final currentIndex = steps.indexOf(current);
    return Semantics(
      label: 'Шаг ${currentIndex + 1} из ${steps.length}',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= currentIndex
                        ? BrandColors.primary
                        : BrandColors.grayLight,
                    borderRadius: BorderRadius.circular(BrandRadius.sm),
                  ),
                ),
              ),
              if (i != steps.length - 1) const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _DigitsField extends StatelessWidget {
  const _DigitsField({
    required this.label,
    required this.length,
    required this.onChanged,
    this.controller,
    this.center = false,
    this.autofillHints,
  });

  final String label;
  final int length;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final bool center;
  final List<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: center ? TextAlign.center : TextAlign.start,
      autofillHints: autofillHints,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length),
      ],
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        prefixIcon: center ? null : const Icon(Icons.numbers_outlined),
      ),
      maxLength: length,
      onChanged: onChanged,
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.onChanged,
    this.controller,
    this.errorText,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? errorText;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      enableInteractiveSelection: false,
      contextMenuBuilder: (_, __) => const SizedBox.shrink(),
      autofillHints: const [AutofillHints.newPassword],
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
          tooltip: _obscure ? 'Показать пароль' : 'Скрыть пароль',
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

/// Повторная отправка кода с кулдауном и возврат к смене номера.
class _ResendSection extends StatelessWidget {
  const _ResendSection({required this.vm, required this.onChangePhone});

  final AuthStepperViewModel vm;
  final VoidCallback onChangePhone;

  @override
  Widget build(BuildContext context) {
    final remaining = vm.resendRemaining;
    return Column(
      children: [
        TextButton(
          onPressed: vm.canResend
              ? () {
                  vm.resendCode();
                }
              : null,
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          child: Text(
            remaining > 0
                ? 'Отправить код повторно ($remaining с)'
                : 'Отправить код повторно',
          ),
        ),
        TextButton(
          onPressed: onChangePhone,
          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text('Изменить номер'),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: BrandColors.white),
            )
          : Text(label),
    );
  }
}
