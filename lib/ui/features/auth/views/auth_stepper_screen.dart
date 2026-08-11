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
import '../../../core/widgets/app_snack_bars.dart';
import '../../../core/widgets/error_banner.dart';
import '../../legal/agreement_content.dart';
import '../view_models/auth_stepper_view_model.dart';

/// Единый 4-шаговый экран регистрации и восстановления пароля.
///
/// Шаги: паспорт → телефон → SMS-код → пароль.
/// Назад (AppBar и системный жест) ходит по шагам без потери ввода;
/// выход из флоу — только с первого шага.
///
/// Переходы между шагами — направленные: вперёд контент уезжает влево,
/// новый прилетает справа; назад — реверс. SMS-код вводится в 4 OTP-ячейки
/// с авто-переходом, backspace-навигацией и тактильной отдачей. Все анимации
/// учитывают prefers-reduced-motion (мгновенный crossfade).
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
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();

  /// Счётчик сбросов SMS-поля. При изменении ValueKey поля пересоздаётся
  /// полностью — это надёжно чистит автозаполнение ОС и кеш платформы
  /// при запросе нового кода или неверном вводе.
  int _smsFieldReset = 0;

  /// Явное согласие с пользовательским соглашением при регистрации.
  /// Без установленной галочки кнопка «Зарегистрироваться» неактивна.
  bool _agreementAccepted = false;

  /// Предыдущий шаг — нужен для определения направления перехода
  /// (вперёд → слайд влево, назад → слайд вправо).
  AuthStep _lastStep = AuthStep.passport;

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
    _passwordErrorNotifier.dispose();
    _passwordConfirmErrorNotifier.dispose();
    _passportCtrl.dispose();
    _passportConfirmCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  /// Пересчёт field-level ошибок пароля без setState экрана.
  void _recomputePasswordErrors() {
    final p = _vm.password;
    final c = _vm.passwordConfirm;
    _passwordErrorNotifier.value =
        p.isNotEmpty && p.length < 6 ? 'Минимум 6 символов' : null;
    _passwordConfirmErrorNotifier.value =
        p.isNotEmpty && c.isNotEmpty && p != c ? 'Пароли не совпадают' : null;
  }

  // Field-level диагностика пароля вынесена в ValueNotifier: это позволяет
  // показывать ошибки живьём, не вызывая setState на каждый keystroke — иначе
  // весь экран (включая фокусный TextFormField) пересобирался при каждом вводе.
  final _passwordErrorNotifier = ValueNotifier<String?>(null);
  final _passwordConfirmErrorNotifier = ValueNotifier<String?>(null);

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String get _title => widget.mode == AuthFlowMode.registration
      ? 'Регистрация'
      : 'Восстановление пароля';

  /// Направление последнего перехода шага: true — вперёд (контент влево),
  /// false — назад (контент вправо).
  bool get _stepDirectionForward {
    final steps = AuthStep.values;
    return steps.indexOf(_vm.step) >= steps.indexOf(_lastStep);
  }

  /// Назад: по шагам флоу; выход — только с первого шага.
  void _onBack() {
    if (_vm.step == AuthStep.passport) {
      Navigator.of(context).maybePop();
    } else {
      HapticFeedback.lightImpact();
      _lastStep = _vm.step;
      _vm.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return PopScope(
      canPop: _vm.step == AuthStep.passport,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          HapticFeedback.lightImpact();
          _lastStep = _vm.step;
          _vm.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _onBack),
          title: Text(_title),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _StepIndicator(current: _vm.step, animate: !reduceMotion),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _AnimatedStepBody(
                    step: _vm.step,
                    forward: _stepDirectionForward,
                    reduceMotion: reduceMotion,
                    builder: (_) => Column(
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
                          // На финальном шаге регистрации кнопка неактивна,
                          // пока не отмечено согласие с пользовательским
                          // соглашением (явный акцепт вместо пассивной подписи).
                          enabled: !(_vm.step == AuthStep.password &&
                              widget.mode == AuthFlowMode.registration &&
                              !_agreementAccepted),
                          label: _buttonLabel(),
                          onPressed: _next,
                        ),
                      ],
                    ),
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
          ),
          const SizedBox(height: 8),
          Text(
            'Введите серию и номер паспорта (10 цифр)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
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
          ),
          const SizedBox(height: 8),
          Text(
            'Укажите номер телефона (10 цифр, без +7)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
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
          ),
          const SizedBox(height: 8),
          Text(
            'Мы отправили код на номер +7 ${_vm.phone}',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
          ),
          const SizedBox(height: 24),
          // OTP-ячейки: авто-переход, backspace-навигация, pop+haptic по цифре.
          // ValueKey сбрасывает состояние при каждом запросе нового SMS —
          // иначе на некоторых устройствах поле «залипает» на старом коде.
          _OtpCodeInput(
            key: ValueKey('otp-$_smsFieldReset'),
            length: 4,
            onChanged: (v) => _vm.smsCode = v,
            onComplete: () {
              if (!_vm.isLoading) _next();
            },
          ),
          const SizedBox(height: 16),
          _ResendSection(
            vm: _vm,
            onResend: _clearSmsField,
          ),
        ];
      case AuthStep.password:
        return [
          Text(
            'Шаг 4 из 4. Пароль',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Придумайте пароль (минимум 6 символов)',
            style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayDark),
          ),
          const SizedBox(height: 16),
          AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: _passwordErrorNotifier,
                  builder: (context, error, _) => _PasswordField(
                    controller: _passwordCtrl,
                    label: 'Пароль',
                    errorText: error,
                    onChanged: (v) {
                      _vm.password = v;
                      // Обновляем field-ошибки без пересборки экрана:
                      // фокусный TextFormField больше не дрожит на каждом вводе.
                      _recomputePasswordErrors();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String?>(
                  valueListenable: _passwordConfirmErrorNotifier,
                  builder: (context, error, _) => _PasswordField(
                    controller: _passwordConfirmCtrl,
                    label: 'Повторите пароль',
                    errorText: error,
                    onChanged: (v) {
                      _vm.passwordConfirm = v;
                      _recomputePasswordErrors();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Акцепт оферты привязан к моменту регистрации (п. 1.4 соглашения),
          // поэтому чек-бокс — на последнем шаге, у кнопки подтверждения.
          // Без явного согласия кнопка «Зарегистрироваться» неактивна.
          if (widget.mode == AuthFlowMode.registration) ...[
            const SizedBox(height: 16),
            _AgreementConsent(
              value: _agreementAccepted,
              onChanged: (v) => setState(() => _agreementAccepted = v ?? false),
            ),
          ],
        ];
    }
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
    _vm.smsCode = '';
    _smsFieldReset += 1;
    if (mounted) setState(() {});
  }

  Future<void> _next() async {
    bool ok;
    final fromStep = _vm.step;
    switch (_vm.step) {
      case AuthStep.passport:
        ok = _vm.validatePassport();
        if (ok) {
          HapticFeedback.lightImpact();
          _lastStep = fromStep;
          _vm.goToStep(AuthStep.phone);
        } else {
          HapticFeedback.heavyImpact();
        }
        break;
      case AuthStep.phone:
        if (_vm.phone.length != 10) {
          _vm.clearError();
          showErrorSnackBar(context, 'Введите 10 цифр номера телефона');
          HapticFeedback.heavyImpact();
          return;
        }
        ok = await _vm.requestSmsCode();
        if (ok) {
          HapticFeedback.lightImpact();
          _lastStep = fromStep;
        } else {
          HapticFeedback.heavyImpact();
        }
        break;
      case AuthStep.sms:
        ok = await _vm.verifyCode();
        if (ok) {
          HapticFeedback.lightImpact();
          _lastStep = fromStep;
        } else {
          HapticFeedback.heavyImpact();
          _clearSmsField();
        }
        break;
      case AuthStep.password:
        if (!_vm.validatePassword()) {
          HapticFeedback.heavyImpact();
          return;
        }
        ok = await _vm.finish();
        if (ok && mounted) {
          HapticFeedback.selectionClick();
          // Peak-end: подтверждаем успех до навигации (дальше роутер
          // сразу попросит геолокацию).
          showSuccessSnackBar(
            context,
            widget.mode == AuthFlowMode.registration
                ? 'Готово! Вы вошли в приложение'
                : 'Пароль обновлён. Вы вошли в приложение',
          );
          // Синхронизируем глобальный AuthViewModel: после registerAndLogin
          // токен сохранён в SecureStorage — восстановим сессию.
          await getIt<AuthViewModel>().checkSession();
          if (mounted) context.go('/main/orders');
        } else {
          HapticFeedback.heavyImpact();
        }
        break;
    }
  }
}

/// Направленный слайд+фейд переход между шагами stepper'а.
///
/// Вперёд: контент уезжает влево, новый прилетает справа.
/// Назад: реверс. Reduce-motion → мгновенный crossfade.
///
/// Длительность 420мс + easeOutQuint/`easeInQuint` + 64px слайд дают
/// «весомое», не резкое движение: быстрый старт, долгое замедление.
class _AnimatedStepBody extends StatelessWidget {
  const _AnimatedStepBody({
    required this.step,
    required this.forward,
    required this.reduceMotion,
    required this.builder,
  });

  final AuthStep step;
  final bool forward;
  final bool reduceMotion;
  final WidgetBuilder builder;

  /// Дистанция слайда в логических пикселях.
  static const double _slideDistance = 64;

  @override
  Widget build(BuildContext context) {
    // Направление прихода нового шага: вперёд — справа, назад — слева.
    final enterOffset =
        forward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
    // Направление ухода прежнего шага: противоположно приходу.
    final exitOffset =
        forward ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);

    return AnimatedSwitcher(
      duration: reduceMotion
          ? const Duration(milliseconds: 160)
          : const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutQuint,
      switchOutCurve: Curves.easeInQuint,
      transitionBuilder: (child, animation) {
        if (reduceMotion) {
          return FadeTransition(opacity: animation, child: child);
        }
        // AnimatedSwitcher оборачивает и входящий, и уходящий ребёнок в
        // этот builder. Различаем их по key: входящий несёт key == step.
        final isEntering = child.key == ValueKey<AuthStep>(step);
        final slideEnd = isEntering ? Offset.zero : exitOffset;
        final slideBegin = isEntering ? enterOffset : Offset.zero;
        return FadeTransition(
          opacity: animation,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, c) {
              final t = animation.value;
              final dx = slideBegin.dx + (slideEnd.dx - slideBegin.dx) * t;
              return Transform.translate(
                offset: Offset(dx * _slideDistance, 0),
                child: c,
              );
            },
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<AuthStep>(step),
        child: builder(context),
      ),
    );
  }
}

