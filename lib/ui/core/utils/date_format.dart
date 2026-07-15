/// Утилиты форматирования дат и времени для UI.
class DateFormatUtil {
  DateFormatUtil._();

  /// Дата в формате дд.мм.гггг.
  /// Принимает строку вида "2026-07-13" или ISO.
  static String date(String input) {
    if (input.isEmpty) return '';
    try {
      final dt = DateTime.parse(_normalize(input));
      String two(int v) => v.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year}';
    } catch (_) {
      return input;
    }
  }

  /// Время без секунд из строки "08:00:00" → "08:00".
  static String time(String input) {
    if (input.isEmpty) return '';
    final parts = input.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return input;
  }

  /// Дата и время: дд.мм.гггг ЧЧ:ММ (без секунд).
  /// Принимает ISO или "YYYY-MM-DD HH:MM:SS".
  static String dateTime(String input) {
    if (input.isEmpty) return '';
    try {
      final dt = DateTime.parse(_normalize(input)).toLocal();
      String two(int v) => v.toString().padLeft(2, '0');
      return '${two(dt.day)}.${two(dt.month)}.${dt.year} '
          '${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return input;
    }
  }

  /// Нормализация под DateTime.parse: "YYYY-MM-DD HH:MM:SS" → "YYYY-MM-DDTHH:MM:SS".
  static String _normalize(String input) {
    if (input.length >= 11 && input[10] == ' ') {
      return '${input.substring(0, 10)}T${input.substring(11)}';
    }
    return input;
  }
}
