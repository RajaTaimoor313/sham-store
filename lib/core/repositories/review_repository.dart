import '../api/api_constants.dart';
import '../api/api_service.dart';
import '../api/api_response.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final ApiService _apiService;

  ReviewRepository(this._apiService);

  // Get reviews for a specific product
  Future<ApiResponse<List<Review>>> getProductReviews(
    int productId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    try {
      print('📝 ReviewRepository: Fetching reviews for product $productId');

      final response = await _apiService.get(
        ApiConstants.reviews,
        queryParams: {
          'product_id': productId.toString(),
          'page': page.toString(),
          'limit': limit.toString(),
          'sort_by': sortBy,
          'sort_order': sortOrder,
        },
        requireAuth: false, // Reviews should be publicly viewable
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> reviewsJson =
            response.data['reviews'] ?? response.data['data'] ?? [];
        final List<Review> reviews = reviewsJson
            .map((json) => Review.fromJson(json))
            .toList();

        print(
          '📝 ReviewRepository: Successfully fetched ${reviews.length} reviews',
        );
        return ApiResponse.success(reviews);
      } else {
        print(
          '❌ ReviewRepository: Failed to fetch reviews - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to fetch reviews');
      }
    } catch (e) {
      print('❌ ReviewRepository: Get product reviews error - $e');
      return ApiResponse.error('Failed to fetch reviews: ${e.toString()}');
    }
  }

  // Add a new review
  Future<ApiResponse<Review>> addReview(AddReviewRequest request) async {
    try {
      print(
        '📝 ReviewRepository: Adding review for product ${request.productId}',
      );

      final response = await _apiService.post(
        ApiConstants.addReview,
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final review = Review.fromJson(
          response.data['review'] ?? response.data,
        );
        print('📝 ReviewRepository: Successfully added review');
        return ApiResponse.success(review);
      } else {
        print('❌ ReviewRepository: Failed to add review - ${response.message}');
        return ApiResponse.error(response.error ?? 'Failed to add review');
      }
    } catch (e) {
      print('❌ ReviewRepository: Add review error - $e');
      return ApiResponse.error('Failed to add review: ${e.toString()}');
    }
  }

  // Update an existing review
  Future<ApiResponse<Review>> updateReview(UpdateReviewRequest request) async {
    try {
      print('📝 ReviewRepository: Updating review ${request.reviewId}');

      final response = await _apiService.put(
        '${ApiConstants.updateReview}/${request.reviewId}',
        body: request.toJson(),
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final review = Review.fromJson(
          response.data['review'] ?? response.data,
        );
        print('📝 ReviewRepository: Successfully updated review');
        return ApiResponse.success(review);
      } else {
        print(
          '❌ ReviewRepository: Failed to update review - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to update review');
      }
    } catch (e) {
      print('❌ ReviewRepository: Update review error - $e');
      return ApiResponse.error('Failed to update review: ${e.toString()}');
    }
  }

  // Delete a review
  Future<ApiResponse<String>> deleteReview(int reviewId) async {
    try {
      print('📝 ReviewRepository: Deleting review $reviewId');

      final response = await _apiService.delete(
        '${ApiConstants.deleteReview}/$reviewId',
        requireAuth: true,
      );

      if (response.isSuccess) {
        print('📝 ReviewRepository: Successfully deleted review');
        return ApiResponse.success('Review deleted successfully');
      } else {
        print(
          '❌ ReviewRepository: Failed to delete review - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to delete review');
      }
    } catch (e) {
      print('❌ ReviewRepository: Delete review error - $e');
      return ApiResponse.error('Failed to delete review: ${e.toString()}');
    }
  }

  // Mark review as helpful
  Future<ApiResponse<String>> markReviewHelpful(
    int reviewId,
    bool isHelpful,
  ) async {
    try {
      print(
        '📝 ReviewRepository: Marking review $reviewId as ${isHelpful ? "helpful" : "not helpful"}',
      );

      final response = await _apiService.post(
        '${ApiConstants.reviews}/$reviewId/helpful',
        body: {'is_helpful': isHelpful},
        requireAuth: true,
      );

      if (response.isSuccess) {
        print(
          '📝 ReviewRepository: Successfully marked review as ${isHelpful ? "helpful" : "not helpful"}',
        );
        return ApiResponse.success('Review marked successfully');
      } else {
        print(
          '❌ ReviewRepository: Failed to mark review - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to mark review');
      }
    } catch (e) {
      print('❌ ReviewRepository: Mark review helpful error - $e');
      return ApiResponse.error('Failed to mark review: ${e.toString()}');
    }
  }

  // Get all reviews (admin/seller)
  Future<ApiResponse<List<Review>>> getAllReviews({
    int page = 1,
    int limit = 10,
    String? productId,
    int? rating,
  }) async {
    try {
      print('📝 ReviewRepository: Fetching all reviews');

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (productId != null) queryParams['product_id'] = productId;
      if (rating != null) queryParams['rating'] = rating.toString();

      final response = await _apiService.get(
        ApiConstants.allReviews,
        queryParams: queryParams,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> reviewsJson =
            response.data['reviews'] ?? response.data['data'] ?? [];
        final List<Review> reviews = reviewsJson
            .map((json) => Review.fromJson(json))
            .toList();

        print(
          '📝 ReviewRepository: Successfully fetched ${reviews.length} reviews',
        );
        return ApiResponse.success(reviews);
      } else {
        print(
          '❌ ReviewRepository: Failed to fetch all reviews - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to fetch reviews');
      }
    } catch (e) {
      print('❌ ReviewRepository: Get all reviews error - $e');
      return ApiResponse.error('Failed to fetch reviews: ${e.toString()}');
    }
  }

  // Get review statistics for a product
  Future<ApiResponse<ReviewStatistics>> getProductReviewStatistics(
    int productId,
  ) async {
    try {
      print(
        '📊 ReviewRepository: Fetching review statistics for product $productId',
      );

      // Use the correct endpoint for review statistics
      final response = await _apiService.get(
        ApiConstants.reviewStatistics,
        queryParams: {'product_id': productId.toString()},
        requireAuth: false, // Review statistics should be publicly viewable
      );

      if (response.isSuccess && response.data != null) {
        final statistics = ReviewStatistics.fromJson(response.data);
        print('📊 ReviewRepository: Successfully fetched review statistics');
        return ApiResponse.success(statistics);
      } else {
        print(
          '❌ ReviewRepository: Failed to fetch review statistics - ${response.message}',
        );
        return ApiResponse.error(
          response.error ?? 'Failed to fetch review statistics',
        );
      }
    } catch (e) {
      print('❌ ReviewRepository: Get review statistics error - $e');
      return ApiResponse.error(
        'Failed to fetch review statistics: ${e.toString()}',
      );
    }
  }

  // Get user's reviews
  Future<ApiResponse<List<Review>>> getMyReviews({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('📝 ReviewRepository: Fetching user reviews');

      final response = await _apiService.get(
        '${ApiConstants.reviews}/my',
        queryParams: {'page': page.toString(), 'limit': limit.toString()},
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> reviewsJson =
            response.data['reviews'] ?? response.data['data'] ?? [];
        final List<Review> reviews = reviewsJson
            .map((json) => Review.fromJson(json))
            .toList();

        print(
          '📝 ReviewRepository: Successfully fetched ${reviews.length} user reviews',
        );
        return ApiResponse.success(reviews);
      } else {
        print(
          '❌ ReviewRepository: Failed to fetch user reviews - ${response.message}',
        );
        return ApiResponse.error(
          response.error ?? 'Failed to fetch user reviews',
        );
      }
    } catch (e) {
      print('❌ ReviewRepository: Get user reviews error - $e');
      return ApiResponse.error('Failed to fetch user reviews: ${e.toString()}');
    }
  }
}
