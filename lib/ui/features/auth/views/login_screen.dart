import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_config.dart';
import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
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
    if (mounted) setState(() {});
  }

  bool get _isFormValid =>
      _loginController.text.trim().length == 10 &&
      _passwordController.text.isNotEmpty;

  Future<void> _handleLogin(AuthViewModel auth) async {
    final ok = await auth.login(
      _loginController.text.trim(),
      _passwordController.text,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Не удалось войти. Проверьте паспорт и пароль.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = getIt<AuthViewModel>();
    final useMock = getIt<AppConfig>().useMock;
    return Scaffold(
      backgroundColor: BrandColors.white,
      body: SafeArea(
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
                        const SizedBox(height: 24),
                        const _Logo(),
                        const SizedBox(height: 24),
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
                        _PassportField(controller: _loginController),
                        const SizedBox(height: 16),
                        _PasswordField(
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          onToggleVisibility: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        if (auth.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            auth.errorMessage!,
                            style: AppTextStyles.caption
                                .copyWith(color: BrandColors.error),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 24),
                        _LoginButton(
                          isLoading: auth.isLoading,
                          enabled: _isFormValid && !auth.isLoading,
                          onPressed: () => _handleLogin(auth),
                        ),
                        const SizedBox(height: 24),
                        Row(
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
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/ic_logo.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
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
      // Отключаем вставку/копирование из буфера обмена (ТЗ).
      enableInteractiveSelection: false,
      contextMenuBuilder: (_, __) => const SizedBox.shrink(),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      maxLength: 10,
      decoration: const InputDecoration(
        labelText: 'Серия и номер паспорта',
        hintText: '1234567890',
        counterText: '',
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      validator: (value) {
        final v = (value ?? '').trim();
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
  });

  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
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
