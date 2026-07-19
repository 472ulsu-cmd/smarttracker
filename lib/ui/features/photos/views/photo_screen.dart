import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/service_locator.dart';
import '../../../../data/services/local_photo_store.dart';
import '../../../../domain/models/order_photo.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../../domain/repositories/photo_repository.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/theme/brand_radius.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/photo_status_chip.dart';
import '../view_models/photo_view_model.dart';
import 'photo_viewer_screen.dart';

/// Экран фото по заявке.
///
/// Доступен только для заявок, принятых в работу. Фото группируются по типам
/// (Погрузка, Разгрузка). Можно загрузить фото (камера/галерея).
class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late final PhotoViewModel _viewModel;
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    _viewModel = PhotoViewModel(
      widget.orderId,
      getIt<PhotoRepository>(),
      getIt<OrdersRepository>(),
      getIt<LocalPhotoStore>(),
    );
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
    if (!mounted) return;
    setState(() {});

    final error = _viewModel.errorMessage;
    if (error != null &&
        error != _lastErrorMessage &&
        _viewModel.groups.isNotEmpty) {
      _lastErrorMessage = error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          behavior: SnackBarBehavior.floating,
          action: _viewModel.accessDenied
              ? SnackBarAction(
                  label: 'Открыть настройки',
                  onPressed: openAppSettings,
                )
              : _viewModel.queuedOffline
                  ? null // фото в очереди — повтор не нужен
                  : SnackBarAction(
                      label: 'Повторить',
                      onPressed: _viewModel.retryLastAction,
                    ),
        ),
      );
    } else if (error == null) {
      _lastErrorMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Фото по заявке')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.groups.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.groups.isEmpty) {
            return _Center(
              text: _viewModel.errorMessage ??
                  'Для этой заявки пока нет фото. Здесь появятся фото погрузки и разгрузки.',
              action: _viewModel.errorMessage != null
                  ? _CenterAction(
                      label: 'Загрузить снова',
                      onPressed: _viewModel.load,
                    )
                  : null,
            );
          }
          return Stack(
            children: [
              // На планшете контент не растягивается во всю ширину.
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _viewModel.groups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _PhotoGroupCard(
                        group: _viewModel.groups[index],
                        viewModel: _viewModel,
                      );
                    },
                  ),
                ),
              ),
              if (_viewModel.isUploading)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SafeArea(
                      child: _UploadingBadge(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PhotoGroupCard extends StatelessWidget {
  const _PhotoGroupCard({required this.group, required this.viewModel});

  final OrderPhotoGroup group;
  final PhotoViewModel viewModel;

  void _openViewer(BuildContext context, int index) {
    // Платформенный маршрут: на iOS сохраняется edge-swipe назад,
    // переход и predictive Back остаются системными.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PhotoViewerScreen(
          group: group,
          initialIndex: index,
          resolveLocalPath: viewModel.cachedPath,
          resolveRejectionReason: viewModel.rejectionReason,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrandCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_outlined,
                  color: BrandColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.type,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (group.photos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'В этой группе пока нет фото.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: BrandColors.grayDark),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < group.photos.length; i++)
                  _PhotoThumb(
                    photo: group.photos[i],
                    index: i,
                    total: group.photos.length,
                    onTap: () => _openViewer(context, i),
                    viewModel: viewModel,
                  ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: viewModel.isUploading
                      ? null
                      : () => viewModel.uploadForGroup(
                          group, ImageSourceOption.camera),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Сделать фото'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: viewModel.isUploading
                      ? null
                      : () => viewModel.uploadForGroup(
                          group, ImageSourceOption.gallery),
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Выбрать фото'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.photo,
    required this.index,
    required this.total,
    required this.onTap,
    required this.viewModel,
  });

  final OrderPhoto photo;

  /// Позиция фото в группе (для различения в Semantics-метке).
  final int index;
  final int total;

  /// Тап по превью — полноэкранный просмотр.
  final VoidCallback onTap;
  final PhotoViewModel viewModel;

  static const double _thumbSize = 96;

  /// Превью фото: локальный файл из кэша (если загружали с этого
  /// устройства) или сеть. Декод ограничен физическими пикселями
  /// превью — полноразмерный кадр в память не попадает.
  Widget _buildThumb(BuildContext context) {
    final cached = viewModel.cachedPath(photo.id);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheSize = (_thumbSize * dpr).round();

    if (cached != null) {
      return Image.file(
        File(cached),
        width: _thumbSize,
        height: _thumbSize,
        fit: BoxFit.cover,
        cacheWidth: cacheSize,
        cacheHeight: cacheSize,
        errorBuilder: (_, __, ___) => _networkThumb(cacheSize),
      );
    }
    return _networkThumb(cacheSize);
  }

  Widget _networkThumb(int cacheSize) {
    if (photo.url.isEmpty) return _broken();
    return Image.network(
      photo.url,
      width: _thumbSize,
      height: _thumbSize,
      fit: BoxFit.cover,
      cacheWidth: cacheSize,
      cacheHeight: cacheSize,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              width: _thumbSize,
              height: _thumbSize,
              color: BrandColors.grayLighter,
            ),
      errorBuilder: (_, __, ___) => _broken(),
    );
  }

  Widget _broken() {
    return Container(
      width: _thumbSize,
      height: _thumbSize,
      color: BrandColors.grayLighter,
      child:
          const Icon(Icons.broken_image_outlined, color: BrandColors.grayDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reason = photo.rejectionReason.isNotEmpty
        ? photo.rejectionReason
        : viewModel.rejectionReason(photo.id) ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label:
              'Открыть фото ${index + 1} из $total, статус: ${photo.status.label}',
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BrandRadius.sm),
              child: _buildThumb(context),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // «На рассмотрении» не влезает в ширину превью одной строкой —
        // чип переносится на две, текст статуса не обрезаем.
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _thumbSize),
          child: PhotoStatusChip(status: photo.status),
        ),
        if (photo.status == OrderPhotoStatus.rejected && reason.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              reason,
              style:
                  AppTextStyles.bodySmall.copyWith(color: BrandColors.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
      ],
    );
  }
}

class _UploadingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // liveRegion: TalkBack/VoiceOver объявят о начале загрузки.
    return Semantics(
      liveRegion: true,
      label: 'Загружаем фото',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: BrandColors.graphite,
          borderRadius: BorderRadius.circular(BrandRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: BrandColors.white),
            ),
            const SizedBox(width: 8),
            Text(
              'Загружаем фото…',
              style:
                  AppTextStyles.bodySmall.copyWith(color: BrandColors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAction {
  const _CenterAction({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
}

class _Center extends StatelessWidget {
  const _Center({required this.text, this.action});
  final String text;
  final _CenterAction? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: BrandColors.grayDark),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: action!.onPressed,
                child: Text(action!.label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
