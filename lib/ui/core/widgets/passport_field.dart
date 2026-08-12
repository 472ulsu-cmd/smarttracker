import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Поле ввода серии и номера паспорта с маской «4510 712345».
///
/// Общий виджет для всех экранов, где вводится паспорт: вход, регистрация,
/// восстановление пароля, редактирование профиля. Группирует серию (4 цифры)
/// и номер (6 цифр) пробелом — так они опознаются с одного взгляда и водитель
/// не пересчитывает 10 цифр вслепую.
///
/// **Важно про значение:** визуально поле содержит пробел маски, а слой данных
/// (ViewModel, репозиторий, сервер) ждёт ровно 10 цифр без разделителей.
/// Поэтому:
/// * [onChanged] прокидывает уже очищенное значение (только цифры);
/// * для ручного извлечения цифр используйте
///   `controller.text.replaceAll(RegExp(r'\D'), '')`;
/// * при программной инициализации (`controller.text = ...`) форматтер не
///   срабатывает — форматируйте стартовое значение через
///   [PassportMaskFormatter.formatStatic].
class PassportField extends StatelessWidget {
  const PassportField({
    super.key,
    required this.controller,
    this.onChanged,
    this.autofillHints,
    this.textInputAction,
    this.autofocus = false,
    this.enableInteractiveSelection = true,
    this.contextMenuBuilder,
    this.hintText = '4510 712345',
    this.validator,
  });

  final TextEditingController controller;

  /// Колбэк изменения поля; получает значение, очищенное от пробела маски
  /// (только цифры). На входе/выходе в слой данных всегда идут 10 цифр.
  final ValueChanged<String>? onChanged;

  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enableInteractiveSelection;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final String hintText;

  /// Валидатор. По умолчанию требует ровно 10 цифр (после удаления нецифров).
  final FormFieldValidator<String>? validator;

  static String? _defaultValidator(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.length != 10) {
      return 'Введите 10 цифр серии и номера паспорта';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: textInputAction,
      autofocus: autofocus,
      autofillHints: autofillHints,
      enableInteractiveSelection: enableInteractiveSelection,
      contextMenuBuilder: contextMenuBuilder,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11), // 10 цифр + пробел маски
        PassportMaskFormatter(),
      ],
      maxLength: 11,
      decoration: InputDecoration(
        labelText: 'Серия и номер паспорта',
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.badge_outlined),
      ),
      validator: validator ?? _defaultValidator,
      onChanged: onChanged == null
          ? null
          : (value) => onChanged!(value.replaceAll(RegExp(r'\D'), '')),
    );
  }
}

/// Форматтер поля паспорта: группирует «серия 4 цифры» + «номер 6 цифр»
/// пробелом — `4510 712345`. Хранит логику на сырых цифрах: при любой правке
/// берёт из значения только цифры и заново расставляет один пробел после 4-й.
class PassportMaskFormatter extends TextInputFormatter {
  const PassportMaskFormatter();

  /// Регулярка для удаления из значения всех нецифровых символов (включая
  /// пробел маски). Вынесена как константа для переиспользования.
  static final RegExp nonDigits = RegExp(r'\D');

  /// Возвращает отформатированное значение `4510 712345` для произвольной
  /// строки с цифрами. Применяет ту же логику, что и [formatEditUpdate],
  /// но без `TextEditingValue` — удобно для программной инициализации поля.
  static String formatStatic(String input) {
    final digits = input.replaceAll(nonDigits, '');
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 4) buffer.write(' ');
      buffer.write(capped[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = formatStatic(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
