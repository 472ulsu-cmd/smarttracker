/// Контент пользовательского соглашения: модель блоков и парсер
/// markdown-подмножества из `assets/legal/user_agreement.md`.
///
/// Парсер намеренно чистый Dart (без Flutter) — тестируется без биндинга.
/// Единственный источник правды о тексте — md-файл в assets, чтобы
/// юридическая редакция обновлялась без правок кода.
library;

/// Внешние юридические ссылки, упоминаемые в соглашении.
class LegalLinks {
  LegalLinks._();

  /// Политика конфиденциальности и обработки персональных данных (PDF).
  static const privacyPolicy =
      'https://cargo.b2b-logist.com/upload/user_policy_personal_data.pdf';
}

/// Юридические формулировки, показываемые за пределами экрана соглашения.
///
/// ВАЖНО: тексты обязаны дословно совпадать с
/// `assets/legal/user_agreement.md` — синхронизацию охраняет тест
/// `agreement_content_test.dart`.
class LegalTexts {
  LegalTexts._();

  /// Ключевая фраза наглядного уведомления — выделяется жирным
  /// и на экране геолокации, и в Приложении А (`**...**` в md).
  static const locationDisclosureEmphasis =
      'в фоновом режиме, даже когда приложение закрыто или не используется';

  /// Наглядное уведомление о фоновой геолокации (Приложение А соглашения).
  /// Показывается на экране запроса разрешения до системного диалога —
  /// требование Google Play prominent disclosure и п. 4.10 соглашения.
  static const locationDisclosure =
      'Приложение «Умный Водитель» собирает данные о местоположении вашего '
      'устройства $locationDisclosureEmphasis. Это необходимо для '
      'подтверждения выполнения заявок, контроля маршрутов перевозки и '
      'расчёта логистических показателей. Собранные координаты передаются '
      'в ООО «Умная Логистика» и используются в её продуктах и сервисах. '
      'Продолжая работу, вы соглашаетесь с Пользовательским соглашением '
      'и Политикой конфиденциальности.';
}

/// Инлайн-фрагмент текста: обычный, жирный или ссылка.
class AgreementSpan {
  const AgreementSpan(this.text, {this.bold = false, this.url});

  final String text;
  final bool bold;

  /// Если задан — фрагмент является ссылкой.
  final String? url;
}

/// Блок верхнего уровня документа.
sealed class AgreementBlock {
  const AgreementBlock();
}

/// Заголовок раздела (уровень 1 — название документа, 2 — раздел, 3 — подраздел).
class AgreementHeading extends AgreementBlock {
  const AgreementHeading(this.level, this.text);

  final int level;
  final String text;
}

/// Абзац текста.
class AgreementParagraph extends AgreementBlock {
  const AgreementParagraph(this.spans);

  final List<AgreementSpan> spans;
}

/// Маркированный список.
class AgreementBulletList extends AgreementBlock {
  const AgreementBulletList(this.items);

  final List<List<AgreementSpan>> items;
}

/// Выделенная цитата (prominent disclosure в приложении А).
class AgreementQuote extends AgreementBlock {
  const AgreementQuote(this.spans);

  final List<AgreementSpan> spans;
}

/// Горизонтальный разделитель.
class AgreementDivider extends AgreementBlock {
  const AgreementDivider();
}

/// Разбирает инлайн-разметку: `**жирный**` и `[текст](url)`.
List<AgreementSpan> parseAgreementInline(String text) {
  final pattern = RegExp(r'\*\*(.+?)\*\*|\[([^\]]+)\]\(([^)\s]+)\)');
  final spans = <AgreementSpan>[];
  var offset = 0;
  for (final match in pattern.allMatches(text)) {
    if (match.start > offset) {
      spans.add(AgreementSpan(text.substring(offset, match.start)));
    }
    final bold = match.group(1);
    if (bold != null) {
      spans.add(AgreementSpan(bold, bold: true));
    } else {
      spans.add(AgreementSpan(match.group(2)!, url: match.group(3)));
    }
    offset = match.end;
  }
  if (offset < text.length) {
    spans.add(AgreementSpan(text.substring(offset)));
  }
  return spans;
}

/// Разбирает markdown-подмножество соглашения в блоки.
///
/// Поддерживается ровно то, что использует документ: заголовки `#`–`###`,
/// абзацы, списки `- `, цитаты `> `, разделители `---` и инлайн-разметка.
List<AgreementBlock> parseAgreement(String source) {
  final blocks = <AgreementBlock>[];
  final paragraphLines = <String>[];
  final quoteLines = <String>[];
  List<List<AgreementSpan>>? bullets;

  void flushParagraph() {
    if (paragraphLines.isEmpty) return;
    blocks.add(AgreementParagraph(
      parseAgreementInline(paragraphLines.join(' ').trim()),
    ));
    paragraphLines.clear();
  }

  void flushQuote() {
    if (quoteLines.isEmpty) return;
    blocks.add(AgreementQuote(
      parseAgreementInline(quoteLines.join(' ').trim()),
    ));
    quoteLines.clear();
  }

  void flushBullets() {
    final list = bullets;
    if (list == null) return;
    blocks.add(AgreementBulletList(list));
    bullets = null;
  }

  void flushAll() {
    flushParagraph();
    flushQuote();
    flushBullets();
  }

  for (final rawLine in source.split('\n')) {
    final line = rawLine.trimRight();
    final trimmed = line.trim();

    if (trimmed.isEmpty) {
      flushAll();
      continue;
    }
    if (trimmed == '---') {
      flushAll();
      blocks.add(const AgreementDivider());
      continue;
    }
    final heading = RegExp(r'^(#{1,3})\s+(.*)$').firstMatch(trimmed);
    if (heading != null) {
      flushAll();
      blocks.add(AgreementHeading(
        heading.group(1)!.length,
        heading.group(2)!.trim(),
      ));
      continue;
    }
    if (trimmed.startsWith('>')) {
      flushParagraph();
      flushBullets();
      quoteLines.add(trimmed.substring(1).trim());
      continue;
    }
    if (trimmed.startsWith('- ')) {
      flushParagraph();
      flushQuote();
      (bullets ??= []).add(parseAgreementInline(trimmed.substring(2).trim()));
      continue;
    }
    flushQuote();
    flushBullets();
    paragraphLines.add(trimmed);
  }
  flushAll();
  return blocks;
}
