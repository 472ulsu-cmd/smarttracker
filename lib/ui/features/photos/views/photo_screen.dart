import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/service_locator.dart';
import '../../../../data/services/local_photo_store.dart';
import '../../../../domain/models/order_photo.dart';
import '../../../../domain/repositories/orders_repository.dart';
import '../../../../domain/repositories/photo_repository.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../view_models/photo_view_model.dart';

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
          action: SnackBarAction(
            label: 'Повторить',
            onPressed: _viewModel.load,
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
      appBar: AppBar(title: const Text('Фотографии')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.groups.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.groups.isEmpty) {
            return _Center(
              text: _viewModel.errorMessage ??
                  'Нет фото для этой заявки',
              action: _viewModel.errorMessage != null
                  ? _CenterAction(
                      label: 'Повторить',
                      onPressed: _viewModel.load,
                    )
                  : null,
            );
          }
          return Stack(
            children: [
              ListView.separated(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BrandColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.grayLighter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_outlined,
                  color: BrandColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(group.type, style: AppTextStyles.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (group.photos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Фотографии ещё не загружены',
                style: AppTextStyles.bodySmall
                    .copyWith(color: BrandColors.grayMid),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final photo in group.photos)
                  _PhotoThumb(
                    photo: photo,
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
                  label: const Text('Камера'),
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
                  label: const Text('Галерея'),
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
    required this.viewModel,
  });

  final OrderPhoto photo;
  final PhotoViewModel viewModel;

  Color _statusColor(OrderPhotoStatus s) {
    switch (s) {
      case OrderPhotoStatus.approved:
        return BrandColors.greenWeb;
      case OrderPhotoStatus.rejected:
        return BrandColors.error;
      case OrderPhotoStatus.pending:
        return BrandColors.grayDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reason = photo.rejectionReason.isNotEmpty
        ? photo.rejectionReason
        : viewModel.rejectionReason(photo.id) ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: photo.url.isEmpty
              ? Container(
                  width: 96,
                  height: 96,
                  color: BrandColors.grayLighter,
                  child: const Icon(Icons.broken_image_outlined,
                      color: BrandColors.grayMid),
                )
              : CachedNetworkImage(
                  imageUrl: photo.url,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 96,
                    height: 96,
                    color: BrandColors.grayLighter,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 96,
                    height: 96,
                    color: BrandColors.grayLighter,
                    child: const Icon(Icons.broken_image_outlined,
                        color: BrandColors.grayMid),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _statusColor(photo.status).withOpacity(0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            photo.status.label,
            style: AppTextStyles.caption
                .copyWith(color: _statusColor(photo.status)),
          ),
        ),
        if (photo.status == OrderPhotoStatus.rejected && reason.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              reason,
              style: AppTextStyles.caption.copyWith(color: BrandColors.error),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: BrandColors.graphite,
        borderRadius: BorderRadius.circular(999),
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
          const SizedBox(width: 10),
          Text('Загрузка…',
              style: AppTextStyles.bodySmall.copyWith(color: BrandColors.white)),
        ],
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
            Text(text,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: BrandColors.grayDark)),
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
