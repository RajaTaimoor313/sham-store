import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/repositories/notification_repository.dart';
import '../../../../core/models/notification_model.dart' as notification_models;
import '../../logic/notification_bloc.dart';
import '../../logic/notification_event.dart';
import '../../logic/notification_state.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationBloc(notificationRepository: NotificationRepository())
            ..add(const LoadNotifications()),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () => _markAllAsRead(context),
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
            tooltip: 'Notification settings',
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotificationsMarkedAsRead) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.notificationIds.length} notification(s) marked as read',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                      const LoadNotifications(),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return const NotificationEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(
                  const RefreshNotifications(),
                );
              },
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      return NotificationItem(
                        notification: notification,
                        onTap: () =>
                            _handleNotificationTap(context, notification),
                        onMarkAsRead: () =>
                            _markAsRead(context, [notification.id]),
                      );
                    },
                  ),
                  if (state.isRefreshing)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),
            );
          }

          if (state is MarkingNotificationsAsRead) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Marking notifications as read...'),
                ],
              ),
            );
          }

          return const NotificationEmptyState();
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    notification_models.Notification notification,
  ) {
    // Mark as read if not already read
    if (!notification.isRead) {
      _markAsRead(context, [notification.id]);
    }

    // Handle navigation based on notification type
    // This can be extended based on your app's navigation requirements
    switch (notification.type) {
      case 'order':
        // Navigate to order details
        break;
      case 'product':
        // Navigate to product details
        break;
      case 'promotion':
        // Navigate to promotions
        break;
      default:
        // Default action
        break;
    }
  }

  void _markAsRead(BuildContext context, List<int> notificationIds) {
    context.read<NotificationBloc>().add(
      MarkNotificationsAsRead(notificationIds),
    );
  }

  void _markAllAsRead(BuildContext context) {
    final state = context.read<NotificationBloc>().state;
    if (state is NotificationLoaded) {
      final unreadIds = state.notifications
          .where((notification) => !notification.isRead)
          .map((notification) => notification.id)
          .toList();

      if (unreadIds.isNotEmpty) {
        _markAsRead(context, unreadIds);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications are already read')),
        );
      }
    }
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/notification-settings');
  }
}
