import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/service_locator.dart';
import '../../../../domain/models/order.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/phone_call_row.dart';
import '../view_models/order_detail_view_model.dart';

/// Экран детального маршрута по точкам заявки.
class OrderRouteScreen extends StatefulWidget {
  const OrderRouteScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderRouteScreen> createState() => _OrderRouteScreenState();
}

class _OrderRouteScreenState extends State<OrderRouteScreen> {
  late final OrderDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderDetailViewModel(widget.orderId, getIt<OrdersRepository>());
    _viewModel.addListener(_onChanged);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final order = _viewModel.order;
            return Text(
              order == null ? 'Маршрут' : 'Маршрут №${order.num}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.order == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final order = _viewModel.order;
          if (order == null || order.routeDetails.isEmpty) {
            final hasError = _viewModel.loadErrorMessage != null;
            final message = hasError
                ? _viewModel.loadErrorMessage!
                : order == null
                    ? 'Не удалось загрузить маршрут'
                    : 'Для этой заявки не указаны точки маршрута';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasError
                          ? Icons.error_outline_rounded
                          : Icons.route_outlined,
                      size: 56,
                      color: BrandColors.grayMid,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: BrandColors.grayDark),
                    ),
                    if (!hasError && order == null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Проверьте соединение и попробуйте снова.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: BrandColors.grayDark),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (hasError || order == null)
                      OutlinedButton(
                        onPressed: _viewModel.isLoading
                            ? null
                            : _viewModel.load,
                        child: const Text('Повторить'),
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Назад'),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            color: BrandColors.primary,
            onRefresh: _viewModel.load,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: order.routeDetails.length,
              itemBuilder: (context, index) {
                final point = order.routeDetails[index];
                final isLast = index == order.routeDetails.length - 1;
                return _RouteTimelineTile(point: point, isLast: isLast);
              },
            ),
          );
        },
      ),
    );
  }
}

class _RouteTimelineTile extends StatefulWidget {
  const _RouteTimelineTile({required this.point, required this.isLast});

  final OrderRouteDetail point;
  final bool isLast;

  @override
  State<_RouteTimelineTile> createState() => _RouteTimelineTileState();
}

class _RouteTimelineTileState extends State<_RouteTimelineTile> {
  bool _isLaunchingMap = false;

