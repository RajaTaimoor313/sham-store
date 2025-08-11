import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/repositories/review_repository.dart';
import '../../../core/models/review_model.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc(this._reviewRepository) : super(const ReviewInitial()) {
    on<LoadProductReviews>(_onLoadProductReviews);
    on<LoadMoreProductReviews>(_onLoadMoreProductReviews);
    on<LoadReviewStatistics>(_onLoadReviewStatistics);
    on<AddReview>(_onAddReview);
    on<UpdateReview>(_onUpdateReview);
    on<DeleteReview>(_onDeleteReview);
    on<LoadMyReviews>(_onLoadMyReviews);
    on<MarkReviewHelpful>(_onMarkReviewHelpful);
    on<RefreshReviews>(_onRefreshReviews);
    on<ClearReviews>(_onClearReviews);
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      print('🔄 ReviewBloc: Loading reviews for product ${event.productId}');
      emit(const ReviewLoading());

      // Load reviews and statistics concurrently
      final reviewsResponse = await _reviewRepository.getProductReviews(
        event.productId,
        page: event.page,
        limit: event.limit,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      );

      final statisticsResponse = await _reviewRepository.getProductReviewStatistics(event.productId);

      if (reviewsResponse.isSuccess) {
        final reviews = reviewsResponse.data ?? [];
        final statistics = statisticsResponse.isSuccess ? statisticsResponse.data : null;
        
        print('✅ ReviewBloc: Successfully loaded ${reviews.length} reviews');
        emit(ReviewLoaded(
          reviews: reviews,
          statistics: statistics,
          hasMoreReviews: reviews.length >= event.limit,
          currentPage: event.page,
          productId: event.productId,
        ));
      } else {
        print('❌ ReviewBloc: Failed to load reviews - ${reviewsResponse.error}');
        emit(ReviewError(message: reviewsResponse.error ?? 'Failed to load reviews'));
      }
    } catch (e) {
      print('❌ ReviewBloc: Load reviews error - $e');
      emit(ReviewError(message: 'Failed to load reviews: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreProductReviews(
    LoadMoreProductReviews event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;

    final currentState = state as ReviewLoaded;
    
    try {
      print('🔄 ReviewBloc: Loading more reviews for product ${event.productId}, page ${event.page}');
      emit(ReviewLoadingMore(
        currentReviews: currentState.reviews,
        statistics: currentState.statistics,
      ));

      final response = await _reviewRepository.getProductReviews(
        event.productId,
        page: event.page,
        limit: event.limit,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      );

      if (response.isSuccess) {
        final newReviews = response.data ?? <Review>[];
        final allReviews = <Review>[...currentState.reviews, ...newReviews];
        
        print('✅ ReviewBloc: Successfully loaded ${newReviews.length} more reviews');
        emit(currentState.copyWith(
          reviews: allReviews,
          hasMoreReviews: newReviews.length >= event.limit,
          currentPage: event.page,
        ));
      } else {
        print('❌ ReviewBloc: Failed to load more reviews - ${response.error}');
        emit(ReviewError(
          message: response.error ?? 'Failed to load more reviews',
          previousReviews: currentState.reviews,
          statistics: currentState.statistics,
        ));
      }
    } catch (e) {
      print('❌ ReviewBloc: Load more reviews error - $e');
      emit(ReviewError(
        message: 'Failed to load more reviews: ${e.toString()}',
        previousReviews: currentState.reviews,
        statistics: currentState.statistics,
      ));
    }
  }

  Future<void> _onLoadReviewStatistics(
    LoadReviewStatistics event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is ReviewLoaded) {
      final currentState = state as ReviewLoaded;
      
      try {
        print('📊 ReviewBloc: Loading review statistics for product ${event.productId}');
        
        final response = await _reviewRepository.getProductReviewStatistics(event.productId);
        
        if (response.isSuccess) {
          print('✅ ReviewBloc: Successfully loaded review statistics');
          emit(currentState.copyWith(statistics: response.data));
        }
      } catch (e) {
        print('❌ ReviewBloc: Load statistics error - $e');
        // Don't emit error for statistics failure, just log it
      }
    }
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<ReviewState> emit,
  ) async {
    final currentReviews = _getCurrentReviews();
    final currentStatistics = _getCurrentStatistics();
    
    try {
      print('📝 ReviewBloc: Adding review for product ${event.request.productId}');
      emit(ReviewActionLoading(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        action: 'adding',
      ));

      final response = await _reviewRepository.addReview(event.request);

      if (response.isSuccess && response.data != null) {
        final newReview = response.data!;
        final updatedReviews = [newReview, ...currentReviews];
        
        print('✅ ReviewBloc: Successfully added review');
        emit(ReviewActionSuccess(
          reviews: updatedReviews,
          statistics: currentStatistics,
          message: 'Review added successfully',
          action: 'adding',
        ));
        
        // Refresh statistics
        add(LoadReviewStatistics(event.request.productId));
      } else {
        print('❌ ReviewBloc: Failed to add review - ${response.error}');
        emit(ReviewActionError(
          currentReviews: currentReviews,
          statistics: currentStatistics,
          message: response.error ?? 'Failed to add review',
          action: 'adding',
        ));
      }
    } catch (e) {
      print('❌ ReviewBloc: Add review error - $e');
      emit(ReviewActionError(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        message: 'Failed to add review: ${e.toString()}',
        action: 'adding',
      ));
    }
  }

  Future<void> _onUpdateReview(
    UpdateReview event,
    Emitter<ReviewState> emit,
  ) async {
    final currentReviews = _getCurrentReviews();
    final currentStatistics = _getCurrentStatistics();
    
    try {
      print('📝 ReviewBloc: Updating review ${event.request.reviewId}');
      emit(ReviewActionLoading(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        action: 'updating',
      ));

      final response = await _reviewRepository.updateReview(event.request);

      if (response.isSuccess && response.data != null) {
        final updatedReview = response.data!;
        final updatedReviews = currentReviews.map((review) {
          return review.id == updatedReview.id ? updatedReview : review;
        }).toList().cast<Review>();
        
        print('✅ ReviewBloc: Successfully updated review');
        emit(ReviewActionSuccess(
          reviews: updatedReviews,
          statistics: currentStatistics,
          message: 'Review updated successfully',
          action: 'updating',
        ));
      } else {
        print('❌ ReviewBloc: Failed to update review - ${response.error}');
        emit(ReviewActionError(
          currentReviews: currentReviews,
          statistics: currentStatistics,
          message: response.error ?? 'Failed to update review',
          action: 'updating',
        ));
      }
    } catch (e) {
      print('❌ ReviewBloc: Update review error - $e');
      emit(ReviewActionError(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        message: 'Failed to update review: ${e.toString()}',
        action: 'updating',
      ));
    }
  }

  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewState> emit,
  ) async {
    final currentReviews = _getCurrentReviews();
    final currentStatistics = _getCurrentStatistics();
    
    try {
      print('📝 ReviewBloc: Deleting review ${event.reviewId}');
      emit(ReviewActionLoading(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        action: 'deleting',
      ));

      final response = await _reviewRepository.deleteReview(event.reviewId);

      if (response.isSuccess) {
        final updatedReviews = currentReviews.where((review) => review.id != event.reviewId).toList();
        
        print('✅ ReviewBloc: Successfully deleted review');
        emit(ReviewActionSuccess(
          reviews: updatedReviews,
          statistics: currentStatistics,
          message: 'Review deleted successfully',
          action: 'deleting',
        ));
      } else {
        print('❌ ReviewBloc: Failed to delete review - ${response.error}');
        emit(ReviewActionError(
          currentReviews: currentReviews,
          statistics: currentStatistics,
          message: response.error ?? 'Failed to delete review',
          action: 'deleting',
        ));
      }
    } catch (e) {
      print('❌ ReviewBloc: Delete review error - $e');
      emit(ReviewActionError(
        currentReviews: currentReviews,
        statistics: currentStatistics,
        message: 'Failed to delete review: ${e.toString()}',
        action: 'deleting',
      ));
    }
  }

  Future<void> _onLoadMyReviews(
    LoadMyReviews event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      print('🔄 ReviewBloc: Loading user reviews');
      emit(const MyReviewsLoading());

      final response = await _reviewRepository.getMyReviews(
        page: event.page,
        limit: event.limit,
      );

      if (response.isSuccess) {
        final reviews = response.data ?? [];
        
        print('✅ ReviewBloc: Successfully loaded ${reviews.length} user reviews');
        emit(MyReviewsLoaded(
          reviews: reviews,
          hasMoreReviews: reviews.length >= event.limit,
          currentPage: event.page,
        ));
      } else {
        print('❌ ReviewBloc: Failed to load user reviews - ${response.error}');
        emit(MyReviewsError(response.error ?? 'Failed to load user reviews'));
      }
    } catch (e) {
      print('❌ ReviewBloc: Load user reviews error - $e');
      emit(MyReviewsError('Failed to load user reviews: ${e.toString()}'));
    }
  }

  Future<void> _onMarkReviewHelpful(
    MarkReviewHelpful event,
    Emitter<ReviewState> emit,
  ) async {
    final currentReviews = _getCurrentReviews();
    _getCurrentStatistics();
    
    try {
      print('👍 ReviewBloc: Marking review ${event.reviewId} as ${event.isHelpful ? "helpful" : "not helpful"}');
      
      final response = await _reviewRepository.markReviewHelpful(event.reviewId, event.isHelpful);

      if (response.isSuccess) {
        // Update the review's helpful status locally
        final updatedReviews = currentReviews.map((review) {
          if (review.id == event.reviewId) {
            return review.copyWith(
              isHelpful: event.isHelpful,
              helpfulCount: event.isHelpful 
                  ? review.helpfulCount + 1 
                  : review.helpfulCount - 1,
            );
          }
          return review;
        }).toList();
        
        print('✅ ReviewBloc: Successfully marked review as ${event.isHelpful ? "helpful" : "not helpful"}');
        
        if (state is ReviewLoaded) {
          emit((state as ReviewLoaded).copyWith(reviews: updatedReviews));
        }
      } else {
        print('❌ ReviewBloc: Failed to mark review - ${response.error}');
        // Don't emit error state for this action, just log it
      }
    } catch (e) {
      print('❌ ReviewBloc: Mark review helpful error - $e');
      // Don't emit error state for this action, just log it
    }
  }

  Future<void> _onRefreshReviews(
    RefreshReviews event,
    Emitter<ReviewState> emit,
  ) async {
    add(LoadProductReviews(productId: event.productId));
  }

  Future<void> _onClearReviews(
    ClearReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewInitial());
  }

  List<Review> _getCurrentReviews() {
    if (state is ReviewLoaded) {
      return (state as ReviewLoaded).reviews;
    } else if (state is ReviewActionLoading) {
      return (state as ReviewActionLoading).currentReviews;
    } else if (state is ReviewActionSuccess) {
      return (state as ReviewActionSuccess).reviews;
    } else if (state is ReviewActionError) {
      return (state as ReviewActionError).currentReviews;
    } else if (state is ReviewLoadingMore) {
      return (state as ReviewLoadingMore).currentReviews;
    } else if (state is ReviewError && (state as ReviewError).previousReviews != null) {
      return (state as ReviewError).previousReviews!;
    }
    return [];
  }

  ReviewStatistics? _getCurrentStatistics() {
    if (state is ReviewLoaded) {
      return (state as ReviewLoaded).statistics;
    } else if (state is ReviewActionLoading) {
      return (state as ReviewActionLoading).statistics;
    } else if (state is ReviewActionSuccess) {
      return (state as ReviewActionSuccess).statistics;
    } else if (state is ReviewActionError) {
      return (state as ReviewActionError).statistics;
    } else if (state is ReviewLoadingMore) {
      return (state as ReviewLoadingMore).statistics;
    } else if (state is ReviewError) {
      return (state as ReviewError).statistics;
    }
    return null;
  }
}