/// Индикатор шагов с анимированной заливкой сегментов.
///
/// Каждый сегмент — отдельный AnimatedContainer: заполнение плавно
/// «перетекает» при смене шага, а не щёлкает. Активный сегмент слегка
/// пульсирует (когда не отключён reduce-motion).
class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.animate});

  final AuthStep current;
  final bool animate;

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
                child: _ProgressSegment(
                  active: i <= currentIndex,
                  current: i == currentIndex,
                  animate: animate,
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

/// Один сегмент прогресс-трек с анимированной заливкой и пульсом активного.
class _ProgressSegment extends StatefulWidget {
  const _ProgressSegment({
    required this.active,
    required this.current,
    required this.animate,
  });

  final bool active;
  final bool current;
  final bool animate;

  @override
  State<_ProgressSegment> createState() => _ProgressSegmentState();
}

class _ProgressSegmentState extends State<_ProgressSegment>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.current && widget.animate) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _ProgressSegment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current && widget.animate) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        // Высота константна (5px): пульс НЕ меняет геометрию, иначе
        // Row пересчитывает layout и дёргает контент под индикатором.
        // «Дыхание» активного сегмента — белый шевр-оверлей с пиковым α 0.55:
        // читается как пульсация приборной панели, не как мигание.
        final pulseAlpha = (widget.current && widget.animate)
            ? (0.55 * _pulse.value.clamp(0.0, 1.0))
            : 0.0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 340),
          curve: Curves.easeOutCubic,
          height: 5,
          decoration: BoxDecoration(
            color: widget.active
                ? BrandColors.primary
                : BrandColors.grayLight,
            borderRadius: BorderRadius.circular(BrandRadius.sm),
          ),
          foregroundDecoration: BoxDecoration(
            color: pulseAlpha > 0
                ? BrandColors.white.withValues(alpha: pulseAlpha)
                : null,
            borderRadius: BorderRadius.circular(BrandRadius.sm),
          ),
        );
      },
    );
  }
}