  Future<void> _openMap(BuildContext context) async {
    if (_isLaunchingMap) return;
    HapticFeedback.lightImpact();
    final lat = widget.point.lat;
    final lon = widget.point.lon;
    if (lat == null || lon == null) return;

    setState(() => _isLaunchingMap = true);

    // Приоритет: нативные российские навигаторы → web-версии → Google Maps.
    final candidates = [
      Uri.parse('yandexnavi://show_point_on_map?lat=$lat&lon=$lon'),
      Uri.parse('dgis://2gis.ru/routeSearch/rsType/car/to/$lon,$lat'),
      Uri.parse('yandexmaps://maps.yandex.ru/?pt=$lon,$lat&z=17'),
      Uri.parse('https://yandex.ru/maps/?pt=$lon,$lat&z=17'),
      Uri.parse('https://maps.google.com/maps?q=$lat,$lon&z=17'),
    ];

    try {
      for (final uri in candidates) {
        if (await canLaunchUrl(uri)) {
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return;
          } catch (_) {
            // Если конкретное приложение упало, пробуем следующий fallback.
            continue;
          }
        }
      }
    } finally {
      if (mounted) setState(() => _isLaunchingMap = false);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть карты. Установите навигатор.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    final isLast = widget.isLast;
    final isLoading = point.isLoading;
    final accentColor = isLoading ? BrandColors.primary : BrandColors.grayMid;
    final canOpenMap = point.lat != null && point.lon != null;

    final hasCargo = point.cargoType.isNotEmpty ||
        point.loadingMethod.isNotEmpty ||
        point.mass.isNotEmpty ||
        point.volume.isNotEmpty;
    final hasContacts = point.client.org.isNotEmpty ||
        point.client.manager.isNotEmpty ||
        point.client.phone.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isLoading ? Icons.upload_rounded : Icons.download_rounded,
                    color: BrandColors.white,
                    size: 14,
                    semanticLabel:
                        isLoading ? 'Точка погрузки' : 'Точка разгрузки',
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: BrandColors.grayLight,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BrandCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Тип операции: иконка + текст (погрузка/разгрузка).
                    Row(
                      children: [
                        Icon(
                          isLoading
                              ? Icons.upload_rounded
                              : Icons.download_rounded,
                          size: 16,
                          color: accentColor,
                          semanticLabel:
                              isLoading ? 'Погрузка' : 'Разгрузка',
                        ),
                        const SizedBox(width: 6),
                        Semantics(
                          header: true,
                          child: Text(
                            isLoading ? 'Погрузка' : 'Разгрузка',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Дата и время — над городом.
                    if (point.date.isNotEmpty)
                      _FieldLine(
                        icon: Icons.event_outlined,
                        text: '${DateFormatUtil.date(point.date)}  '
                            '${DateFormatUtil.time(point.timeFrom)}–'
                            '${DateFormatUtil.time(point.timeTo)}',
                        semanticLabel: 'Дата и время',
                      ),
                    if (point.city.isNotEmpty) ...[
                      if (point.date.isNotEmpty) const SizedBox(height: 8),
                      Text(
                        point.city,
                        style: AppTextStyles.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (point.address.isNotEmpty) ...[
                      if (point.city.isNotEmpty || point.date.isNotEmpty)
                        const SizedBox(height: 8),
                      _FieldLine(
                        icon: Icons.place_outlined,
                        text: point.address,
                        semanticLabel: 'Адрес',
                        minHeight: 48,
                        trailing: canOpenMap
                            ? TextButton.icon(
                                onPressed: _isLaunchingMap
                                    ? null
                                    : () => _openMap(context),
                                icon: const Icon(Icons.map_outlined, size: 18),
                                label: const Text('На карте'),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(48, 48),
                                  tapTargetSize:
                                      MaterialTapTargetSize.padded,
                                ),
                              )
                            : null,
                      ),
                    ],
                    // 2. Груз.
                    if (hasCargo) ...[
                      const SizedBox(height: 16),
                      const _SectionHeader('Груз'),
                      if (point.cargoType.isNotEmpty)
                        _FieldLine(
                          icon: Icons.inventory_2_outlined,
                          text: point.cargoType,
                          semanticLabel: 'Тип груза',
                        ),
                      if (point.loadingMethod.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _FieldLine(
                          icon: Icons.local_shipping_outlined,
                          text: 'Погрузка: ${point.loadingMethod}',
                          semanticLabel: 'Способ погрузки',
                        ),
                      ],
                      if (point.mass.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _FieldLine(
                          icon: Icons.scale_outlined,
                          text: 'Масса: ${point.mass} т',
                          semanticLabel: 'Масса',
                        ),
                      ],
                      if (point.volume.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _FieldLine(
                          icon: Icons.water_drop_outlined,
                          text: 'Объём: ${point.volume} м³',
                          semanticLabel: 'Объём',
                        ),
                      ],
                    ],
                    // 3. Контакты.
                    if (hasContacts) ...[
                      const SizedBox(height: 16),
                      const _SectionHeader('Контакты'),
                      if (point.client.org.isNotEmpty)
                        _FieldLine(
                          icon: Icons.business_outlined,
                          text: point.client.org,
                          semanticLabel: 'Организация',
                        ),
                      if (point.client.manager.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _FieldLine(
                          icon: Icons.person_outline,
                          text: point.client.manager,
                          semanticLabel: 'Контактное лицо',
                        ),
                      ],
                      if (point.client.phone.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        PhoneCallRow(
                          phone: point.client.phone,
                          iconSize: 16,
                          textStyle: AppTextStyles.bodySmall,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ],
                    // Примечание к точке — в конце плитки.
                    if (point.comment.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BrandColors.paperWarm,
                          borderRadius: BorderRadius.circular(BrandRadius.sm),
                        ),
                        child: Text(
                          point.comment,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: BrandColors.grayDark),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Заголовок внутри карточки точки маршрута.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: BrandColors.grayDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Строка с иконкой для поля точки маршрута.
class _FieldLine extends StatelessWidget {
  const _FieldLine({
    required this.icon,
    required this.text,
    this.trailing,
    this.semanticLabel,
    this.minHeight = 48,
  });

  final IconData icon;
  final String text;
  final Widget? trailing;
  final String? semanticLabel;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: BrandColors.grayMid,
            semanticLabel: semanticLabel,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: BrandColors.grayDark,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
