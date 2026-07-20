import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../view_models/auth_view_model.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/error_banner.dart';
import '../../legal/agreement_content.dart';
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

  /// Счётчик сбросов SMS-поля. При изменении ValueKey поля пересоздаётся
  /// полностью — это надёжно чистит автозаполнение ОС и кеш платформы
  /// при запросе нового кода или неверном вводе.
  int _smsFieldReset = 0;

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
          if (widget.mode == AuthFlowMode.registration) ...[
            const SizedBox(height: 12),
            _DigitsField(
              controller: _passportConfirmCtrl,
              label: 'Подтвердите паспорт',
              length: 10,
              onChanged: (v) => _vm.passportConfirm = v,
            ),
          ],
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
          _DigitsField(
            controller: _phoneCtrl,
            label: 'Телефон',
            hintText: '9001234567',
            length: 10,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
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
          // ValueKey сбрасывает состояние поля (включая автозаполнение ОС
          // и кеш платформы) при каждом запросе нового SMS — иначе на
          // некоторых устройствах поле «залипает» на старом коде.
          _DigitsField(
            key: ValueKey('sms-field-$_smsFieldReset'),
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
            onResend: _clearSmsField,
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
          // Акцепт оферты привязан к моменту регистрации (п. 1.4 соглашения),
          // поэтому уведомление — на последнем шаге, у кнопки подтверждения.
          if (widget.mode == AuthFlowMode.registration) ...[
            const SizedBox(height: 16),
            const _AgreementConsent(),
          ],
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

  /// Очищает поле SMS-кода: после неудачной проверки и перед повторным
  /// запросом кода, чтобы водитель не отправлял устаревший код.
  /// Счётчик _smsFieldReset пересоздаёт поле через ValueKey — это
  /// гарантированно сбрасывает автозаполнение ОС, в отличие от plain clear().
  void _clearSmsField() {
    _smsCtrl.clear();
    _vm.smsCode = '';
    _smsFieldReset += 1;
    if (mounted) setState(() {});
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
        if (!ok) _clearSmsField();
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

class _DigitsField extends StatefulWidget {
  const _DigitsField({
    super.key,
    required this.label,
    required this.length,
    required this.onChanged,
    this.controller,
    this.center = false,
    this.autofillHints,
    this.prefixIcon,
    this.hintText,
    this.keyboardType = TextInputType.number,
  });

  final String label;
  final int length;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final bool center;
  final List<String>? autofillHints;
  final IconData? prefixIcon;
  final String? hintText;
  final TextInputType keyboardType;

  @override
  State<_DigitsField> createState() => _DigitsFieldState();
}

class _DigitsFieldState extends State<_DigitsField> {
  TextEditingController? _createdController;

  /// Актуальный контроллер: внешний (из виджета) или внутренний (если внешний
  /// не передан). Важно брать его динамически — при смене шага stepper'а
  /// `_DigitsField` на той же позиции дерева получает новый `widget.controller`,
  /// и этот геттер переключается на него без пересоздания State.
  TextEditingController get _effectiveController {
    if (widget.controller != null) return widget.controller!;
    return _createdController ??= TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    _effectiveController.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _DigitsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _createdController;
      final newController = _effectiveController;
      if (oldController != newController) {
        oldController?.removeListener(_onControllerChanged);
        newController.addListener(_onControllerChanged);
        // Перерисовываемся, чтобы актуализировать видимость кнопки очистки
        // под текст нового контроллера.
        setState(() {});
      }
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _clear() {
    _effectiveController.clear();
    widget.onChanged('');
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onControllerChanged);
    _createdController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _effectiveController.text.isNotEmpty;
    final showPrefix = widget.prefixIcon ?? (widget.center ? null : Icons.numbers_outlined);
    return TextFormField(
      controller: _effectiveController,
      keyboardType: widget.keyboardType,
      textAlign: widget.center ? TextAlign.center : TextAlign.start,
      autofillHints: widget.autofillHints,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.length),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: showPrefix == null ? null : Icon(showPrefix),
        suffixIcon: hasText
            ? IconButton(
                tooltip: 'Очистить',
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: _clear,
              )
            : null,
      ),
      maxLength: widget.length,
      onChanged: widget.onChanged,
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

  void _clear() {
    widget.controller?.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final hasText = (widget.controller?.text ?? '').isNotEmpty;
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
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasText)
              IconButton(
                tooltip: 'Очистить',
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: _clear,
              ),
            IconButton(
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
          ],
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

/// Повторная отправка кода с кулдауном и возврат к смене номера.
class _ResendSection extends StatelessWidget {
  const _ResendSection({
    required this.vm,
    required this.onChangePhone,
    required this.onResend,
  });

  final AuthStepperViewModel vm;
  final VoidCallback onChangePhone;

  /// Вызывается перед повторной отправкой кода (например, для очистки поля).
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final remaining = vm.resendRemaining;
    return Column(
      children: [
        TextButton(
          onPressed: vm.canResend
              ? () {
                  onResend();
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

/// Уведомление о принятии соглашения на последнем шаге регистрации.
///
/// «Пользовательское соглашение» открывается внутри приложения,
/// «Политика конфиденциальности» — внешним PDF в браузере.
class _AgreementConsent extends StatefulWidget {
  const _AgreementConsent();

  @override
  State<_AgreementConsent> createState() => _AgreementConsentState();
}

class _AgreementConsentState extends State<_AgreementConsent> {
  late final TapGestureRecognizer _agreementRecognizer;
  late final TapGestureRecognizer _policyRecognizer;

  @override
  void initState() {
    super.initState();
    _agreementRecognizer = TapGestureRecognizer()
      ..onTap = () => context.push('/auth/agreement');
    _policyRecognizer = TapGestureRecognizer()..onTap = _openPolicy;
  }

  @override
  void dispose() {
    _agreementRecognizer.dispose();
    _policyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _openPolicy() async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(LegalLinks.privacyPolicy),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Юридически значимый текст — не мельче основного (bodyMedium, graphite).
    final base = AppTextStyles.bodyMedium;
    final link = base.copyWith(
      color: BrandColors.primaryText,
      decoration: TextDecoration.underline,
      decorationColor: BrandColors.primaryText,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'Нажимая «Зарегистрироваться», вы принимаете '),
          TextSpan(
            text: 'Пользовательское соглашение',
            style: link,
            recognizer: _agreementRecognizer,
          ),
          const TextSpan(text: ' и '),
          TextSpan(
            text: 'Политику конфиденциальности',
            style: link,
            recognizer: _policyRecognizer,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
