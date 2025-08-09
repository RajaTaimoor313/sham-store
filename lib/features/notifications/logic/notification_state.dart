import 'package:equatable/equatable.dart';
import '../../../core/models/notification_model.dart' as notification_models;

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

// Initial state
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

// Notification states
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<notification_models.Notification> notifications;
  final bool isRefreshing;

  const NotificationLoaded({
    required this.notifications,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [notifications, isRefreshing];

  NotificationLoaded copyWith({
    List<notification_models.Notification>? notifications,
    bool? isRefreshing,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Mark as read states
class MarkingNotificationsAsRead extends NotificationState {
  final List<int> notificationIds;

  const MarkingNotificationsAsRead(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

class NotificationsMarkedAsRead extends NotificationState {
  final List<int> notificationIds;
  final List<notification_models.Notification> updatedNotifications;

  const NotificationsMarkedAsRead({
    required this.notificationIds,
    required this.updatedNotifications,
  });

  @override
  List<Object?> get props => [notificationIds, updatedNotifications];
}

// Notification settings states
class NotificationSettingsLoading extends NotificationState {
  const NotificationSettingsLoading();
}

class NotificationSettingsLoaded extends NotificationState {
  final notification_models.NotificationSettings settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsListLoaded extends NotificationState {
  final List<notification_models.NotificationSettings> settingsList;

  const NotificationSettingsListLoaded(this.settingsList);

  @override
  List<Object?> get props => [settingsList];
}

class NotificationSettingsError extends NotificationState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// CRUD operation states
class NotificationSettingsCreating extends NotificationState {
  const NotificationSettingsCreating();
}

class NotificationSettingsCreated extends NotificationState {
  final notification_models.NotificationSettings settings;

  const NotificationSettingsCreated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsUpdating extends NotificationState {
  final int id;

  const NotificationSettingsUpdating(this.id);

  @override
  List<Object?> get props => [id];
}

class NotificationSettingsUpdated extends NotificationState {
  final notification_models.NotificationSettings settings;

  const NotificationSettingsUpdated(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsDeleting extends NotificationState {
  final int id;

  const NotificationSettingsDeleting(this.id);

  @override
  List<Object?> get props => [id];
}

class NotificationSettingsDeleted extends NotificationState {
  final int id;

  const NotificationSettingsDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

// Search states
class NotificationSettingsSearching extends NotificationState {
  final String searchTerm;

  const NotificationSettingsSearching(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class NotificationSettingsSearchResults extends NotificationState {
  final String searchTerm;
  final List<notification_models.NotificationSettings> results;

  const NotificationSettingsSearchResults({
    required this.searchTerm,
    required this.results,
  });

  @override
  List<Object?> get props => [searchTerm, results];
}
