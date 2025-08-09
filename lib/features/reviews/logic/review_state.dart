import 'package:equatable/equatable.dart';
import '../../../core/models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewLoadingMore extends ReviewState {
  final List<Review> currentReviews;
  final ReviewStatistics? statistics;

  const ReviewLoadingMore({
    required this.currentReviews,
    this.statistics,
  });

  @override
  List<Object?> get props => [currentReviews, statistics];
}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final ReviewStatistics? statistics;
  final bool hasMoreReviews;
  final int currentPage;
  final int productId;

  const ReviewLoaded({
    required this.reviews,
    this.statistics,
    this.hasMoreReviews = false,
    this.currentPage = 1,
    required this.productId,
  });

  @override
  List<Object?> get props => [
    reviews,
    statistics,
    hasMoreReviews,
    currentPage,
    productId,
  ];

  ReviewLoaded copyWith({
    List<Review>? reviews,
    ReviewStatistics? statistics,
    bool? hasMoreReviews,
    int? currentPage,
    int? productId,
  }) {
    return ReviewLoaded(
      reviews: reviews ?? this.reviews,
      statistics: statistics ?? this.statistics,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
      currentPage: currentPage ?? this.currentPage,
      productId: productId ?? this.productId,
    );
  }
}

class ReviewError extends ReviewState {
  final String message;
  final List<Review>? previousReviews;
  final ReviewStatistics? statistics;

  const ReviewError({
    required this.message,
    this.previousReviews,
    this.statistics,
  });

  @override
  List<Object?> get props => [message, previousReviews, statistics];
}

class ReviewActionLoading extends ReviewState {
  final List<Review> currentReviews;
  final ReviewStatistics? statistics;
  final String action; // 'adding', 'updating', 'deleting', 'marking_helpful'

  const ReviewActionLoading({
    required this.currentReviews,
    this.statistics,
    required this.action,
  });

  @override
  List<Object?> get props => [currentReviews, statistics, action];
}

class ReviewActionSuccess extends ReviewState {
  final List<Review> reviews;
  final ReviewStatistics? statistics;
  final String message;
  final String action;

  const ReviewActionSuccess({
    required this.reviews,
    this.statistics,
    required this.message,
    required this.action,
  });

  @override
  List<Object?> get props => [reviews, statistics, message, action];
}

class ReviewActionError extends ReviewState {
  final List<Review> currentReviews;
  final ReviewStatistics? statistics;
  final String message;
  final String action;

  const ReviewActionError({
    required this.currentReviews,
    this.statistics,
    required this.message,
    required this.action,
  });

  @override
  List<Object?> get props => [currentReviews, statistics, message, action];
}

class MyReviewsLoading extends ReviewState {
  const MyReviewsLoading();
}

class MyReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  final bool hasMoreReviews;
  final int currentPage;

  const MyReviewsLoaded({
    required this.reviews,
    this.hasMoreReviews = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [reviews, hasMoreReviews, currentPage];
}

class MyReviewsError extends ReviewState {
  final String message;

  const MyReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}