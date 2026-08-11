import 'dart:io' show Platform;

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
    // При возврате из системных настроек — перепроверяем и сервис, и разрешение:
    // пользователь мог включить геолокацию или выдать «Всегда».
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
    // Если сервис геолокации выключен на уровне ОС — отправляем в настройки
    // локации, иначе нативный диалог разрешения не покажется.
    final serviceEnabled = await _viewModel.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _viewModel.openLocationSettings();
      return;
    }
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

  /// Открывает системные настройки геолокации (включение сервиса).
  /// После возврата — перепроверяет сервис и разрешение.
  Future<void> _enableLocationService() async {
    await _viewModel.openLocationSettings();
    // После возврата из настроек — перепроверим (пользователь мог включить
    // геолокацию и/или выдать разрешение).
    await _viewModel.check();
    if (_viewModel.isGranted && mounted) {
      context.go('/main/orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _viewModel.isRequesting || _viewModel.isOpeningSettings;
    final serviceDisabled =
        _viewModel.status == LocationPermissionStatus.serviceDisabled;

    return PopScope(
      // Шлюз геолокации: без разрешения работа невозможна, поэтому системный
      // back/edge-swipe (iOS) не должен покидать экран — иначе заявленное
      // «выход только закрытием приложения» нарушается на iOS.
      canPop: false,
      child: Scaffold(
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
                        child: Icon(
                          serviceDisabled
                              ? Icons.location_disabled_rounded
                              : Icons.location_on_rounded,
                          size: 48,
                          // Disabled-состояние — это статус, не действие:
                          // не носит action-accent (One Accent Rule).
                          color: serviceDisabled
                              ? BrandColors.error
                              : BrandColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        serviceDisabled
                            ? 'Геолокация отключена'
                            : 'Доступ к геолокации',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      if (serviceDisabled) ...[
                        Text(
                          'Геолокация выключена в настройках телефона. '
                          'Включите её, чтобы приложение могло отслеживать '
                          'маршрут и координаты.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: BrandColors.grayDark),
                        ),
                      ] else ...[
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
                      ],
                      const SizedBox(height: 12),
                      Text(
                        // errorText (#B3261E, ≈6:1) вместо error (#D32F2F,
                        // 4.23:1 — провал AA). Это читаемый текст на светлом
                        // фоне — см. комментарий в brand_colors.dart:43-45.
                        'Без геолокации работа в приложении невозможна.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: BrandColors.errorText),
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
                                  // Сообщение об ошибке — читаемый текст:
                                  // используем AA-контрастный errorText.
                                  // maxLines убран: родитель SingleChildScrollView
                                  // поглощает рост текста при крупном масштабе.
                                  _viewModel.errorMessage!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: BrandColors.errorText),
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
                          onPressed: isBusy
                              ? null
                              : (serviceDisabled
                                  ? _enableLocationService
                                  : _request),
                          child: _viewModel.isRequesting ||
                                  _viewModel.isOpeningSettings
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: BrandColors.white,
                                  ),
                                )
                              : Text(serviceDisabled
                                  ? 'Включить геолокацию'
                                  : 'Разрешить доступ'),
                        ),
                      ),
                      if (_viewModel.status ==
                              LocationPermissionStatus.denied ||
                          serviceDisabled) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isBusy
                                ? null
                                : (serviceDisabled
                                    ? _enableLocationService
                                    : _openSettings),
                            icon: const Icon(Icons.settings_outlined),
                            label: Text(serviceDisabled
                                ? 'Открыть настройки геолокации'
                                : 'Открыть настройки'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Text(
                        // На Android упоминаем системную кнопку/жест «Назад».
                        // На iOS её нет — там предлагаем закрыть приложение
                        // через переключатель задач (swipe up).
                        Platform.isAndroid
                            ? 'Чтобы закрыть приложение, нажмите системную кнопку или жест «Назад».'
                            : 'Чтобы закрыть приложение, смахните его вверх из переключателя задач.',
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
