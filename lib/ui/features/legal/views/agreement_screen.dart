import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../agreement_content.dart';

/// Экран «Пользовательское соглашение».
///
/// Текст загружается из bundled `assets/legal/user_agreement.md` —
/// работает офлайн и обновляется вместе с редакцией документа.
/// Для длинного юридического текста есть «Содержание» с прокруткой
/// к разделам; ссылки (Политика конфиденциальности) открываются во
/// внешнем браузере.
class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  static const _assetPath = 'assets/legal/user_agreement.md';

  /// Готовые виджеты контента; строятся один раз после загрузки,
  /// чтобы recognizer'ы ссылок не пересоздавались на каждый build.
  List<Widget>? _content;
  final _recognizers = <TapGestureRecognizer>[];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final source = await rootBundle.loadString(_assetPath);
      if (!mounted) return;
      setState(() {
        _content = _buildContent(parseAgreement(source));
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Не удалось загрузить текст соглашения');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  /// Собирает инлайн-спаны в TextSpan'ы; ссылки — primaryText с подчёркиванием
  /// (не только цветом — требование доступности).
  List<TextSpan> _linkify(List<AgreementSpan> spans, TextStyle base) {
    return [
      for (final span in spans)
        if (span.url != null)
          TextSpan(
            text: span.text,
            style: base.copyWith(
              color: BrandColors.primaryText,
              decoration: TextDecoration.underline,
              decorationColor: BrandColors.primaryText,
              fontWeight: span.bold ? FontWeight.w600 : null,
            ),
            recognizer: _linkRecognizer(span.url!),
          )
        else
          TextSpan(
            text: span.text,
            style: span.bold ? base.copyWith(fontWeight: FontWeight.w600) : base,
          ),
    ];
  }

  TapGestureRecognizer _linkRecognizer(String url) {
    final recognizer = TapGestureRecognizer()..onTap = () => _openUrl(url);
    _recognizers.add(recognizer);
    return recognizer;
  }

  List<Widget> _buildContent(List<AgreementBlock> blocks) {
    final widgets = <Widget>[];
    // Якоря разделов второго уровня для «Содержания».
    final sectionAnchors = <String, GlobalKey>{};
    for (final block in blocks) {
      if (block is AgreementHeading && block.level == 2) {
        sectionAnchors[block.text] = GlobalKey();
      }
    }

    var tocInserted = false;
    for (final block in blocks) {
      // «Содержание» вставляем перед первым разделом.
      if (!tocInserted &&
          block is AgreementHeading &&
          block.level == 2 &&
          sectionAnchors.length > 1) {
        tocInserted = true;
        widgets.add(_TableOfContents(
          entries: [
            for (final entry in sectionAnchors.entries)
              MapEntry(
                entry.key,
                () => _scrollTo(entry.value),
              ),
          ],
        ));
        widgets.add(const SizedBox(height: 24));
      }
      widgets.add(_renderBlock(block, sectionAnchors));
    }
    // Нижний отступ, чтобы последний раздел не лип к краю.
    widgets.add(const SizedBox(height: 32));
    return widgets;
  }

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    // Уважаем reduced motion: без анимации — мгновенный переход.
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    Scrollable.ensureVisible(
      target,
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      alignment: 0.05,
    );
  }

  Widget _renderBlock(
    AgreementBlock block,
    Map<String, GlobalKey> sectionAnchors,
  ) {
    switch (block) {
      case AgreementHeading(level: 1, text: final text):
        return Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(text, style: AppTextStyles.headlineMedium),
          ),
        );
      case AgreementHeading(level: 2, text: final text):
        return Semantics(
          header: true,
          child: Padding(
            key: sectionAnchors[text],
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(text, style: AppTextStyles.titleLarge),
          ),
        );
      case AgreementHeading(text: final text):
        return Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(text, style: AppTextStyles.titleMedium),
          ),
        );
      case AgreementParagraph(spans: final spans):
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text.rich(
            TextSpan(children: _linkify(spans, AppTextStyles.bodyMedium)),
          ),
        );
      case AgreementBulletList(items: final items):
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: AppTextStyles.bodyMedium),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: _linkify(item, AppTextStyles.bodyMedium),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case AgreementQuote(spans: final spans):
        // Плоская карточка по Border-Not-Shadow: белая, рамка gray-lighter.
        // Текст — graphite: это самое важное уведомление документа
        // (prominent disclosure), оно не должно выглядеть вторичным.
        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BrandColors.white,
            border: Border.all(color: BrandColors.grayLighter),
            borderRadius: BorderRadius.circular(BrandRadius.md),
          ),
          child: Text.rich(
            TextSpan(
              children: _linkify(spans, AppTextStyles.bodyMedium),
            ),
          ),
        );
      case AgreementDivider():
        return const Divider(height: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пользовательское соглашение')),
      body: SafeArea(
        child: switch ((_content, _error)) {
          (final content?, _) => Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Юридический текст разрешено выделять и копировать.
                child: SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content,
                  ),
                ),
              ),
            ),
          (_, final error?) => _ErrorState(message: error, onRetry: _load),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

/// «Содержание» — навигация по разделам длинного документа.
class _TableOfContents extends StatelessWidget {
  const _TableOfContents({required this.entries});

  final List<MapEntry<String, VoidCallback>> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        border: Border.all(color: BrandColors.grayLighter),
        borderRadius: BorderRadius.circular(BrandRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Содержание',
            style: AppTextStyles.labelMedium
                .copyWith(color: BrandColors.grayDark),
          ),
          const SizedBox(height: 4),
          for (final entry in entries)
            InkWell(
              onTap: entry.value,
              borderRadius: BorderRadius.circular(BrandRadius.sm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: BrandColors.primaryText),
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: BrandColors.grayMid, size: 20),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
