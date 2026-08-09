import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';

/// Круглый аватар: base64-фото или инициалы на оранжевом фоне.
///
/// `avatar` — строка вида `data:image/jpeg;base64,...` или чистый base64,
/// либо URL (http/https). Для base64 декодируется и показывается через
/// [Image.memory].
///
/// Base64-декодирование (~8 МБ из API) выполняется в фоновой изоляте и
/// кешируется по содержимому: виджет сам перерисовывается, когда decode
/// завершается, — вызывающему коду не нужно слушать результат.
class UserAvatar extends StatefulWidget {
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
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  void initState() {
    super.initState();
    _ensureDecoded();
  }

  @override
  void didUpdateWidget(covariant UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.avatar != widget.avatar) _ensureDecoded();
  }

  /// Запускает асинхронный decode при cache miss и перерисовывает виджет,
  /// когда байты готовы. Если байты уже в кеше для этой же строки — ничего
  /// не делает.
  void _ensureDecoded() {
    final source = widget.avatar;
    if (source == null || source.isEmpty) return;
    if (_lastDecoded != null && _lastDecoded!.source == source) return;
    decodeAvatarBytes(source).then((bytes) {
      if (bytes != null) {
        _lastDecoded = _AvatarCache(source, bytes);
        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.initials.isNotEmpty
        ? 'Аватар пользователя ${widget.initials}'
        : 'Аватар пользователя';
    return Semantics(
      label: label,
      child: _buildAvatar(),
    );
  }

  Widget _buildAvatar() {
    // URL-аватар: отдаём NetworkImage, без base64-пути.
    if (widget.avatar != null && widget.avatar!.startsWith('http')) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundImage: NetworkImage(widget.avatar!),
        backgroundColor: BrandColors.primary,
      );
    }
    final source = widget.avatar;
    final bytes = (source != null &&
            _lastDecoded != null &&
            _lastDecoded!.source == source)
        ? _lastDecoded!.bytes
        : null;
    if (bytes != null) {
      // cacheWidth — в ФИЗИЧЕСКИХ пикселях (передаётся в ResizeImage-декодер).
      // Логический диаметр × dpr: иначе на 3x-экране битмап даунсэмплится
      // в треть разрешения и аватар мылится. devicePixelRatioOf — селективный
      // геттер, не триггерит rebuild при смене несвязанных MediaQuery-полей.
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final cacheSize = (widget.radius * 2 * dpr).round();
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: BrandColors.primary,
        child: ClipOval(
          child: Image.memory(
            bytes,
            cacheWidth: cacheSize,
            width: widget.radius * 2,
            height: widget.radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _initialsAvatar(),
          ),
        ),
      );
    }
    return _initialsAvatar();
  }

  Widget _initialsAvatar() {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: BrandColors.primary,
      child: Text(
        widget.initials.isNotEmpty ? widget.initials : '?',
        style: AppTextStyles.titleLarge.copyWith(color: BrandColors.white),
      ),
    );
  }
}

/// Кеш декодированного аватара. Аватар из API — ~8 МБ base64; декодировать
/// его синхронно в build() блокирует UI-изоляту, поэтому результат
/// вычисляется асинхронно (через [decodeAvatarBytes]) и кешируется по
/// **исходной строке** (`==`). Кеш хранит одну запись (последний успешный
/// аватар) — именно поэтому ключом должна быть вся строка, а не её длина
/// или префикс: иначе новое фото того же разрешения коллидирует со старым,
/// и водитель видит устаревший аватар.
_AvatarCache? _lastDecoded;

/// Отрезает префикс `data:image/...;base64,`, оставляя чистую base64-часть.
String _stripDataPrefix(String avatar) {
  if (!avatar.startsWith('data:')) return avatar;
  final comma = avatar.indexOf(',');
  return comma >= 0 ? avatar.substring(comma + 1) : avatar;
}

/// Декодирует base64-аватар в фоновой изоляте.
///
/// Принимает исходную строку (с data:-префиксом или без). Возвращает null
/// для http-ссылок и при ошибке декодирования.
Future<Uint8List?> decodeAvatarBytes(String avatar) async {
  final raw = _stripDataPrefix(avatar);
  if (raw.startsWith('http')) return null;
  try {
    // compute() выполняет функцию в отдельной изоляте — decode ~8 МБ base64
    // больше не блокирует отрисовку. Байты передаются по ссылке (Uint8List),
    // без копирования.
    return await compute(base64Decode, raw);
  } catch (_) {
    return null;
  }
}

/// Запись кеша декодированного аватара. Ключ — полная source-строка.
class _AvatarCache {
  const _AvatarCache(this.source, this.bytes);
  final String source;
  final Uint8List bytes;
}
