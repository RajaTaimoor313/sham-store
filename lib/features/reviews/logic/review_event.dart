import 'package:equatable/equatable.dart';
import '../../../core/models/review_model.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductReviews extends ReviewEvent {
  final int productId;
  final int page;
  final int limit;
  final String sortBy;
  final String sortOrder;

  const LoadProductReviews({
    required this.productId,
    this.page = 1,
    this.limit = 10,
    this.sortBy = 'created_at',
    this.sortOrder = 'desc',
  });

  @override
  List<Object?> get props => [productId, page, limit, sortBy, sortOrder];
}

class LoadMoreProductReviews extends ReviewEvent {
  final int productId;
  final int page;
  final int limit;
  final String sortBy;
  final String sortOrder;

  const LoadMoreProductReviews({
    required this.productId,
    required this.page,
    this.limit = 10,
    this.sortBy = 'created_at',
    this.sortOrder = 'desc',
  });

  @override
  List<Object?> get props => [productId, page, limit, sortBy, sortOrder];
}

class LoadReviewStatistics extends ReviewEvent {
  final int productId;

  const LoadReviewStatistics(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddReview extends ReviewEvent {
  final AddReviewRequest request;

  const AddReview(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateReview extends ReviewEvent {
  final UpdateReviewRequest request;

  const UpdateReview(this.request);

  @override
  List<Object?> get props => [request];
}

class DeleteReview extends ReviewEvent {
  final int reviewId;

  const DeleteReview(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class LoadMyReviews extends ReviewEvent {
  final int page;
  final int limit;

  const LoadMyReviews({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

class MarkReviewHelpful extends ReviewEvent {
  final int reviewId;
  final bool isHelpful;

  const MarkReviewHelpful({
    required this.reviewId,
    required this.isHelpful,
  });

  @override
  List<Object?> get props => [reviewId, isHelpful];
}

class RefreshReviews extends ReviewEvent {
  final int productId;

  const RefreshReviews(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearReviews extends ReviewEvent {
  const ClearReviews();
}