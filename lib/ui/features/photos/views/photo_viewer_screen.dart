import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../domain/models/order_photo.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/photo_status_chip.dart';

/// Палитра тёмного вьювера — единственного «drenched» экрана
/// приложения. Именованные токены вместо сырых Colors.*.
abstract final class _ViewerColors {
  static const background = Color(0xFF000000);
  static const scrim = Color(0x8A000000);
  static const foreground = Color(0xFFFFFFFF);
  static const foregroundMuted = Color(0xB3FFFFFF);
}

/// Полноэкранный просмотр фото заявки.
///
/// Модальный вьювер: листает фото группы свайпом, зум — пинчем и
/// двойным тапом, одиночный тап показывает/скрывает хром.
/// Только просмотр: действий со статусами здесь нет осознанно —
/// причина отклонения читается, новое фото отправляется из карточки
/// группы.
///
/// Тёмный фон — единственный «drenched» экран приложения: это просмотр
/// контента, а не смена темы; на солнце тёмная подложка даёт максимум
/// контраста самому снимку.
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    super.key,
    required this.group,
    required this.initialIndex,
    required this.resolveLocalPath,
    required this.resolveRejectionReason,
  });

  /// Группа, чьи фото листаем.
  final OrderPhotoGroup group;

  /// Индекс тапнутого фото в группе.
  final int initialIndex;

  /// Локальный путь к фото (если загружали с этого устройства).
  final String? Function(int photoId) resolveLocalPath;

  /// Сохранённая локально причина отклонения (fallback к полю фото).
  final String? Function(int photoId) resolveRejectionReason;

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late final PageController _pageController;
  late int _index;
  bool _chromeVisible = true;
  bool _zoomed = false;

  List<OrderPhoto> get _photos => widget.group.photos;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    // Листать в зуме нельзя (physics ниже), поэтому новая страница
    // всегда начинается без зума.
    setState(() {
      _index = index;
      _zoomed = false;
    });
  }

  void _onZoomChanged(bool zoomed) {
    if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
  }

  void _toggleChrome() => setState(() => _chromeVisible = !_chromeVisible);

  @override
  Widget build(BuildContext context) {
    final photo = _photos[_index];
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: _ViewerColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            physics: _zoomed
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            onPageChanged: _onPageChanged,
            itemCount: _photos.length,
            itemBuilder: (context, i) => _ZoomablePhoto(
              key: ValueKey(_photos[i].id),
              photo: _photos[i],
              index: i,
              total: _photos.length,
              resolveLocalPath: widget.resolveLocalPath,
              onZoomChanged: _onZoomChanged,
              onToggleChrome: _toggleChrome,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _Chrome(
              visible: _chromeVisible,
              reduceMotion: reduceMotion,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_ViewerColors.scrim, Colors.transparent],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: _ViewerColors.foreground),
                      tooltip: 'Назад',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    if (_photos.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          '${_index + 1} из ${_photos.length}',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: _ViewerColors.foreground),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _Chrome(
              visible: _chromeVisible,
              reduceMotion: reduceMotion,
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [_ViewerColors.scrim, Colors.transparent],
              ),
              child: SafeArea(
                top: false,
                child: _BottomCaption(
                  photo: photo,
                  groupType: widget.group.type,
                  rejectionReason: _reasonFor(photo),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _reasonFor(OrderPhoto photo) {
    if (photo.rejectionReason.isNotEmpty) return photo.rejectionReason;
    return widget.resolveRejectionReason(photo.id) ?? '';
  }
}

/// Фото с пинч-зумом и двойным тапом. Зум >1× сообщает наверх,
/// чтобы отключить листание PageView.
class _ZoomablePhoto extends StatefulWidget {
  const _ZoomablePhoto({
    super.key,
    required this.photo,
    required this.index,
    required this.total,
    required this.resolveLocalPath,
    required this.onZoomChanged,
    required this.onToggleChrome,
  });

  final OrderPhoto photo;
  final int index;
  final int total;
  final String? Function(int photoId) resolveLocalPath;
  final ValueChanged<bool> onZoomChanged;
  final VoidCallback onToggleChrome;

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  late final TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;
  bool _zoomed = false;

  static const double _doubleTapScale = 2.5;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _transformationController.addListener(_onTransform);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransform);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransform() {
    final zoomed =
        _transformationController.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) {
      _zoomed = zoomed;
      widget.onZoomChanged(zoomed);
    }
  }

  void _onDoubleTap() {
    final details = _doubleTapDetails;
    if (_zoomed || details == null) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    // Зум к точке двойного тапа (стандартная формула translate+scale).
    final pos = details.localPosition;
    const s = _doubleTapScale;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(-pos.dx * (s - 1), -pos.dy * (s - 1), 0, 1)
      ..scaleByDouble(s, s, s, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Фото ${widget.index + 1} из ${widget.total}, статус: ${widget.photo.status.label}',
      image: true,
      child: GestureDetector(
        onTap: widget.onToggleChrome,
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: _onDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1.0,
          maxScale: 4.0,
          child: Center(child: _buildImage(context)),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    // Локальный файл в приоритете (загруженные с устройства фото
    // доступны офлайн). Лимит декода — 2× физических пикселей экрана:
    // запас чёткости под зум, полный кадр в память не попадает.
    final cacheWidth = (MediaQuery.sizeOf(context).width *
            MediaQuery.devicePixelRatioOf(context) *
            2)
        .round();
    final local = widget.resolveLocalPath(widget.photo.id);
    if (local != null) {
      return Image.file(
        File(local),
        fit: BoxFit.contain,
        cacheWidth: cacheWidth,
        errorBuilder: (_, __, ___) => _networkImage(cacheWidth),
      );
    }
    return _networkImage(cacheWidth);
  }

  Widget _networkImage(int cacheWidth) {
    if (widget.photo.url.isEmpty) return _error();
    return Image.network(
      widget.photo.url,
      fit: BoxFit.contain,
      cacheWidth: cacheWidth,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: _ViewerColors.foreground),
        );
      },
      errorBuilder: (_, __, ___) => _error(),
    );
  }

  Widget _error() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.broken_image_outlined, color: _ViewerColors.foregroundMuted, size: 48),
        const SizedBox(height: 8),
        Text(
          'Не удалось загрузить фото',
          style: AppTextStyles.bodyMedium.copyWith(color: _ViewerColors.foregroundMuted),
        ),
      ],
    );
  }
}

