import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_config.dart';
import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/error_banner.dart';
import '../view_models/auth_view_model.dart';

/// Экран входа по паспорту и паролю.
///
/// Поле паспорта и пароля отключены от вставки из буфера обмена
/// (требование безопасности ТЗ).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loginController.addListener(_onChanged);
    _passwordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _loginController.removeListener(_onChanged);
    _passwordController.removeListener(_onChanged);
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onChanged() {
    // Сбрасываем inline-ошибку при редактировании полей.
    getIt<AuthViewModel>().clearError();
    if (mounted) setState(() {});
  }

  /// Цифры паспорта без визуального пробела маски (логическое значение):
  /// для валидации и отправки на сервер нужен ровно 10-значный ряд.
  String get _passportDigits =>
      _loginController.text.replaceAll(RegExp(r'\D'), '');

  bool get _isFormValid =>
      _passportDigits.length == 10 &&
      _passwordController.text.isNotEmpty;

  Future<void> _handleLogin(AuthViewModel auth) async {
    // Ошибка показывается inline под полями (auth.errorMessage) —
    // без дублирующего SnackBar.
    await auth.login(
      _passportDigits,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = getIt<AuthViewModel>();
    final useMock = getIt<AppConfig>().useMock;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Фон входа светлый (paperWarm) — поэтому иконки статус-бара
      // должны быть тёмными (systemDark), иначе они сливаются с фоном.
      // Без AppBar свой стиль статус-бара задаёт только AnnotatedRegion.
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // Фон авторизации — иллюстрация с грузовиком на закате.
        // Поверх неё — мягкий тёплый scrim: картинка остаётся видимой
        // как тон, а контент читается без шума.
        body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/auth_screen.png',
            fit: BoxFit.cover,
            semanticLabel: 'Фон экрана входа',
          ),
          const _AuthScrim(),
          SafeArea(
            child: ListenableBuilder(
              listenable: auth,
              builder: (context, _) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            const _BrandHeader(),
                            const SizedBox(height: 32),
                            Text(
                              'Вход в приложение',
                              style: AppTextStyles.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Войдите, используя серию и номер паспорта',
                              style: AppTextStyles.bodyMedium
                                  .copyWith(color: BrandColors.grayDark),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            AutofillGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _PassportField(controller: _loginController),
                                  const SizedBox(height: 16),
                                  _PasswordField(
                                    controller: _passwordController,
                                    obscure: _obscurePassword,
                                    onToggleVisibility: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                    onSubmitted: _isFormValid && !auth.isLoading
                                        ? () => _handleLogin(auth)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            if (auth.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              ErrorBanner(message: auth.errorMessage!),
                            ],
                            const SizedBox(height: 24),
                            _LoginButton(
                              isLoading: auth.isLoading,
                              enabled: _isFormValid && !auth.isLoading,
                              onPressed: () => _handleLogin(auth),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () => context.push('/auth/register'),
                                  child: const Text('Регистрация'),
                                ),
                                Container(
                                  width: 1,
                                  height: 16,
                                  color: BrandColors.grayLight,
                                ),
                                TextButton(
                                  onPressed: () => context.push('/auth/recovery'),
                                  child: const Text('Забыли пароль?'),
                                ),
                              ],
                            ),
                            if (useMock) ...[
                              const SizedBox(height: 24),
                              const _MockHint(),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}

/// Тёплый scrim поверх фоновой иллюстрации.
///
/// Равномерный, а не градиентный: фото читается как ровный тёплый тон, а
/// контраст контента **гарантирован** на любом участке экрана (раньше в
/// центральной полосе α падала до 0.55 — контент над тёмным участком фото
/// получал непредсказуемый контраст, что критика P0 отметила как риск для
/// чтения на улице). Лейблы и хинты полей на это не завязаны — они лежат
/// внутри белых полей (fillColor=white), их контраст задаётся темой ввода.
class _AuthScrim extends StatelessWidget {
  const _AuthScrim();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ColoredBox(
        color: BrandColors.paperWarm.withValues(alpha: 0.85),
      ),
    );
  }
}

/// Шапка экрана входа: логотип «Умная логистика» и название приложения
/// в две строки — «УМНЫЙ» графитовым, «ВОДИТЕЛЬ» в primaryText (AA-оранжевый).
///
/// Решения по критике P2:
/// - Графитовый лого (а не чисто чёрный) — вписывается в тёплую палитру,
///   где текст графитовый; чёрный читался холодным «штампом».
/// - Название — один [Text.rich] с переносом строки: скринридер произносит
///   «УМНЫЙ ВОДИТЕЛЬ» одной фразой, а не двумя отдельными utterance.
/// - Размер берётся из шкалы ([AppTextStyles.headlineLarge], 28), без хардкода.
/// - «ВОДИТЕЛЬ» в [BrandColors.primaryText] (#D63A00, 4.70:1 на белом) —
///   AA для обычного текста и оставляет Signal Orange (#FE4500) свободным
///   для кнопки CTA (One Accent Rule).
/// Montserrat содержит кириллицу; Bebas Neue её не содержит (был бы
/// системный fallback), поэтому название — на Montserrat.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.headlineLarge.copyWith(letterSpacing: 2);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/ul_logo_graphite.png',
          height: 88,
          fit: BoxFit.contain,
          semanticLabel: 'Логотип «Умная логистика»',
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            style: base,
            children: [
              TextSpan(
                text: 'УМНЫЙ',
                style: base.copyWith(color: BrandColors.graphite),
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: 'ВОДИТЕЛЬ',
                style: base.copyWith(color: BrandColors.primaryText),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Форматтер поля паспорта: группирует «серия 4 цифры» + «номер 6 цифр»
/// пробелом — `4510 712345`. Хранит логику на сырых цифрах: при любой правке
/// берёт из значения только цифры и заново расставляет один пробел после 4-й.
/// Так серия и номер опознаются с одного взгляда (критика P1) — водитель не
/// пересчитывает 10 цифр вслепую.
class _PassportMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Жёсткий лимит 10 цифр — серия (4) + номер (6).
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 4) buffer.write(' ');
      buffer.write(capped[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _PassportField extends StatelessWidget {
  const _PassportField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      // Отключаем вставку/копирование из буфера обмена (ТЗ).
      enableInteractiveSelection: false,
      contextMenuBuilder: (_, __) => const SizedBox.shrink(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11), // 10 цифр + пробел маски
        _PassportMaskFormatter(),
      ],
      maxLength: 11,
      decoration: const InputDecoration(
        labelText: 'Серия и номер паспорта',
        hintText: '4510 712345',
        counterText: '',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      validator: (value) {
        final v = (value ?? '').replaceAll(RegExp(r'\D'), '');
        if (v.length != 10) {
          return 'Введите 10 цифр серии и номера паспорта';
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleVisibility,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleVisibility;

  /// Сабмит по клавише «Готово» на клавиатуре (когда форма валидна).
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      // Отключаем вставку/копирование из буфера обмена (ТЗ).
      enableInteractiveSelection: false,
      contextMenuBuilder: (_, __) => const SizedBox.shrink(),
      decoration: InputDecoration(
        labelText: 'Пароль',
        hintText: 'Введите пароль',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          tooltip: obscure ? 'Показать пароль' : 'Скрыть пароль',
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.enabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            enabled ? BrandColors.primary : BrandColors.grayLight,
        foregroundColor: BrandColors.white,
      ),
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: BrandColors.white,
              ),
            )
          : const Text('Войти'),
    );
  }
}

class _MockHint extends StatelessWidget {
  const _MockHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BrandColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(BrandRadius.md),
        border: Border.all(color: BrandColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 20, color: BrandColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Демо-режим: паспорт 1234567890, пароль 123456',
              style: AppTextStyles.bodySmall
                  .copyWith(color: BrandColors.graphite),
            ),
          ),
        ],
      ),
    );
  }
}
