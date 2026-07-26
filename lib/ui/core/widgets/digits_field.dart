import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Поле ввода цифровых значений: SMS-коды, паспорта, телефоны.
///
/// Общий виджет для auth-флоу (регистрация/восстановление) и редактирования
/// профиля. Поддерживает внешний и внутренний контроллеры: при смене позиции
/// в дереве (например, шаг stepper'а) корректно переключает слушателя, не
/// теряя ввод.
///
/// Особенности:
/// * только цифры ([FilteringTextInputFormatter.digitsOnly]);
/// * ограничение длины через [length];
/// * кнопка очистки, когда поле не пусто;
/// * `autofillHints` — для подстановки одноразового кода из SMS на iOS/Android.
class DigitsField extends StatefulWidget {
  const DigitsField({
    super.key,
    required this.label,
    required this.length,
    required this.onChanged,
    this.controller,
    this.center = false,
    this.autofocus = false,
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
  final bool autofocus;
  final List<String>? autofillHints;
  final IconData? prefixIcon;
  final String? hintText;
  final TextInputType keyboardType;

  @override
  State<DigitsField> createState() => _DigitsFieldState();
}

class _DigitsFieldState extends State<DigitsField> {
  TextEditingController? _createdController;

  /// Актуальный контроллер: внешний (из виджета) или внутренний (если внешний
  /// не передан). Важно брать его динамически — при смене шага stepper'а
  /// [DigitsField] на той же позиции дерева получает новый `widget.controller`,
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
  void didUpdateWidget(covariant DigitsField oldWidget) {
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
      autofocus: widget.autofocus,
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
