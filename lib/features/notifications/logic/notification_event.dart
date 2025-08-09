import 'package:equatable/equatable.dart';
import '../../../core/models/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

// Notification events
class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

class MarkNotificationsAsRead extends NotificationEvent {
  final List<int> notificationIds;

  const MarkNotificationsAsRead(this.notificationIds);

  @override
  List<Object?> get props => [notificationIds];
}

class RefreshNotifications extends NotificationEvent {
  const RefreshNotifications();
}

// Notification settings events
class LoadNotificationSettings extends NotificationEvent {
  const LoadNotificationSettings();
}

class LoadNotificationSettingsById extends NotificationEvent {
  final int id;

  const LoadNotificationSettingsById(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchNotificationSettings extends NotificationEvent {
  final String searchTerm;

  const SearchNotificationSettings(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class CreateNotificationSettings extends NotificationEvent {
  final CreateNotificationSettingsRequest request;

  const CreateNotificationSettings(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateNotificationSettings extends NotificationEvent {
  final int id;
  final UpdateNotificationSettingsRequest request;

  const UpdateNotificationSettings(this.id, this.request);

  @override
  List<Object?> get props => [id, request];
}

class DeleteNotificationSettings extends NotificationEvent {
  final int id;

  const DeleteNotificationSettings(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadAllNotificationSettings extends NotificationEvent {
  const LoadAllNotificationSettings();
}

// Reset events
class ResetNotificationState extends NotificationEvent {
  const ResetNotificationState();
}

class ResetNotificationSettingsState extends NotificationEvent {
  const ResetNotificationSettingsState();
}
