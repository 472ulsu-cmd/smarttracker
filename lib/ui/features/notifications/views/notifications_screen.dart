import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/models/notification_item.dart';
import '../../../../domain/repositories/notifications_repository.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/utils/date_format.dart';
import '../view_models/notifications_view_model.dart';

/// Экран уведомлений с переключателем push.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel;
  late final NotificationsRefreshBus _refreshBus;

  @override
  void initState() {
    super.initState();
    _viewModel = NotificationsViewModel(getIt<NotificationsRepository>());
    _viewModel.addListener(_onChanged);
    // Обновление списка при новом FCM-уведомлении.
    _refreshBus = getIt<NotificationsRefreshBus>();
    _refreshBus.addListener(_onExternalRefresh);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onChanged);
    _refreshBus.removeListener(_onExternalRefresh);
    _viewModel.dispose();
    super.dispose();
  }

  void _onExternalRefresh() {
    if (mounted) _viewModel.load();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Уведомления')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Column(
            children: [
              _PushToggle(viewModel: _viewModel),
              if (_viewModel.unreadCount > 0)
                _MarkAllBar(
                  count: _viewModel.unreadCount,
                  onTap: _viewModel.markAllRead,
                ),
              Expanded(child: _body()),
            ],
          );
        },
      ),
    );
  }

  Widget _body() {
    if (_viewModel.isLoading && _viewModel.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_viewModel.items.isEmpty) {
      return Center(
        child: Text(
          _viewModel.errorMessage ?? 'Пока нет уведомлений. Здесь появятся сообщения по заявкам.',
          style: AppTextStyles.bodyMedium.copyWith(color: BrandColors.grayMid),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _viewModel.load,
      color: BrandColors.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _viewModel.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _viewModel.items[index];
          return _NotificationTile(
            item: item,
            onTap: () async {
              if (!item.isRead) await _viewModel.markAsRead(item.id);
              if (item.hasOrder && context.mounted) {
                context.push('/main/orders/${item.orderId}');
              }
            },
          );
        },
      ),
    );
  }
}

class _PushToggle extends StatelessWidget {
  const _PushToggle({required this.viewModel});
  final NotificationsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel.settings,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: BrandColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BrandColors.grayLighter),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications_active_outlined,
                  color: BrandColors.primary),
              const SizedBox(width: 12),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Получать push-уведомления', style: AppTextStyles.bodyLarge),
              ),
              Switch(
                value: viewModel.settings.pushEnabled,
                activeColor: BrandColors.primary,
                onChanged: viewModel.togglePush,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MarkAllBar extends StatelessWidget {
  const _MarkAllBar({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.done_all_rounded, size: 18),
          label: Text('Прочитать все ($count)'),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Индикатор непрочитанного.
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.isRead
                      ? Colors.transparent
                      : BrandColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.message,
                      style: item.isRead
                          ? AppTextStyles.bodyMedium
                              .copyWith(color: BrandColors.grayDark)
                          : AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            )),
                  if (item.datetime.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormatUtil.dateTime(item.datetime),
                      style: AppTextStyles.caption
                          .copyWith(color: BrandColors.grayMid),
                    ),
                  ],
                  if (item.hasOrder) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Заявка № ${item.orderId}',
                      style: AppTextStyles.caption
                          .copyWith(color: BrandColors.primary),
                    ),
                  ],
                ],
              ),
            ),
            if (item.hasOrder)
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 2),
                child: Icon(Icons.chevron_right_rounded,
                    color: BrandColors.grayMid),
              ),
          ],
        ),
      ),
    );
  }
}
