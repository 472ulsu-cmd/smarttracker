import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smarttracker/ui/features/legal/agreement_content.dart';

void main() {
  group('parseAgreementInline', () {
    test('разбирает жирный текст и ссылки', () {
      final spans = parseAgreementInline(
        'Принимая **Соглашение**, вы соглашаетесь с '
        '[Политикой конфиденциальности](https://example.com/policy.pdf).',
      );
      expect(spans, hasLength(5));
      expect(spans[0].text, 'Принимая ');
      expect(spans[1].text, 'Соглашение');
      expect(spans[1].bold, isTrue);
      expect(spans[3].text, 'Политикой конфиденциальности');
      expect(spans[3].url, 'https://example.com/policy.pdf');
      expect(spans[4].text, '.');
    });

    test('текст без разметки возвращается одним спаном', () {
      final spans = parseAgreementInline('Обычный абзац');
      expect(spans, hasLength(1));
      expect(spans.single.bold, isFalse);
      expect(spans.single.url, isNull);
    });
  });

  group('parseAgreement', () {
    test('разбирает структуру документа', () {
      final blocks = parseAgreement('''
# ПОЛЬЗОВАТЕЛЬСКОЕ СОГЛАШЕНИЕ

**мобильного приложения «Умный Водитель»**

---

## 1. Общие положения

1.1. Настоящее Соглашение определяет условия использования.

1.2. Вторая строка пункта.

- первый маркер;
- второй **жирный** маркер.

## 2. Предмет

> Текст наглядного уведомления.
''');

      expect(blocks[0], isA<AgreementHeading>());
      expect((blocks[0] as AgreementHeading).level, 1);

      // Подзаголовок — абзац с жирным спаном.
      expect(blocks[1], isA<AgreementParagraph>());
      expect(
        (blocks[1] as AgreementParagraph).spans.single.bold,
        isTrue,
      );

      expect(blocks[2], isA<AgreementDivider>());

      final h2 = blocks[3] as AgreementHeading;
      expect(h2.level, 2);
      expect(h2.text, '1. Общие положения');

      // Пункты 1.1 и 1.2 — два отдельных абзаца (разделены пустой строкой).
      expect(blocks[4], isA<AgreementParagraph>());
      expect(blocks[5], isA<AgreementParagraph>());

      final list = blocks[6] as AgreementBulletList;
      expect(list.items, hasLength(2));
      expect(list.items[1].any((s) => s.bold && s.text == 'жирный'), isTrue);

      expect((blocks[7] as AgreementHeading).text, '2. Предмет');

      final quote = blocks[8] as AgreementQuote;
      expect(quote.spans.single.text, 'Текст наглядного уведомления.');
    });

    test('многострочный абзац склеивается в один блок', () {
      final blocks = parseAgreement('Первая строка\nвторая строка');
      expect(blocks, hasLength(1));
      final paragraph = blocks.single as AgreementParagraph;
      expect(paragraph.spans.single.text, 'Первая строка вторая строка');
    });

    test('реальный документ разбирается без потерь разделов', () {
      // Ключевые признаки актуальной редакции USER_AGREEMENT.md.
      final source = '''
## 4. Геолокация: согласие на отслеживание и использование координат

4.1. **Отслеживание геопозиции — обязательное условие работы Приложения.**

### Приложение А. Текст наглядного уведомления

> Приложение собирает данные о местоположении.
''';
      final blocks = parseAgreement(source);
      expect(
        blocks.whereType<AgreementHeading>().map((h) => h.level),
        containsAllInOrder([2, 3]),
      );
      expect(blocks.whereType<AgreementQuote>(), hasLength(1));
    });

    test('prominent disclosure на экране геолокации совпадает с Приложением А',
        () {
      // Охранный тест против рассинхрона: LegalTexts.locationDisclosure —
      // единый источник для location_permission_screen, и он обязан
      // дословно входить в текст документа (п. 4.10 соглашения).
      // В md ключевая фраза выделена **жирным** — нормализуем разметку.
      final source = File('assets/legal/user_agreement.md').readAsStringSync();
      final plain = source.replaceAll('**', '');
      expect(
        plain.contains(LegalTexts.locationDisclosure),
        isTrue,
        reason: 'Приложение А соглашения расходится с '
            'LegalTexts.locationDisclosure — синхронизируйте формулировки',
      );
      expect(
        plain.contains(LegalTexts.locationDisclosureEmphasis),
        isTrue,
        reason: 'В документе нет ключевой фразы про фоновой сбор',
      );
    });
  });
}
