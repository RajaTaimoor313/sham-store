import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/notification_model.dart' as notification_models;

class NotificationRepository {
  final ApiService _apiService = ApiService.instance;

  // Get all notifications for the current user
  Future<ApiResponse<List<notification_models.Notification>>> getNotifications() async {
    try {
      final response = await _apiService.get(
        ApiConstants.notifications,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> notificationsJson = response.data['notifications'] ?? response.data;
        final notifications = notificationsJson
            .map((json) => notification_models.Notification.fromJson(json))
            .toList();
        return ApiResponse.success(notifications);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch notifications');
    } catch (e) {
      return ApiResponse.error('Failed to fetch notifications: ${e.toString()}');
    }
  }

  // Mark notifications as read
  Future<ApiResponse<bool>> markNotificationsAsRead(List<int> notificationIds) async {
    try {
      final request = notification_models.MarkNotificationsAsReadRequest(
        notificationIds: notificationIds,
      );

      final response = await _apiService.post(
        '${ApiConstants.notifications}/mark-as-read',
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess) {
        return ApiResponse.success(true);
      }

      return ApiResponse.error(response.message ?? 'Failed to mark notifications as read');
    } catch (e) {
      return ApiResponse.error('Failed to mark notifications as read: ${e.toString()}');
    }
  }

  // Get notification settings for the current user
  Future<ApiResponse<notification_models.NotificationSettings>> getNotificationSettings() async {
    try {
      final response = await _apiService.get(
        ApiConstants.notificationSettings,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to fetch notification settings: ${e.toString()}');
    }
  }

  // Get notification settings by ID
  Future<ApiResponse<notification_models.NotificationSettings>> getNotificationSettingsById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.notificationSettings}/$id',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to fetch notification settings: ${e.toString()}');
    }
  }

  // Search notification settings
  Future<ApiResponse<List<notification_models.NotificationSettings>>> searchNotificationSettings(String searchTerm) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchNotificationSettings}/$searchTerm',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> settingsJson = response.data['settings'] ?? response.data;
        final settings = settingsJson
            .map((json) => notification_models.NotificationSettings.fromJson(json))
            .toList();
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to search notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to search notification settings: ${e.toString()}');
    }
  }

  // Create notification settings
  Future<ApiResponse<notification_models.NotificationSettings>> createNotificationSettings(
    notification_models.CreateNotificationSettingsRequest request,
  ) async {
    try {
      final response = await _apiService.post(
        ApiConstants.notificationSettings,
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to create notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to create notification settings: ${e.toString()}');
    }
  }

  // Update notification settings
  Future<ApiResponse<notification_models.NotificationSettings>> updateNotificationSettings(
    int id,
    notification_models.UpdateNotificationSettingsRequest request,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.notificationSettings}/$id',
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to update notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to update notification settings: ${e.toString()}');
    }
  }

  // Delete notification settings
  Future<ApiResponse<bool>> deleteNotificationSettings(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.notificationSettings}/$id',
        requireAuth: true,
      );

      if (response.isSuccess) {
        return ApiResponse.success(true);
      }

      return ApiResponse.error(response.message ?? 'Failed to delete notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to delete notification settings: ${e.toString()}');
    }
  }

  // Get all notification settings (admin endpoint)
  Future<ApiResponse<List<notification_models.NotificationSettings>>> getAllNotificationSettings() async {
    try {
      final response = await _apiService.get(
        ApiConstants.allNotificationSettings,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> settingsJson = response.data['settings'] ?? response.data;
        final settings = settingsJson
            .map((json) => notification_models.NotificationSettings.fromJson(json))
            .toList();
        return ApiResponse.success(settings);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch all notification settings');
    } catch (e) {
      return ApiResponse.error('Failed to fetch all notification settings: ${e.toString()}');
    }
  }
}