import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/app_snack_bars.dart';
import '../view_models/profile_view_model.dart';

/// Экран смены пароля.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileViewModel _viewModel;
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProfileViewModel>();
    _viewModel.addListener(_onChanged);
  }

  @override
  void dispose() {
    // VM — singleton, его не диспозим; только снимаем слушатель.
    _viewModel.removeListener(_onChanged);
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _viewModel.changePassword(
      _oldController.text,
      _newController.text,
    );
    if (ok && mounted) {
      showSuccessSnackBar(context, 'Пароль изменён');
      context.pop();
    } else if (mounted) {
      showErrorSnackBar(
        context,
        _viewModel.errorMessage ??
            'Не удалось сменить пароль. Проверьте текущий пароль и попробуйте ещё раз.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сменить пароль')),
      body: Form(
        key: _formKey,
          child: ListView(
            // Нижний safe-area: кнопка «Изменить пароль» не под home-indicator.
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            children: [
            _PasswordField(
              controller: _oldController,
              label: 'Текущий пароль',
              obscure: _obscureOld,
              onToggle: () => setState(() => _obscureOld = !_obscureOld),
              validator: (v) => (v ?? '').isEmpty ? 'Введите текущий пароль' : null,
            ),
            const SizedBox(height: 12),
            _PasswordField(
              controller: _newController,
              label: 'Новый пароль',
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
              onChanged: (_) {
                if (_confirmController.text.isNotEmpty) {
                  _formKey.currentState?.validate();
                }
              },
              validator: (v) => (v ?? '').length < 6 ? 'Пароль должен содержать не менее 6 символов' : null,
            ),
            const SizedBox(height: 12),
            _PasswordField(
              controller: _confirmController,
              label: 'Повторите новый пароль',
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (v) =>
                  v != _newController.text ? 'Пароли не совпадают. Введите одинаковые значения' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _viewModel.isSaving ? null : _submit,
              child: _viewModel.isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: BrandColors.white),
                    )
                  : const Text('Изменить пароль'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    required this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enableInteractiveSelection: false,
      contextMenuBuilder: (_, __) => const SizedBox.shrink(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
          tooltip: obscure ? 'Показать пароль' : 'Скрыть пароль',
          onPressed: onToggle,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ),
      validator: validator,
    );
  }
}