/// Хром (верхняя/нижняя панель) с затемняющим скримом и плавным
/// появлением. При prefers-reduced-motion — мгновенная смена.
class _Chrome extends StatelessWidget {
  const _Chrome({
    required this.visible,
    required this.reduceMotion,
    required this.gradient,
    required this.child,
  });

  final bool visible;
  final bool reduceMotion;
  final Gradient gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
      opacity: visible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: gradient),
          child: child,
        ),
      ),
    );
  }
}

/// Нижняя подпись: тип группы, статус-чип, причина отклонения.
class _BottomCaption extends StatelessWidget {
  const _BottomCaption({
    required this.photo,
    required this.groupType,
    required this.rejectionReason,
  });

  final OrderPhoto photo;
  final String groupType;
  final String rejectionReason;

  @override
  Widget build(BuildContext context) {
    final showReason = photo.status == OrderPhotoStatus.rejected &&
        rejectionReason.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  groupType,
                  style: AppTextStyles.titleMedium
                      .copyWith(color: _ViewerColors.foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              PhotoStatusChip(status: photo.status),
            ],
          ),
          if (showReason) ...[
            const SizedBox(height: 8),
            // До 3 строк; длинная причина скроллится.
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 60),
              child: SingleChildScrollView(
                child: Text(
                  rejectionReason,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: _ViewerColors.foreground),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
