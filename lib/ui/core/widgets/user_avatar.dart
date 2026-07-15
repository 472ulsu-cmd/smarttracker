import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';

/// Круглый аватар: base64-фото или инициалы на оранжевом фоне.
///
/// `avatar` — строка вида `data:image/jpeg;base64,...` или чистый base64,
/// либо URL (http/https). Для base64 декодируется и показывается через
/// [Image.memory].
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.avatar,
    this.initials = '',
    this.radius = 28,
  });

  final String? avatar;
  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final label = initials.isNotEmpty
        ? 'Аватар пользователя $initials'
        : 'Аватар пользователя';
    return Semantics(
      label: label,
      child: _buildAvatar(),
    );
  }

  Widget _buildAvatar() {
    // Декодируем base64-аватар, если есть.
    final bytes = _decodeAvatar(avatar);
    if (bytes != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: BrandColors.primary,
        child: ClipOval(
          child: Image.memory(
            bytes,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _initialsAvatar(),
          ),
        ),
      );
    }
    // URL-аватар (на будущее).
    if (avatar != null && avatar!.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(avatar!),
        backgroundColor: BrandColors.primary,
      );
    }
    return _initialsAvatar();
  }

  Widget _initialsAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: BrandColors.primary,
      child: Text(
        initials.isNotEmpty ? initials : '?',
        style: AppTextStyles.titleLarge.copyWith(color: BrandColors.white),
      ),
    );
  }

  /// Кеш декодированных байтов: аватар (8 МБ base64) декодируем один раз.
  /// Ключ — длина строки (достаточно уникальна для фото одного профиля).
  static int? _cachedKey;
  static Uint8List? _cachedBytes;

  /// Декодирование base64 из data-URL или «голой» base64-строки.
  /// Результат кешируется (аватар из API весит ~8 МБ, декодировать при
  /// каждом build — дорого).
  static Uint8List? _decodeAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    // Возвращаем кеш, если строка та же (по длине + началу).
    final key = avatar.length;
    if (_cachedKey == key && _cachedBytes != null) return _cachedBytes;

    var raw = avatar;
    // Обрезаем префикс data:image/...;base64,
    final commaIdx = raw.indexOf(',');
    if (raw.startsWith('data:') && commaIdx >= 0) {
      raw = raw.substring(commaIdx + 1);
    }
    // Не base64 (например, http-ссылка) — пропускаем.
    if (raw.startsWith('http')) return null;
    try {
      final bytes = base64Decode(raw);
      _cachedKey = key;
      _cachedBytes = bytes;
      return bytes;
    } catch (_) {
      return null;
    }
  }
}
