import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/feedback_model.dart';

class FeedbackRepository {
  final ApiService _apiService = ApiService.instance;

  // Create feedback
  Future<ApiResponse<Feedback>> createFeedback({
    required int star,
    required String feedbackContent,
    required int scale,
  }) async {
    try {
      print(
        'Creating feedback with star: $star, content: $feedbackContent, scale: $scale',
      );

      final data = {
        'star': star,
        'feddback_content':
            feedbackContent, // Note: API uses 'feddback_content' (typo in API)
        'scale': scale,
      };

      final response = await _apiService.post(
        ApiConstants.feedbacks,
        body: data,
      );

      print('Create feedback API response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final feedback = Feedback.fromJson(response.data!);
        print('Feedback created successfully with ID: ${feedback.id}');
        return ApiResponse.success(feedback);
      }

      print('Create feedback failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to create feedback');
    } catch (e) {
      print('Create feedback error: ${e.toString()}');
      return ApiResponse.error('Failed to create feedback: ${e.toString()}');
    }
  }

  // Get all feedbacks
  Future<ApiResponse<List<Feedback>>> getAllFeedbacks() async {
    try {
      print('Fetching all feedbacks');

      final response = await _apiService.get(ApiConstants.allFeedbacks);

      print('Get all feedbacks API response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> feedbacksJson = response.data is List
            ? response.data
            : response.data['data'] ?? [];

        final feedbacks = feedbacksJson.map((json) {
          // Handle case where message field might be an integer
          if (json is Map<String, dynamic> && json['message'] is int) {
            json = Map<String, dynamic>.from(json);
            json['message'] = json['message'].toString();
          }
          return Feedback.fromJson(json);
        }).toList();

        print('Fetched ${feedbacks.length} feedbacks successfully');
        return ApiResponse.success(feedbacks);
      }

      print('Get all feedbacks failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to fetch feedbacks');
    } catch (e) {
      print('Get all feedbacks error: ${e.toString()}');
      return ApiResponse.error('Failed to fetch feedbacks: ${e.toString()}');
    }
  }

  // Search feedbacks
  Future<ApiResponse<List<Feedback>>> searchFeedbacks(String query) async {
    try {
      print('Searching feedbacks with query: $query');

      final response = await _apiService.get(
        '${ApiConstants.searchFeedbacks}/$query',
      );

      print('Search feedbacks API response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> feedbacksJson = response.data is List
            ? response.data
            : response.data['data'] ?? [];

        final feedbacks = feedbacksJson
            .map((json) => Feedback.fromJson(json))
            .toList();

        print('Found ${feedbacks.length} feedbacks for query: $query');
        return ApiResponse.success(feedbacks);
      }

      print('Search feedbacks failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to search feedbacks');
    } catch (e) {
      print('Search feedbacks error: ${e.toString()}');
      return ApiResponse.error('Failed to search feedbacks: ${e.toString()}');
    }
  }

  // Get feedback by ID
  Future<ApiResponse<Feedback>> getFeedbackById(int id) async {
    try {
      print('Fetching feedback with ID: $id');

      final response = await _apiService.get(
        '${ApiConstants.feedbackById}/$id',
      );

      print('Get feedback by ID API response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final feedback = Feedback.fromJson(response.data!);
        print('Feedback fetched successfully: ${feedback.id}');
        return ApiResponse.success(feedback);
      }

      print('Get feedback by ID failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to fetch feedback');
    } catch (e) {
      print('Get feedback by ID error: ${e.toString()}');
      return ApiResponse.error('Failed to fetch feedback: ${e.toString()}');
    }
  }

  // Update feedback
  Future<ApiResponse<Feedback>> updateFeedback({
    required int id,
    required int star,
    required String feedbackContent,
    required int scale,
  }) async {
    try {
      print(
        'Updating feedback ID: $id with star: $star, content: $feedbackContent, scale: $scale',
      );

      final data = {
        'star': star,
        'feedback_content': feedbackContent,
        'scale': scale,
      };

      final response = await _apiService.put(
        '${ApiConstants.updateFeedback}/$id',
        body: data,
      );

      print('Update feedback API response success: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        final feedback = Feedback.fromJson(response.data!);
        print('Feedback updated successfully: ${feedback.id}');
        return ApiResponse.success(feedback);
      }

      print('Update feedback failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to update feedback');
    } catch (e) {
      print('Update feedback error: ${e.toString()}');
      return ApiResponse.error('Failed to update feedback: ${e.toString()}');
    }
  }

  // Delete feedback
  Future<ApiResponse<bool>> deleteFeedback(int id) async {
    try {
      print('Deleting feedback with ID: $id');

      final response = await _apiService.delete(
        '${ApiConstants.deleteFeedback}/$id',
      );

      print('Delete feedback API response success: ${response.isSuccess}');

      if (response.isSuccess) {
        print('Feedback deleted successfully: $id');
        return ApiResponse.success(true);
      }

      print('Delete feedback failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Failed to delete feedback');
    } catch (e) {
      print('Delete feedback error: $e');
      return ApiResponse.error('Failed to delete feedback');
    }
  }
}
