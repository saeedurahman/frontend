import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/notifications/data/models/notification_model.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    this.compact = false,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final typeColor =
        NotificationPresentation.colorFor(notification.notificationType);
    final icon = NotificationPresentation.iconFor(notification.notificationType);
    final isUnread = !notification.isRead;

    return Material(
      color: isUnread ? typeColor.withValues(alpha: 0.06) : Colors.white,
      borderRadius: BorderRadius.circular(compact ? 8 : 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 8 : 12),
            border: Border(
              top: const BorderSide(color: AppColors.border),
              right: const BorderSide(color: AppColors.border),
              bottom: const BorderSide(color: AppColors.border),
              left: BorderSide(
                color: isUnread ? typeColor : AppColors.border,
                width: isUnread ? 4 : 1,
              ),
            ),
          ),
          padding: EdgeInsets.all(compact ? 10 : 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 32 : 36,
                height: compact ? 32 : 36,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: typeColor, size: compact ? 18 : 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight:
                            isUnread ? FontWeight.w700 : FontWeight.w600,
                        fontSize: compact ? 13 : 14,
                      ),
                    ),
                    if (notification.message.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        maxLines: compact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 12 : 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Tooltip(
                      message: notification.createdAt.toLocal().toString(),
                      child: Text(
                        NotificationPresentation.relativeTime(
                          notification.createdAt,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!compact)
                IconButton(
                  tooltip: 'Delete',
                  iconSize: 18,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
