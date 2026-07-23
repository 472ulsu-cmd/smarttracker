import 'package:flutter/material.dart';

import '../../../../config/service_locator.dart';
import '../../../../data/services/settings_service.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/brand_card.dart';

/// Экран настроек приложения.
///
/// Содержит пользовательские переключатели (например, push-уведомления).
/// Настройки хранятся локально через [SettingsService] (shared_preferences).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsService _settings;

  @override
  void initState() {
    super.initState();
    _settings = getIt<SettingsService>();
    _settings.addListener(_onChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListenableBuilder(
        listenable: _settings,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Уведомления',
                style: AppTextStyles.caption.copyWith(color: BrandColors.grayDark),
              ),
              const SizedBox(height: 8),
              BrandCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined,
                        color: BrandColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Получать push-уведомления',
                        style: AppTextStyles.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Switch(
                      value: _settings.pushEnabled,
                      activeThumbColor: BrandColors.primary,
                      onChanged: (v) => _settings.setPushEnabled(v),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
