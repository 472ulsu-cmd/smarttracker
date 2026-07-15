/// Чистая доменная модель пользователя (водителя).
///
/// Не зависит от формата API. Репозиторий преобразует API-модель в эту.
class User {
  const User({
    required this.id,
    required this.login,
    this.name = '',
    this.secondName = '',
    this.surname = '',
    this.phone = '',
    this.phoneCode = 1,
    this.avatar = '',
  });

  final int id;
  final String login;
  final String name;
  final String secondName;
  final String surname;
  final String phone;
  final int phoneCode;
  final String avatar;

  /// Полное ФИО одной строкой (без лишних пробелов).
  String get fullName {
    final parts = [surname, name, secondName]
        .where((p) => p.trim().isNotEmpty)
        .map((p) => p.trim());
    return parts.join(' ');
  }

  /// Инициалы для аватара, например «ИИ».
  String get initials {
    final n = name.trim();
    final s = surname.trim();
    return ((s.isNotEmpty ? s[0] : '') + (n.isNotEmpty ? n[0] : ''))
        .toUpperCase();
  }

  /// Телефон в формате +7 (XXX) XXX-XX-XX.
  String get formattedPhone {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return '+7 $phone';
    final d = digits;
    return '+7 (${d.substring(0, 3)}) ${d.substring(3, 6)}-${d.substring(6, 8)}-${d.substring(8, 10)}';
  }

  User copyWith({
    int? id,
    String? login,
    String? name,
    String? secondName,
    String? surname,
    String? phone,
    int? phoneCode,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      login: login ?? this.login,
      name: name ?? this.name,
      secondName: secondName ?? this.secondName,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      phoneCode: phoneCode ?? this.phoneCode,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() => 'User($id, $login, $fullName)';
}
