import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/service_locator.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../legal/agreement_content.dart';
import '../view_models/location_permission_view_model.dart';

/// Экран запроса разрешения на геолокацию «Всегда».
///
/// Показывается после входа, если разрешение ещё не выдано.
/// Без разрешения работа в приложении блокируется — кнопка «Пропустить»
/// отсутствует, выход только через закрытие приложения.
class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with WidgetsBindingObserver {
  late final LocationPermissionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<LocationPermissionViewModel>();
    _viewModel.addListener(_onChanged);
    WidgetsBinding.instance.addObserver(this);
    // При заходе на экран (сразу после логина) проверяем разрешение.
    // Если уже выдано — сразу пускаем в приложение, иначе показываем UI.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.check();
      if (!mounted) return;
      if (_viewModel.isGranted) {
        context.go('/main/orders');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.removeListener(_onChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // При возврате из системных настроек — перепроверяем разрешение.
    if (state == AppLifecycleState.resumed) {
      _viewModel.check().then((_) {
        if (_viewModel.isGranted && mounted) {
          context.go('/main/orders');
        }
      });
    }
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _request() async {
    final granted = await _viewModel.request();
    if (granted && mounted) {
      // Разрешение получено — пускаем в приложение.
      context.go('/main/orders');
    }
  }

  Future<void> _openSettings() async {
    await _viewModel.openAppSettings();
    // После возврата из настроек — перепроверим.
    await _viewModel.check();
    if (_viewModel.isGranted && mounted) {
      context.go('/main/orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _viewModel.isRequesting || _viewModel.isOpeningSettings;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: BrandColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded,
                            size: 48, color: BrandColors.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Доступ к геолокации',
                        style: AppTextStyles.headlineLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Наглядное уведомление о фоновой геолокации
                      // (prominent disclosure, Приложение А соглашения).
                      // Текст единый с документом — из LegalTexts.
                      const _DisclosureText(),
                      const SizedBox(height: 8),
                      Text(
                        'В системном диалоге выберите «Разрешать всегда».',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: BrandColors.grayDark),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Без разрешения геолокации работа в приложении невозможна.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: BrandColors.error),
                      ),
                      if (_viewModel.errorMessage != null &&
                          _viewModel.status !=
                              LocationPermissionStatus.unknown) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: BrandColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(BrandRadius.sm),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  size: 20, color: BrandColors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _viewModel.errorMessage!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: BrandColors.error),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isBusy ? null : _request,
                          child: _viewModel.isRequesting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: BrandColors.white,
                                  ),
                                )
                              : const Text('Разрешить доступ'),
                        ),
                      ),
                      if (_viewModel.status ==
                          LocationPermissionStatus.denied) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isBusy ? null : _openSettings,
                            icon: const Icon(Icons.settings_outlined),
                            label: const Text('Открыть настройки'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        'Чтобы закрыть приложение без разрешения, '
                        'нажмите кнопку «Назад».',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption
                            .copyWith(color: BrandColors.grayDark),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Наглядное уведомление о фоновой геолокации (Приложение А соглашения).
///
/// Текст единый с документом: берётся из [LegalTexts.locationDisclosure],
/// ключевая фраза [LegalTexts.locationDisclosureEmphasis] выделяется жирным —
/// как `**...**` в md. Длинный юридический абзац выравнивается влево:
/// центрированный многострочный текст читается хуже.
class _DisclosureText extends StatelessWidget {
  const _DisclosureText();

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.bodyMedium;
    final parts = LegalTexts.locationDisclosure
        .split(LegalTexts.locationDisclosureEmphasis);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: LegalTexts.locationDisclosureEmphasis,
            style: base.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: parts.last),
        ],
      ),
    );
  }
}
