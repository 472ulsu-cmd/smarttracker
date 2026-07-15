/// Нормализует строку телефона для `tel:`-ссылки.
///
/// - Убирает все не-цифры.
/// - 8XXXXXXXXXX → +7XXXXXXXXXX
/// - 7XXXXXXXXXX → +7XXXXXXXXXX
/// - Всё остальное возвращает как есть (только цифры).
String normalizePhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('8') && digits.length == 11) {
    return '+7${digits.substring(1)}';
  }
  if (digits.startsWith('7') && digits.length == 11) {
    return '+$digits';
  }
  return digits;
}
