import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_text_styles.dart';
import '../theme/brand_colors.dart';
import '../theme/brand_radius.dart';
import '../utils/phone_utils.dart';
import 'app_snack_bars.dart';

/// Кликабельная строка с номером телефона: по тапу открывает dialer (`tel:`).
///
/// Номер нормализуется через [normalizePhone]; при невозможности позвонить
/// показывает SnackBar с сообщением об ошибке.
class PhoneCallRow extends StatefulWidget {
  const PhoneCallRow({
    super.key,
    required this.phone,
    this.iconSize = 18,
    this.textStyle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// Номер телефона в любом формате.
  final String phone;

  /// Размер иконки трубки.
  final double iconSize;

  /// Базовый стиль текста номера (по умолчанию [AppTextStyles.bodyMedium]).
  final TextStyle? textStyle;

  /// Вертикальное выравнивание содержимого строки.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<PhoneCallRow> createState() => _PhoneCallRowState();
}

class _PhoneCallRowState extends State<PhoneCallRow> {
  bool _isCalling = false;

  Future<void> _call(BuildContext context) async {
    if (_isCalling) return;
    HapticFeedback.lightImpact();
    final normalized = normalizePhone(widget.phone);
    if (normalized.isEmpty) return;
    final uri = Uri.parse('tel:$normalized');

    setState(() => _isCalling = true);
    try {
      if (await canLaunchUrl(uri)) {
        try {
          await launchUrl(uri);
          return;
        } catch (_) {
          // Падение целевого приложения — показываем fallback ниже.
        }
      }
    } finally {
      if (mounted) setState(() => _isCalling = false);
    }

    if (context.mounted) {
      showErrorSnackBar(context, 'Не удалось позвонить. Попробуйте позже.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.textStyle ?? AppTextStyles.bodyMedium;
    return MergeSemantics(
      child: InkWell(
        onTap: _isCalling ? null : () => _call(context),
        borderRadius: BorderRadius.circular(BrandRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(
            crossAxisAlignment: widget.crossAxisAlignment,
            children: [
              Icon(Icons.phone_outlined,
                  size: widget.iconSize,
                  color: BrandColors.primary,
                  semanticLabel: 'Позвонить'),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.phone,
                  style: baseStyle.copyWith(
                    color: BrandColors.graphite,
                    decoration: TextDecoration.underline,
                    decorationColor: BrandColors.graphite,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
