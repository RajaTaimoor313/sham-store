import 'package:flutter/material.dart';
import '../../../../core/models/notification_model.dart' as notification_models;
import '../../../../core/utils/date_formatter.dart';

class NotificationItem extends StatelessWidget {
  final notification_models.Notification notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: notification.isRead
                ? null
                : Theme.of(context).primaryColor.withOpacity(0.05),
            border: notification.isRead
                ? null
                : Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getNotificationColor(
                        notification.type,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getNotificationIcon(notification.type),
                      color: _getNotificationColor(notification.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Notification content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: notification.isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatRelativeTime(
                                notification.createdAt,
                              ),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                            const Spacer(),
                            if (notification.type.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getNotificationColor(
                                    notification.type,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  notification.type.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: _getNotificationColor(
                                          notification.type,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action buttons
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'mark_read':
                          onMarkAsRead?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (!notification.isRead)
                        const PopupMenuItem(
                          value: 'mark_read',
                          child: Row(
                            children: [
                              Icon(Icons.mark_email_read, size: 18),
                              SizedBox(width: 8),
                              Text('Mark as read'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: Icon(Icons.more_vert, color: Colors.grey[400]),
                  ),
                ],
              ),
              // Additional data if available
              if (notification.data != null && notification.data!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notification.data!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag;
      case 'product':
        return Icons.inventory;
      case 'promotion':
        return Icons.local_offer;
      case 'payment':
        return Icons.payment;
      case 'shipping':
        return Icons.local_shipping;
      case 'review':
        return Icons.star;
      case 'system':
        return Icons.settings;
      case 'security':
        return Icons.security;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Colors.blue;
      case 'product':
        return Colors.green;
      case 'promotion':
        return Colors.orange;
      case 'payment':
        return Colors.purple;
      case 'shipping':
        return Colors.teal;
      case 'review':
        return Colors.amber;
      case 'system':
        return Colors.grey;
      case 'security':
        return Colors.red;
      default:
        return Colors.indigo;
    }
  }
}
