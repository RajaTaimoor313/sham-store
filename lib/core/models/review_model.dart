class Review {
  final int id;
  final int productId;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String title;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? images;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final bool isHelpful;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    this.title = '',
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.images,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.isHelpful = false,
  });

  // Convenience getter for verifiedPurchase
  bool get verifiedPurchase => isVerifiedPurchase;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? json['user']?['name'] ?? 'Anonymous',
      userAvatar: json['user_avatar'] ?? json['user']?['avatar'],
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      images: json['images'] != null 
          ? List<String>.from(json['images'])
          : null,
      isVerifiedPurchase: json['is_verified_purchase'] ?? false,
      helpfulCount: json['helpful_count'] ?? 0,
      isHelpful: json['is_helpful'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'title': title,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'images': images,
      'is_verified_purchase': isVerifiedPurchase,
      'helpful_count': helpfulCount,
      'is_helpful': isHelpful,
    };
  }

  Review copyWith({
    int? id,
    int? productId,
    int? userId,
    String? userName,
    String? userAvatar,
    int? rating,
    String? title,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? images,
    bool? isVerifiedPurchase,
    int? helpfulCount,
    bool? isHelpful,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isHelpful: isHelpful ?? this.isHelpful,
    );
  }
}

class ReviewStatistics {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final int verifiedPurchases;
  final double recommendationPercentage;
  final int verifiedPurchaseCount;
  final int reviewsWithPhotosCount;
  final int totalHelpfulVotes;

  ReviewStatistics({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.verifiedPurchases,
    required this.recommendationPercentage,
    required this.verifiedPurchaseCount,
    required this.reviewsWithPhotosCount,
    required this.totalHelpfulVotes,
  });

  // Convenience getters for star counts
  int get fiveStarCount => ratingDistribution[5] ?? 0;
  int get fourStarCount => ratingDistribution[4] ?? 0;
  int get threeStarCount => ratingDistribution[3] ?? 0;
  int get twoStarCount => ratingDistribution[2] ?? 0;
  int get oneStarCount => ratingDistribution[1] ?? 0;

  factory ReviewStatistics.fromJson(Map<String, dynamic> json) {
    return ReviewStatistics(
      averageRating: _parseDouble(json['average_rating']),
      totalReviews: _parseInt(json['total_reviews']),
      ratingDistribution: _parseRatingDistribution(json['rating_distribution']),
      verifiedPurchases: _parseInt(json['verified_purchases']),
      recommendationPercentage: _parseDouble(json['recommendation_percentage']),
      verifiedPurchaseCount: _parseInt(json['verified_purchase_count']),
      reviewsWithPhotosCount: _parseInt(json['reviews_with_photos_count']),
      totalHelpfulVotes: _parseInt(json['total_helpful_votes']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static Map<int, int> _parseRatingDistribution(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      final Map<int, int> result = {};
      value.forEach((key, val) {
        final intKey = _parseInt(key);
        final intVal = _parseInt(val);
        if (intKey > 0) result[intKey] = intVal;
      });
      return result;
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'rating_distribution': ratingDistribution,
      'verified_purchases': verifiedPurchases,
      'recommendation_percentage': recommendationPercentage,
      'verified_purchase_count': verifiedPurchaseCount,
      'reviews_with_photos_count': reviewsWithPhotosCount,
      'total_helpful_votes': totalHelpfulVotes,
    };
  }
}

class AddReviewRequest {
  final int productId;
  final int rating;
  final String title;
  final String comment;
  final List<String>? images;

  AddReviewRequest({
    required this.productId,
    required this.rating,
    required this.title,
    required this.comment,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images,
    };
  }
}

class UpdateReviewRequest {
  final int reviewId;
  final int? rating;
  final String? title;
  final String? comment;
  final List<String>? images;

  UpdateReviewRequest({
    required this.reviewId,
    this.rating,
    this.title,
    this.comment,
    this.images,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'review_id': reviewId};
    if (rating != null) data['rating'] = rating;
    if (title != null) data['title'] = title;
    if (comment != null) data['comment'] = comment;
    if (images != null) data['images'] = images;
    return data;
  }
}