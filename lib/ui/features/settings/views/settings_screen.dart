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
            // Нижний safe-area: контент не под home-indicator.
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.viewPaddingOf(context).bottom,
            ),
            children: [
              Text(
                'Уведомления',
                style: AppTextStyles.caption.copyWith(color: BrandColors.grayDark),
              ),
              const SizedBox(height: 8),
              BrandCard(
                padding: EdgeInsets.zero,
                // SwitchListTile.adaptive: тап по всей строке переключает
                // значение (а не только по «ушу» Switch), и на iOS рисуется
                // нативный Cupertino-переключатель, на Android — Material.
                child: SwitchListTile.adaptive(
                  value: _settings.pushEnabled,
                  onChanged: (v) => _settings.setPushEnabled(v),
                  title: Text(
                    'Получать push-уведомления',
                    style: AppTextStyles.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondary: const Icon(Icons.notifications_active_outlined,
                      color: BrandColors.primary),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
