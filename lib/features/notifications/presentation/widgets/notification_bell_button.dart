import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:frantend/features/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:go_router/go_router.dart';

class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: sl<NotificationsCubit>(),
      builder: (context, state) {
        final unreadCount = switch (state) {
          NotificationsLoaded(:final unreadCount) => unreadCount,
          _ => 0,
        };
        final badge = NotificationPresentation.badgeLabel(unreadCount);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              tooltip: 'Notifications',
              onPressed: () => _showPanel(context),
              icon: const Icon(Icons.notifications_none_rounded),
              color: AppColors.primary,
            ),
            if (badge.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showPanel(BuildContext context) async {
    final cubit = sl<NotificationsCubit>();
    await cubit.refreshPreview();

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black26,
      builder: (dialogContext) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 56, right: 24),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.antiAlias,
              child: _NotificationDropdownPanel(
                onViewAll: () {
                  Navigator.pop(dialogContext);
                  context.go(RouteNames.notifications);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationDropdownPanel extends StatelessWidget {
  const _NotificationDropdownPanel({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: sl<NotificationsCubit>(),
      builder: (context, state) {
        final cubit = sl<NotificationsCubit>();
        final unreadCount = switch (state) {
          NotificationsLoaded(:final unreadCount) => unreadCount,
          _ => 0,
        };
        final items = cubit.previewNotifications;

        return SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (unreadCount > 0)
                      TextButton(
                        onPressed: cubit.markAllAsRead,
                        child: const Text('Mark all as read'),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (state is NotificationsLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No notifications',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 420),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final notification = items[index];
                      return NotificationListTile(
                        notification: notification,
                        compact: true,
                        onTap: () async {
                          Navigator.pop(context);
                          await cubit.handleNotificationTap(
                            context,
                            notification,
                          );
                        },
                        onDelete: () => cubit.deleteNotification(notification.id),
                      );
                    },
                  ),
                ),
              const Divider(height: 1),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All Notifications →'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
