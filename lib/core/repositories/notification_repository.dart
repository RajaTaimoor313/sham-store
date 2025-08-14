import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/notification_model.dart' as notification_models;

class NotificationRepository {
  final ApiService _apiService = ApiService.instance;

  // Get all notifications for the current user
  Future<ApiResponse<List<notification_models.Notification>>> getNotifications() async {
    try {
      print('NotificationRepository: Fetching notifications from ${ApiConstants.notifications}');
      
      final response = await _apiService.get(
        ApiConstants.notifications,
        requireAuth: true,
      );

      print('NotificationRepository: Get notifications response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final List<dynamic> notificationsJson = response.data['notifications'] ?? response.data;
        final notifications = notificationsJson
            .map((json) => notification_models.Notification.fromJson(json))
            .toList();
        print('NotificationRepository: Successfully fetched ${notifications.length} notifications');
        return ApiResponse.success(notifications);
      }

      print('NotificationRepository: Failed to fetch notifications - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to fetch notifications');
    } catch (e) {
      print('NotificationRepository: Exception in getNotifications - ${e.toString()}');
      return ApiResponse.error('Failed to fetch notifications: ${e.toString()}');
    }
  }

  // Mark notifications as read
  Future<ApiResponse<bool>> markNotificationsAsRead(List<int> notificationIds) async {
    try {
      print('NotificationRepository: Marking notifications as read - IDs: $notificationIds');
      
      final request = notification_models.MarkNotificationsAsReadRequest(
        notificationIds: notificationIds,
      );

      print('NotificationRepository: Sending mark as read request to ${ApiConstants.markNotificationsAsRead}');
      print('NotificationRepository: Request body: ${request.toJson()}');
      
      final response = await _apiService.post(
        ApiConstants.markNotificationsAsRead,
        body: request.toJson(),
        requireAuth: true,
      );

      print('NotificationRepository: Mark as read response success: ${response.isSuccess}');
      
      if (response.isSuccess) {
        print('NotificationRepository: Successfully marked notifications as read');
        return ApiResponse.success(true);
      }

      print('NotificationRepository: Failed to mark notifications as read - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to mark notifications as read');
    } catch (e) {
      print('NotificationRepository: Exception in markNotificationsAsRead - ${e.toString()}');
      return ApiResponse.error('Failed to mark notifications as read: ${e.toString()}');
    }
  }

  // Get notification settings for the current user
  Future<ApiResponse<notification_models.NotificationSettings>> getNotificationSettings() async {
    try {
      print('NotificationRepository: Fetching notification settings from ${ApiConstants.notificationSettings}');
      
      final response = await _apiService.get(
        ApiConstants.notificationSettings,
        requireAuth: true,
      );

      print('NotificationRepository: Get notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        print('NotificationRepository: Successfully fetched notification settings for user ${settings.userId}');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to fetch notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to fetch notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in getNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to fetch notification settings: ${e.toString()}');
    }
  }

  // Get notification settings by ID
  Future<ApiResponse<notification_models.NotificationSettings>> getNotificationSettingsById(int id) async {
    try {
      print('NotificationRepository: Fetching notification settings by ID: $id');
      
      final response = await _apiService.get(
        '${ApiConstants.notificationSettings}/$id',
        requireAuth: true,
      );

      print('NotificationRepository: Get notification settings by ID response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        print('NotificationRepository: Successfully fetched notification settings for ID: $id, User: ${settings.userId}');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to fetch notification settings by ID - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to fetch notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in getNotificationSettingsById - ${e.toString()}');
      return ApiResponse.error('Failed to fetch notification settings: ${e.toString()}');
    }
  }

  // Search notification settings
  Future<ApiResponse<List<notification_models.NotificationSettings>>> searchNotificationSettings(String searchTerm) async {
    try {
      print('NotificationRepository: Searching notification settings with term: "$searchTerm"');
      
      final response = await _apiService.get(
        '${ApiConstants.searchNotificationSettings}/$searchTerm',
        requireAuth: true,
      );

      print('NotificationRepository: Search notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final List<dynamic> settingsJson = response.data['settings'] ?? response.data;
        final settings = settingsJson
            .map((json) => notification_models.NotificationSettings.fromJson(json))
            .toList();
        print('NotificationRepository: Found ${settings.length} notification settings matching "$searchTerm"');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to search notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to search notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in searchNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to search notification settings: ${e.toString()}');
    }
  }

  // Create notification settings
  Future<ApiResponse<notification_models.NotificationSettings>> createNotificationSettings(
    notification_models.CreateNotificationSettingsRequest request,
  ) async {
    try {
      print('NotificationRepository: Creating notification settings for user: ${request.userId}');
      print('NotificationRepository: Request data: ${request.toJson()}');
      
      final response = await _apiService.post(
        ApiConstants.notificationSettings,
        body: request.toJson(),
        requireAuth: true,
      );

      print('NotificationRepository: Create notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        print('NotificationRepository: Successfully created notification settings with ID: ${settings.id}');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to create notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to create notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in createNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to create notification settings: ${e.toString()}');
    }
  }

  // Update notification settings
  Future<ApiResponse<notification_models.NotificationSettings>> updateNotificationSettings(
    int id,
    notification_models.UpdateNotificationSettingsRequest request,
  ) async {
    try {
      print('NotificationRepository: Updating notification settings with ID: $id');
      print('NotificationRepository: Update data: ${request.toJson()}');
      
      final response = await _apiService.put(
        '${ApiConstants.notificationSettings}/$id',
        body: request.toJson(),
        requireAuth: true,
      );

      print('NotificationRepository: Update notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final settings = notification_models.NotificationSettings.fromJson(response.data);
        print('NotificationRepository: Successfully updated notification settings ID: $id');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to update notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to update notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in updateNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to update notification settings: ${e.toString()}');
    }
  }

  // Delete notification settings
  Future<ApiResponse<bool>> deleteNotificationSettings(int id) async {
    try {
      print('NotificationRepository: Deleting notification settings with ID: $id');
      
      final response = await _apiService.delete(
        '${ApiConstants.notificationSettings}/$id',
        requireAuth: true,
      );

      print('NotificationRepository: Delete notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess) {
        print('NotificationRepository: Successfully deleted notification settings ID: $id');
        return ApiResponse.success(true);
      }

      print('NotificationRepository: Failed to delete notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to delete notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in deleteNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to delete notification settings: ${e.toString()}');
    }
  }

  // Get all notification settings (admin endpoint)
  Future<ApiResponse<List<notification_models.NotificationSettings>>> getAllNotificationSettings() async {
    try {
      print('NotificationRepository: Fetching all notification settings from ${ApiConstants.allNotificationSettings}');
      
      final response = await _apiService.get(
        ApiConstants.allNotificationSettings,
        requireAuth: true,
      );

      print('NotificationRepository: Get all notification settings response success: ${response.isSuccess}');
      
      if (response.isSuccess && response.data != null) {
        final List<dynamic> settingsJson = response.data['settings'] ?? response.data;
        final settings = settingsJson
            .map((json) => notification_models.NotificationSettings.fromJson(json))
            .toList();
        print('NotificationRepository: Successfully fetched ${settings.length} notification settings');
        return ApiResponse.success(settings);
      }

      print('NotificationRepository: Failed to fetch all notification settings - ${response.message}');
      return ApiResponse.error(response.message ?? 'Failed to fetch all notification settings');
    } catch (e) {
      print('NotificationRepository: Exception in getAllNotificationSettings - ${e.toString()}');
      return ApiResponse.error('Failed to fetch all notification settings: ${e.toString()}');
    }
  }
}