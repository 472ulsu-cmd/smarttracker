import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Безопасное хранилище сессии (токена).
///
/// Использует `flutter_secure_storage` с `encryptedSharedPreferences: true`
/// (Keystore на Android, Keychain на iOS).
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static const _keyToken = 'auth_token';

  /// Сохранить токен аутентификации.
  Future<void> saveToken(String token) => _storage.write(key: _keyToken, value: token);

  /// Прочитать токен (null, если отсутствует).
  Future<String?> readToken() => _storage.read(key: _keyToken);

  /// Удалить токен (выход / очистка сессии).
  Future<void> deleteToken() => _storage.delete(key: _keyToken);
}
