import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/repositories/profile_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../view_models/profile_view_model.dart';

/// Экран редактирования профиля (ФИО, паспорт, телефон).
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileViewModel _viewModel;
  final _passportController = TextEditingController();
  final _nameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(getIt<ProfileRepository>());
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
      if (!_initialized && _viewModel.user != null) {
        _initialized = true;
        final u = _viewModel.user!;
        _passportController.text = u.login;
        _nameController.text = u.name;
        _secondNameController.text = u.secondName;
        _surnameController.text = u.surname;
        _phoneController.text = u.phone;
      }
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    _passportController.dispose();
    _nameController.dispose();
    _secondNameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _viewModel.updateProfile(
      login: _passportController.text.trim(),
      name: _nameController.text.trim(),
      secondName: _secondNameController.text.trim(),
      surname: _surnameController.text.trim(),
      phone: _phoneController.text.trim(),
      phoneCode: 1,
    );
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранён')),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.errorMessage ??
                'Не удалось сохранить профиль. Проверьте данные и попробуйте ещё раз.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать профиль')),
      body: _viewModel.isLoading && _viewModel.user == null
          ? const Center(child: CircularProgressIndicator())
          : _viewModel.user == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _viewModel.errorMessage ??
                              'Не удалось загрузить профиль',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: BrandColors.grayDark),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _viewModel.load,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                    controller: _passportController,
                    keyboardType: TextInputType.number,
                    enableInteractiveSelection: false,
                    contextMenuBuilder: (_, __) => const SizedBox.shrink(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
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
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    controller: _surnameController,
                    label: 'Фамилия',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    controller: _nameController,
                    label: 'Имя',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _Field(
                    controller: _secondNameController,
                    label: 'Отчество',
                    icon: Icons.person_outline,
                    required: false,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Телефон (без +7)',
                      hintText: '9001234567',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (value) {
                      final v = (value ?? '').trim();
                      if (v.length != 10) return 'Введите 10 цифр номера';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _viewModel.isSaving ? null : _save,
                    child: _viewModel.isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: BrandColors.white),
                          )
                        : const Text('Сохранить изменения'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.required = true,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (!required) return null;
        if ((value ?? '').trim().isEmpty) return 'Введите ${label.toLowerCase()}';
        return null;
      },
    );
  }
}
