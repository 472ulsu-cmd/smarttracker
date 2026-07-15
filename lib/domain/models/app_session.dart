import 'user.dart';

/// Доменная модель сессии: токен аутентификации + текущий пользователь.
class AppSession {
  const AppSession({required this.token, required this.user});

  final String token;
  final User user;
}
