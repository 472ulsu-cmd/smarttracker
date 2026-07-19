import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/refresh_bus.dart';
import '../../../../config/service_locator.dart';
import '../../../../domain/models/notification_item.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/widgets/brand_card.dart';
import '../../../core/widgets/empty_state.dart';
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
    _viewModel = getIt<NotificationsViewModel>();
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
    if (!mounted) return;
    setState(() {});

    final actionError = _viewModel.consumeActionError();
    final transientError = actionError == null ? _viewModel.takeTransientError() : null;
    final errorMessage = actionError ?? transientError;
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      });
    }
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
                  enabled: !_viewModel.isBusy,
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
    return RefreshIndicator(
      onRefresh: _viewModel.load,
      color: BrandColors.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_viewModel.isLoading && _viewModel.items.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          }
          if (_viewModel.items.isEmpty) {
            final errorMessage = _viewModel.errorMessage;
            // Ошибка с ElevatedButton.icon и блокировкой на время загрузки —
            // специфика этого экрана, в общий ErrorState не выносится.
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: errorMessage == null
                    ? const EmptyState(
                        icon: null,
                        text:
                            'Пока нет уведомлений. Здесь появятся сообщения по заявкам.',
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: BrandColors.grayDark),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed:
                                    _viewModel.isBusy ? null : _viewModel.load,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Повторить'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _viewModel.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _viewModel.items[index];
              return _NotificationTile(
                item: item,
                enabled: !_viewModel.isBusy,
                orderNumber: item.hasOrder
                    ? _viewModel.orderNumberFor(item.orderId!)
                    : null,
                onTap: () async {
                  if (_viewModel.isBusy) return;
                  if (!item.isRead) await _viewModel.markAsRead(item.id);
                  if (item.hasOrder && context.mounted) {
                    context.push('/main/orders/${item.orderId}');
                  }
                },
              );
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BrandCard(
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
            ListenableBuilder(
              listenable: viewModel.settings,
              builder: (context, _) {
                return Switch(
                  value: viewModel.settings.pushEnabled,
                  activeThumbColor: BrandColors.primary,
                  onChanged: viewModel.isBusy ? null : viewModel.togglePush,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkAllBar extends StatelessWidget {
  const _MarkAllBar({required this.count, required this.onTap, this.enabled = true});
  final int count;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: enabled ? onTap : null,
          icon: const Icon(Icons.done_all_rounded, size: 18),
          label: Text(
            'Прочитать все ($count)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
    this.enabled = true,
    this.orderNumber,
  });

  final NotificationItem item;
  final VoidCallback onTap;
  final bool enabled;

  /// Номер заявки (num), если он известен; иначе показываем id.
  final String? orderNumber;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Индикатор непрочитанного.
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ExcludeSemantics(
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.message,
                    style: item.isRead
                        ? AppTextStyles.bodyMedium
                            .copyWith(color: BrandColors.grayDark)
                        : AppTextStyles.titleMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.datetime.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormatUtil.dateTime(item.datetime),
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (item.hasOrder) ...[
                    const SizedBox(height: 4),
                    Text(
                      orderNumber != null
                          ? 'Заявка № $orderNumber'
                          : 'Заявка № ${item.orderId}',
                      style: AppTextStyles.caption
                          .copyWith(color: BrandColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (item.hasOrder)
              const SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.chevron_right_rounded,
                        color: BrandColors.grayMid),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
