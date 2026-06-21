import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:frantend/features/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotificationsView();
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<NotificationsCubit>().loadNotifications(reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset >= max - 200) {
      sl<NotificationsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      bloc: sl<NotificationsCubit>(),
      listener: (context, state) {
        if (state is NotificationsLoaded && state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
        }
        if (state is NotificationsError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final unreadCount = switch (state) {
          NotificationsLoaded(:final unreadCount) => unreadCount,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(unreadCount: unreadCount, state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is NotificationsLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                NotificationsInitial() || NotificationsLoading() =>
                  const _ShimmerList(),
                NotificationsLoaded(:final notifications)
                    when notifications.isEmpty =>
                  _EmptyState(
                    filter: state.filter,
                    onCheckNow: () =>
                        sl<NotificationsCubit>().triggerCheckAlerts(),
                  ),
                NotificationsLoaded loaded => _NotificationList(
                    state: loaded,
                    scrollController: _scrollController,
                  ),
                NotificationsError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
              },
            ),
          ],
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.unreadCount, required this.state});

  final int unreadCount;
  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = sl<NotificationsCubit>();
    final isChecking = switch (state) {
      NotificationsLoaded(:final isCheckingAlerts) => isCheckingAlerts,
      _ => false,
    };

    return Row(
      children: [
        Text('Notifications', style: AppTextStyles.headlineMedium),
        if (unreadCount > 0) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$unreadCount unread',
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        const Spacer(),
        OutlinedButton.icon(
          onPressed: isChecking ? null : cubit.triggerCheckAlerts,
          icon: isChecking
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh, size: 18),
          label: const Text('Check Now'),
        ),
        const SizedBox(width: 8),
        if (unreadCount > 0)
          FilledButton(
            onPressed: cubit.markAllAsRead,
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Mark All Read'),
          ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final NotificationsLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = sl<NotificationsCubit>();

    return Row(
      children: [
        FilterChip(
          label: const Text('All'),
          selected: state.filter == NotificationFilter.all,
          onSelected: (_) => cubit.setFilter(NotificationFilter.all),
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primary,
        ),
        const SizedBox(width: 8),
        FilterChip(
          label: const Text('Unread'),
          selected: state.filter == NotificationFilter.unread,
          onSelected: (_) => cubit.setFilter(NotificationFilter.unread),
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList({
    required this.state,
    required this.scrollController,
  });

  final NotificationsLoaded state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = sl<NotificationsCubit>();

    return ListView.separated(
      controller: scrollController,
      itemCount: state.notifications.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= state.notifications.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final notification = state.notifications[index];
        return NotificationListTile(
          notification: notification,
          onTap: () => cubit.handleNotificationTap(context, notification),
          onDelete: () => cubit.deleteNotification(notification.id),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter, required this.onCheckNow});

  final NotificationFilter filter;
  final VoidCallback onCheckNow;

  @override
  Widget build(BuildContext context) {
    final isUnreadFilter = filter == NotificationFilter.unread;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            isUnreadFilter ? 'No unread notifications' : 'No notifications',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            isUnreadFilter
                ? 'You are all caught up.'
                : 'Alerts will appear here when stock or expiry conditions are detected.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onCheckNow,
            icon: const Icon(Icons.refresh),
            label: const Text('Check Now'),
          ),
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: Colors.white,
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, __) => Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