/// N-ячеечный ввод OTP-кода.
///
/// Каждая ячейка — отдельный TextFormField (maxLength: 1). Авто-переход к
/// следующей при вводе, backspace на пустой ячейке возвращает к предыдущей,
/// pop-анимация масштаба + тактильная отдача по каждой цифре.
///
/// Автозаполнение SMS-кода ОС: ячейки обёрнуты в AutofillGroup, первая
/// ячейка несёт AutofillHints.oneTimeCode. Так как автозаполнение/вставка
/// может подставить весь код в одну ячейку, [onChangedInput] распределяет
/// несколько цифр по всем ячейкам.
class _OtpCodeInput extends StatefulWidget {
  const _OtpCodeInput({
    super.key,
    required this.length,
    required this.onChanged,
    this.onComplete,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final VoidCallback? onComplete;

  @override
  State<_OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<_OtpCodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<double> _scales;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _scales = List.filled(widget.length, 1.0);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Обработка ввода в ячейку [index]. Распределяет вставку/автозаполнение
  /// из нескольких цифр по всем ячейкам, продвигает фокус, запускает поп.
  void _onCellChanged(int index) {
    final raw = _controllers[index].text;
    final digits = raw.replaceAll(RegExp(r'\D'), '');

    // Случай «вставили весь код в одну ячейку» (включая автозаполнение ОС):
    // распределяем цифры по ячейкам, начиная с текущей.
    if (digits.length > 1) {
      _distribute(digits, startIndex: index);
      _emit();
      _maybeComplete();
      return;
    }

    if (digits.isEmpty) {
      _emit();
      return;
    }

    final d = digits.substring(digits.length - 1);
    final previous = _controllers[index].text;
    if (_controllers[index].text != d) {
      _controllers[index].text = d;
      _controllers[index].selection =
          TextSelection.collapsed(offset: d.length);
    }
    if (previous != d) {
      HapticFeedback.selectionClick();
      _pop(index);
    }
    // Авто-переход к следующей ячейке.
    if (index < widget.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else {
      _focusNodes[index].unfocus();
    }
    _emit();
    _maybeComplete();
  }

  /// Распределяет строку цифр по ячейкам начиная со [startIndex].
  void _distribute(String digits, {required int startIndex}) {
    for (var i = 0; i < digits.length; i++) {
      final target = startIndex + i;
      if (target >= widget.length) break;
      final d = digits[i];
      if (_controllers[target].text != d) {
        _controllers[target].text = d;
        _controllers[target].selection =
            TextSelection.collapsed(offset: 1);
        HapticFeedback.selectionClick();
        _pop(target);
      }
    }
    // Фокус на последнюю заполненную или следующую пустую.
    final lastFilled =
        (startIndex + digits.length - 1).clamp(0, widget.length - 1);
    if (lastFilled < widget.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[lastFilled + 1]);
    } else {
      _focusNodes[lastFilled].unfocus();
    }
  }

  /// Поп-анимация масштаба ячейки (1.0 → 1.12 → 1.0).
  void _pop(int index) {
    if (!mounted) return;
    setState(() => _scales[index] = 1.12);
    Future<void>.delayed(const Duration(milliseconds: 140), () {
      if (mounted) setState(() => _scales[index] = 1.0);
    });
  }

  void _emit() {
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  void _maybeComplete() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length && RegExp(r'^\d+$').hasMatch(code)) {
      widget.onComplete?.call();
    }
  }

  /// Backspace на пустой ячейке → переход к предыдущей с её очисткой.
  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _emit();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < widget.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: i == 0 || i == widget.length - 1 ? 0 : 6),
                child: _OtpCell(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  scale: _scales[i],
                  // oneTimeCode в первой ячейке для автозаполнения SMS.
                  autofillHints:
                      i == 0 ? const [AutofillHints.oneTimeCode] : null,
                  autofocus: i == 0,
                  onChanged: () => _onCellChanged(i),
                  onBackspace: () => _handleBackspace(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Одна ячейка OTP-кода: поп-анимация масштаба, цветовая реакция на фокус,
/// backspace-навигация через Focus onKeyEvent.
class _OtpCell extends StatefulWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.scale,
    required this.onChanged,
    required this.onBackspace,
    this.autofillHints,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final double scale;
  final VoidCallback onChanged;
  final VoidCallback onBackspace;
  final List<String>? autofillHints;
  final bool autofocus;

  @override
  State<_OtpCell> createState() => _OtpCellState();
}

class _OtpCellState extends State<_OtpCell> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChanged);
    // Перехват Backspace на пустой ячейке для перехода к предыдущей.
    widget.focusNode.onKeyEvent = _onKeyEvent;
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (widget.controller.text.isEmpty) {
        widget.onBackspace();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void didUpdateWidget(covariant _OtpCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      oldWidget.focusNode.onKeyEvent = null;
      widget.focusNode.addListener(_onFocusChanged);
      widget.focusNode.onKeyEvent = _onKeyEvent;
      _isFocused = widget.focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    // Не обнуляем onKeyEvent — нода распоряжается собой сама (внешний owns).
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.scale,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          autofillHints: widget.autofillHints,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyles.headlineMedium,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            fillColor: BrandColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BrandRadius.md),
              borderSide: BorderSide(
                color: _isFocused
                    ? BrandColors.primary.withValues(alpha: 0.5)
                    : BrandColors.grayLight,
                width: _isFocused ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BrandRadius.md),
              borderSide: const BorderSide(
                color: BrandColors.primary,
                width: 2,
              ),
            ),
          ),
          onChanged: (_) => widget.onChanged(),
        ),
      ),
    );
  }
}

