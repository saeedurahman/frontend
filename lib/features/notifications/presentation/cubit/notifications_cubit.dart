import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';
import 'package:frantend/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@lazySingleton
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationsReadUseCase markNotificationsReadUseCase,
    required MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
    required CheckNotificationAlertsUseCase checkNotificationAlertsUseCase,
  })  : _getNotifications = getNotificationsUseCase,
        _markRead = markNotificationsReadUseCase,
        _markAllRead = markAllNotificationsReadUseCase,
        _deleteNotification = deleteNotificationUseCase,
        _checkAlerts = checkNotificationAlertsUseCase,
        super(const NotificationsState.initial());

  static const _pageSize = 50;
  static const _previewSize = 10;
  static const _checkAlertsInterval = Duration(minutes: 30);

  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationsReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;
  final DeleteNotificationUseCase _deleteNotification;
  final CheckNotificationAlertsUseCase _checkAlerts;

  Timer? _checkAlertsTimer;
  int _listLimit = _pageSize;

  List<NotificationModel> get previewNotifications {
    final current = state;
    if (current is! NotificationsLoaded) return const [];
    return current.notifications.take(_previewSize).toList();
  }

  @override
  Future<void> close() {
    _checkAlertsTimer?.cancel();
    return super.close();
  }

  Future<void> startSession() async {
    _listLimit = _pageSize;
    await loadNotifications(reset: true);
    await triggerCheckAlerts();
    _checkAlertsTimer?.cancel();
    _checkAlertsTimer = Timer.periodic(
      _checkAlertsInterval,
      (_) => triggerCheckAlerts(),
    );
  }

  void stopSession() {
    _checkAlertsTimer?.cancel();
    _checkAlertsTimer = null;
    emit(const NotificationsState.initial());
  }

  Future<void> loadNotifications({bool reset = true, int? limit}) async {
    if (limit != null) _listLimit = limit;

    final current = state;
    final filter = current is NotificationsLoaded
        ? current.filter
        : NotificationFilter.all;

    if (reset) {
      emit(const NotificationsState.loading());
    } else if (current is NotificationsLoaded) {
      emit(current.copyWith(isLoadingMore: true, errorMessage: null));
    }

    final skip = reset
        ? 0
        : switch (state) {
            NotificationsLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    final result = await _getNotifications(
      isRead: filter == NotificationFilter.unread ? false : null,
      skip: skip,
      limit: _listLimit,
    );

    result.fold(
      (failure) {
        if (reset) {
          emit(NotificationsState.error(failure.message));
        } else if (state is NotificationsLoaded) {
          emit((state as NotificationsLoaded).copyWith(
            isLoadingMore: false,
            errorMessage: failure.message,
          ));
        }
      },
      (page) {
        if (!reset && state is NotificationsLoaded) {
          final prev = state as NotificationsLoaded;
          emit(
            prev.copyWith(
              notifications: [...prev.notifications, ...page.items],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              unreadCount: page.unreadCount,
              isLoadingMore: false,
              errorMessage: null,
            ),
          );
        } else {
          emit(
            NotificationsLoaded(
              notifications: page.items,
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              unreadCount: page.unreadCount,
              filter: filter,
            ),
          );
        }
      },
    );
  }

  Future<void> refresh() => loadNotifications(reset: true);

  Future<void> refreshPreview() => loadNotifications(reset: true, limit: _previewSize);

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.isLoadingMore) return;
    if (current.notifications.length >= current.total) return;
    await loadNotifications(reset: false);
  }

  void setFilter(NotificationFilter filter) {
    final current = state;
    if (current is NotificationsLoaded && current.filter == filter) return;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(filter: filter));
    }
    loadNotifications(reset: true);
  }

  Future<void> markAsRead(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final target = current.notifications.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    final updatedItems = current.notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    final filteredOut =
        current.filter == NotificationFilter.unread ? updatedItems.where((n) => !n.isRead).toList() : updatedItems;

    emit(
      current.copyWith(
        notifications: filteredOut,
        unreadCount: current.unreadCount > 0 ? current.unreadCount - 1 : 0,
        total: current.filter == NotificationFilter.unread
            ? (current.total > 0 ? current.total - 1 : 0)
            : current.total,
        errorMessage: null,
      ),
    );

    final result = await _markRead([id]);
    result.fold((failure) => refresh(), (_) {});
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationsLoaded || current.unreadCount == 0) return;

    final updatedItems =
        current.notifications.map((n) => n.copyWith(isRead: true)).toList();

    emit(
      current.copyWith(
        notifications: current.filter == NotificationFilter.unread
            ? []
            : updatedItems,
        unreadCount: 0,
        total: current.filter == NotificationFilter.unread ? 0 : current.total,
        errorMessage: null,
      ),
    );

    final result = await _markAllRead();
    result.fold((failure) => refresh(), (_) {});
  }

  Future<void> deleteNotification(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final removed = current.notifications.where((n) => n.id == id).firstOrNull;
    if (removed == null) return;

    final updatedItems =
        current.notifications.where((n) => n.id != id).toList();

    emit(
      current.copyWith(
        notifications: updatedItems,
        total: current.total > 0 ? current.total - 1 : 0,
        unreadCount: removed.isRead
            ? current.unreadCount
            : (current.unreadCount > 0 ? current.unreadCount - 1 : 0),
        errorMessage: null,
      ),
    );

    final result = await _deleteNotification(id);
    result.fold((failure) => refresh(), (_) {});
  }

  Future<void> triggerCheckAlerts() async {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(current.copyWith(isCheckingAlerts: true, errorMessage: null));
    }

    final result = await _checkAlerts();
    await result.fold(
      (_) async {
        final updated = state;
        if (updated is NotificationsLoaded) {
          emit(updated.copyWith(isCheckingAlerts: false));
        }
      },
      (_) async {
        await loadNotifications(reset: true);
      },
    );
  }

  Future<void> handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) async {
    if (!notification.isRead) {
      await markAsRead(notification.id);
    }

    final route = NotificationPresentation.routeFor(notification);
    if (route != null && context.mounted) {
      context.go(route);
    }
  }
}

abstract final class NotificationPresentation {
  static IconData iconFor(String notificationType) {
    return switch (notificationType) {
      'low_stock' => Icons.warning_amber_rounded,
      'expiry_warning' || 'expiry_expired' => Icons.schedule_rounded,
      'payment_due' => Icons.payments_outlined,
      'shift_reminder' => Icons.point_of_sale_outlined,
      'sync_conflict' => Icons.sync_problem_outlined,
      _ => Icons.info_outline_rounded,
    };
  }

  static Color colorFor(String notificationType) {
    return switch (notificationType) {
      'low_stock' => const Color(0xFFF59E0B),
      'expiry_warning' => const Color(0xFFF59E0B),
      'expiry_expired' => const Color(0xFFEF4444),
      'payment_due' => AppColors.warning,
      'shift_reminder' => AppColors.primary,
      'sync_conflict' => AppColors.error,
      _ => AppColors.info,
    };
  }

  static String relativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt.toLocal());
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    return DateFormat('dd MMM yyyy, HH:mm').format(createdAt.toLocal());
  }

  static String? routeFor(NotificationModel notification) {
    final productId = notification.relatedProductId;
    if (productId != null &&
        (notification.notificationType == 'low_stock' ||
            notification.notificationType == 'expiry_warning' ||
            notification.notificationType == 'expiry_expired')) {
      return '${RouteNames.products}/$productId/edit';
    }
    return null;
  }

  static String badgeLabel(int count) {
    if (count <= 0) return '';
    if (count > 9) return '9+';
    return '$count';
  }
}
