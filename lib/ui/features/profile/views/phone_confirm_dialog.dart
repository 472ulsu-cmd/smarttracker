import 'package:flutter/material.dart';

import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/digits_field.dart';
import '../../../core/widgets/error_banner.dart';
import '../view_models/profile_view_model.dart';

/// Диалог подтверждения нового телефона SMS-кодом при смене номера в профиле.
///
/// Сервер требует подтверждения номера (`POST /user` с неподтверждённым
/// телефоном возвращает `code:-14 «The phone unconfirmed»`). Перед открытием
/// диалога экран уже отправил код через [ProfileViewModel.requestPhoneCode].
/// Здесь водитель вводит код → [ProfileViewModel.confirmPhoneAndSave]
/// проверяет код и сохраняет профиль.
///
/// Возвращает `true`, если профиль сохранён; `false`/`null` — отмена.
Future<bool?> showPhoneConfirmDialog(
  BuildContext context, {
  required String newPhone,
  required String login,
  required String name,
  required String secondName,
  required String surname,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PhoneConfirmDialog(
      newPhone: newPhone,
      login: login,
      name: name,
      secondName: secondName,
      surname: surname,
    ),
  );
}

class _PhoneConfirmDialog extends StatefulWidget {
  const _PhoneConfirmDialog({
    required this.newPhone,
    required this.login,
    required this.name,
    required this.secondName,
    required this.surname,
  });

  final String newPhone;
  final String login;
  final String name;
  final String secondName;
  final String surname;

  @override
  State<_PhoneConfirmDialog> createState() => _PhoneConfirmDialogState();
}

class _PhoneConfirmDialogState extends State<_PhoneConfirmDialog> {
  late final ProfileViewModel _viewModel;
  final _codeController = TextEditingController();
  String _code = '';

  /// Счётчик сбросов SMS-поля. При изменении ValueKey поле пересоздаётся
  /// полностью — это надёжно чистит автозаполнение ОС и кеш платформы
  /// при запросе нового кода или неверном вводе.
  int _smsFieldReset = 0;

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
    _codeController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  /// Форматированный номер для подсказки: +7 (XXX) XXX-XX-XX.
  String get _formattedPhone {
    final d = widget.newPhone;
    if (d.length != 10) return '+7 $d';
    return '+7 (${d.substring(0, 3)}) ${d.substring(3, 6)}-${d.substring(6, 8)}-${d.substring(8, 10)}';
  }

  void _clearSmsField() {
    _codeController.clear();
    _code = '';
    _smsFieldReset += 1;
  }

  Future<void> _confirm() async {
    if (_code.length != 4 || _viewModel.isVerifying) return;
    final ok = await _viewModel.confirmPhoneAndSave(
      code: _code,
      newPhone: widget.newPhone,
      login: widget.login,
      name: widget.name,
      secondName: widget.secondName,
      surname: widget.surname,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      // Код неверный — чистим поле, чтобы водитель ввёл заново.
      _clearSmsField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: BrandColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Подтвердите новый номер',
                    style: AppTextStyles.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Отмена',
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Мы отправили SMS-код на номер $_formattedPhone.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            const SizedBox(height: 16),
            DigitsField(
              key: ValueKey('sms-field-$_smsFieldReset'),
              label: 'SMS-код',
              length: 4,
              center: true,
              autofocus: true,
              autofillHints: const [AutofillHints.oneTimeCode],
              controller: _codeController,
              onChanged: (v) => _code = v,
            ),
            if (_viewModel.errorMessage != null) ...[
              const SizedBox(height: 12),
              ErrorBanner(message: _viewModel.errorMessage!),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: (_code.length == 4 && !_viewModel.isVerifying)
                  ? _confirm
                  : null,
              child: _viewModel.isVerifying
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: BrandColors.white,
                      ),
                    )
                  : const Text('Подтвердить'),
            ),
            const SizedBox(height: 4),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _viewModel.canResend
                  ? () async {
                      _clearSmsField();
                      await _viewModel.resendPhoneCode();
                    }
                  : null,
              child: Text(
                _viewModel.resendRemaining > 0
                    ? 'Отправить код повторно (${_viewModel.resendRemaining} с)'
                    : 'Отправить код повторно',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
