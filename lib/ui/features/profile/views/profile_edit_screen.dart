import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/app_snack_bars.dart';
import '../../../core/widgets/passport_field.dart';
import '../view_models/profile_view_model.dart';
import 'phone_confirm_dialog.dart';

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
    _viewModel = getIt<ProfileViewModel>();
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
      if (!_initialized && _viewModel.user != null) {
        _initialized = true;
        final u = _viewModel.user!;
        // Форматируем стартовое значение в маску «4510 712345»: при
        // программном присваивании PassportMaskFormatter не срабатывает
        // (он применяется только к пользовательскому вводу).
        _passportController.text = PassportMaskFormatter.formatStatic(u.login);
        _nameController.text = u.name;
        _secondNameController.text = u.secondName;
        _surnameController.text = u.surname;
        _phoneController.text = u.phone;
      }
    }
  }

  @override
  void dispose() {
    // VM — singleton, его не диспозим; только снимаем слушатель.
    _viewModel.removeListener(_onChanged);
    _passportController.dispose();
    _nameController.dispose();
    _secondNameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    // Поле паспорта хранит маску «4510 712345» с пробелом — для сервера
    // нужен ряд из 10 цифр без разделителей.
    final login = _passportController.text.replaceAll(RegExp(r'\D'), '');
    final name = _nameController.text.trim();
    final secondName = _secondNameController.text.trim();
    final surname = _surnameController.text.trim();
    final newPhone = _phoneController.text.trim();

    // Смена телефона требует подтверждения по SMS: сервер отклоняет
    // POST /user с неподтверждённым номером (code:-14 «The phone unconfirmed»).
    // Если телефон не менялся — сохраняем как обычно, без SMS.
    final phoneChanged = _viewModel.user?.phone != newPhone;
    if (!phoneChanged) {
      await _saveProfile(login, name, secondName, surname, newPhone);
      return;
    }

    // Телефон изменился → отправляем SMS-код на новый номер.
    final sent = await _viewModel.requestPhoneCode(newPhone);
    if (!mounted) return;
    if (!sent) {
      showErrorSnackBar(
        context,
        _viewModel.errorMessage ??
            'Не удалось отправить код. Проверьте номер и попробуйте ещё раз.',
      );
      return;
    }

    // Открываем диалог ввода кода. confirmPhoneAndSave внутри проверит код
    // и сохранит профиль. true — успех, профиль уже обновлён в singleton-VM.
    final confirmed = await showPhoneConfirmDialog(
      context,
      newPhone: newPhone,
      login: login,
      name: name,
      secondName: secondName,
      surname: surname,
    );
    _viewModel.resetPhoneConfirmation();
    if (!mounted) return;
    if (confirmed == true) {
      showSuccessSnackBar(context, 'Профиль сохранён');
      // go() вместо pop(): updateProfile() внутри зовёт
      // AuthViewModel.updateUser() → notifyListeners(), а AuthViewModel
      // входит в refreshListenable роутера. Из-за этого роутер пере-парсит
      // стек и в StatefulShellRoute.indexedStack context.pop() «съедается»
      // этой перестройкой (гонка, известная в go_router 17). go() задаёт
      // целевую локацию детерминированно, поэтому возврат на экран профиля
      // срабатывает надёжно.
      context.go('/main/profile');
    }
  }

  /// Сохранение профиля без смены телефона (или когда телефон не менялся).
  Future<void> _saveProfile(
    String login,
    String name,
    String secondName,
    String surname,
    String phone,
  ) async {
    final ok = await _viewModel.updateProfile(
      login: login,
      name: name,
      secondName: secondName,
      surname: surname,
      phone: phone,
      phoneCode: 1,
    );
    if (!mounted) return;
    if (ok) {
      showSuccessSnackBar(context, 'Профиль сохранён');
      // VM — singleton: updateProfile() уже обновил общий _user и позвал
      // notifyListeners(), поэтому экран профиля перерисуется сам.
      context.go('/main/profile');
    } else {
      showErrorSnackBar(
        context,
        _viewModel.errorMessage ??
            'Не удалось сохранить профиль. Проверьте данные и попробуйте ещё раз.',
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
                    // Нижний safe-area: кнопка «Сохранить» не под home-indicator.
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 16 + MediaQuery.viewPaddingOf(context).bottom,
                    ),
                    children: [
                      PassportField(
                    controller: _passportController,
                    // Отключаем вставку/копирование из буфера обмена (ТЗ).
                    enableInteractiveSelection: false,
                    contextMenuBuilder: (_, __) => const SizedBox.shrink(),
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
                    readOnly: true,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Телефон (без +7)',
                      hintText: '9001234567',
                      prefixIcon: Icon(Icons.phone_outlined),
                      suffixIcon: Icon(Icons.lock_outline),
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