class _DigitsField extends StatefulWidget {
  const _DigitsField({
    required this.label,
    required this.length,
    required this.onChanged,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.keyboardType = TextInputType.number,
  });

  final String label;
  final int length;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
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
    final showPrefix = widget.prefixIcon ?? Icons.numbers_outlined;
    return TextFormField(
      controller: _effectiveController,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.length),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: Icon(showPrefix),
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

/// Повторная отправка SMS-кода с кулдауном.
///
/// Вернуться к смене номера можно системным «Назад» (AppBar / edge-swipe),
/// который через PopScope ходит по шагам.
class _ResendSection extends StatelessWidget {
  const _ResendSection({
    required this.vm,
    required this.onResend,
  });

  final AuthStepperViewModel vm;

  /// Вызывается перед повторной отправкой кода (например, для очистки поля).
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final remaining = vm.resendRemaining;
    return TextButton(
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
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final bool isLoading;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading;
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
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

/// Чек-бокс явного согласия с пользовательским соглашением на последнем шаге
/// регистрации. Без установленной галочки кнопка «Зарегистрироваться»
/// не активна.
///
/// Клик по тексту переключает чек-бокс. «Пользовательское соглашение»
/// открывается внутри приложения, «Политика конфиденциальности» — внешним
/// PDF в браузере; эти ссылки НЕ переключают чек-бокс.
class _AgreementConsent extends StatefulWidget {
  const _AgreementConsent({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

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
      showErrorSnackBar(context, 'Не удалось открыть ссылку');
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
    return InkWell(
      onTap: () => widget.onChanged(!widget.value),
      borderRadius: BorderRadius.circular(BrandRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.value,
              onChanged: widget.onChanged,
              // Сжимаем стандартные огромные отступы Material-чекбокса,
              // чтобы он выровнялся с первой строкой текста.
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                // Перехватываем тап по тексту, чтобы он переключал чек-бокс,
                // но не «съедал» тапы по ссылкам (у них свой recognizer).
                behavior: HitTestBehavior.translucent,
                onTap: () => widget.onChanged(!widget.value),
                child: Text.rich(
                  TextSpan(
                    style: base,
                    children: [
                      const TextSpan(text: 'Я принимаю '),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
