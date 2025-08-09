import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(const NotificationInitial()) {
    // Notification events
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationsAsRead>(_onMarkNotificationsAsRead);
    on<RefreshNotifications>(_onRefreshNotifications);

    // Notification settings events
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<LoadNotificationSettingsById>(_onLoadNotificationSettingsById);
    on<SearchNotificationSettings>(_onSearchNotificationSettings);
    on<CreateNotificationSettings>(_onCreateNotificationSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<DeleteNotificationSettings>(_onDeleteNotificationSettings);
    on<LoadAllNotificationSettings>(_onLoadAllNotificationSettings);

    // Reset events
    on<ResetNotificationState>(_onResetNotificationState);
    on<ResetNotificationSettingsState>(_onResetNotificationSettingsState);
  }

  // Load notifications
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      final response = await _notificationRepository.getNotifications();

      if (response.isSuccess && response.data != null) {
        emit(NotificationLoaded(notifications: response.data!));
      } else {
        emit(
          NotificationError(response.message ?? 'Failed to load notifications'),
        );
      }
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  // Refresh notifications
  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const NotificationLoading());
    }

    try {
      final response = await _notificationRepository.getNotifications();

      if (response.isSuccess && response.data != null) {
        emit(NotificationLoaded(notifications: response.data!));
      } else {
        emit(
          NotificationError(
            response.message ?? 'Failed to refresh notifications',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationError('Failed to refresh notifications: ${e.toString()}'),
      );
    }
  }

  // Mark notifications as read
  Future<void> _onMarkNotificationsAsRead(
    MarkNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    emit(MarkingNotificationsAsRead(event.notificationIds));

    try {
      final response = await _notificationRepository.markNotificationsAsRead(
        event.notificationIds,
      );

      if (response.isSuccess) {
        // Update local notifications to mark them as read
        if (state is NotificationLoaded) {
          final currentState = state as NotificationLoaded;
          final updatedNotifications = currentState.notifications.map((
            notification,
          ) {
            if (event.notificationIds.contains(notification.id)) {
              return notification.copyWith(isRead: true);
            }
            return notification;
          }).toList();

          emit(
            NotificationsMarkedAsRead(
              notificationIds: event.notificationIds,
              updatedNotifications: updatedNotifications,
            ),
          );

          // Emit updated loaded state
          emit(NotificationLoaded(notifications: updatedNotifications));
        } else {
          emit(
            NotificationsMarkedAsRead(
              notificationIds: event.notificationIds,
              updatedNotifications: [],
            ),
          );
        }
      } else {
        emit(
          NotificationError(
            response.message ?? 'Failed to mark notifications as read',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationError(
          'Failed to mark notifications as read: ${e.toString()}',
        ),
      );
    }
  }

  // Load notification settings
  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    try {
      final response = await _notificationRepository.getNotificationSettings();

      if (response.isSuccess && response.data != null) {
        emit(NotificationSettingsLoaded(response.data!));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to load notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to load notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Load notification settings by ID
  Future<void> _onLoadNotificationSettingsById(
    LoadNotificationSettingsById event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    try {
      final response = await _notificationRepository
          .getNotificationSettingsById(event.id);

      if (response.isSuccess && response.data != null) {
        emit(NotificationSettingsLoaded(response.data!));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to load notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to load notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Search notification settings
  Future<void> _onSearchNotificationSettings(
    SearchNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationSettingsSearching(event.searchTerm));

    try {
      final response = await _notificationRepository.searchNotificationSettings(
        event.searchTerm,
      );

      if (response.isSuccess && response.data != null) {
        emit(
          NotificationSettingsSearchResults(
            searchTerm: event.searchTerm,
            results: response.data!,
          ),
        );
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to search notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to search notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Create notification settings
  Future<void> _onCreateNotificationSettings(
    CreateNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationSettingsCreating());

    try {
      final response = await _notificationRepository.createNotificationSettings(
        event.request,
      );

      if (response.isSuccess && response.data != null) {
        emit(NotificationSettingsCreated(response.data!));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to create notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to create notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Update notification settings
  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationSettingsUpdating(event.id));

    try {
      final response = await _notificationRepository.updateNotificationSettings(
        event.id,
        event.request,
      );

      if (response.isSuccess && response.data != null) {
        emit(NotificationSettingsUpdated(response.data!));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to update notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to update notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Delete notification settings
  Future<void> _onDeleteNotificationSettings(
    DeleteNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationSettingsDeleting(event.id));

    try {
      final response = await _notificationRepository.deleteNotificationSettings(
        event.id,
      );

      if (response.isSuccess) {
        emit(NotificationSettingsDeleted(event.id));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to delete notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to delete notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Load all notification settings
  Future<void> _onLoadAllNotificationSettings(
    LoadAllNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationSettingsLoading());

    try {
      final response = await _notificationRepository
          .getAllNotificationSettings();

      if (response.isSuccess && response.data != null) {
        emit(NotificationSettingsListLoaded(response.data!));
      } else {
        emit(
          NotificationSettingsError(
            response.message ?? 'Failed to load all notification settings',
          ),
        );
      }
    } catch (e) {
      emit(
        NotificationSettingsError(
          'Failed to load all notification settings: ${e.toString()}',
        ),
      );
    }
  }

  // Reset notification state
  Future<void> _onResetNotificationState(
    ResetNotificationState event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationInitial());
  }

  // Reset notification settings state
  Future<void> _onResetNotificationSettingsState(
    ResetNotificationSettingsState event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationInitial());
  }
}
