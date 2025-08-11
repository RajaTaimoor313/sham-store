import 'package:flutter/material.dart';
import '../../../../core/models/review_model.dart';
import '../product_reviews_screen.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final String productId;
  final String productName;
  final ReviewStatistics? statistics;
  final List<Review> recentReviews;
  final bool isLoading;
  final VoidCallback? onViewAllPressed;

  const ReviewSummaryWidget({
    super.key,
    required this.productId,
    required this.productName,
    this.statistics,
    this.recentReviews = const [],
    this.isLoading = false,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (statistics == null || statistics!.totalReviews == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No reviews yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Be the first to review this product!',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _navigateToReviews(context),
                      child: const Text('Write a Review'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onViewAllPressed ?? () => _navigateToReviews(context),
                  child: const Text('View All'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Rating summary
            Row(
              children: [
                Text(
                  statistics!.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStarRating(statistics!.averageRating),
                    const SizedBox(height: 4),
                    Text(
                      '${statistics!.totalReviews} reviews',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    if (statistics!.verifiedPurchaseCount > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${statistics!.verifiedPurchaseCount} verified',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    if (statistics!.reviewsWithPhotosCount > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 16,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${statistics!.reviewsWithPhotosCount} with photos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            
            // Rating distribution (compact)
            if (statistics!.totalReviews > 0)
              Column(
                children: [
                  const SizedBox(height: 16),
                  _buildCompactRatingDistribution(),
                ],
              ),
            
            // Recent reviews preview
            if (recentReviews.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Reviews',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recentReviews.take(2).map((review) => _buildReviewPreview(review)),
                ],
              ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _navigateToReviews(context),
                    child: const Text('View All Reviews'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _navigateToReviews(context),
                    child: const Text('Write Review'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          );
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: Colors.amber,
            size: 16,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }
      }),
    );
  }

  Widget _buildCompactRatingDistribution() {
    final total = statistics!.totalReviews;
    
    return Column(
      children: [
        _buildCompactRatingBar(5, statistics!.fiveStarCount, total),
        _buildCompactRatingBar(4, statistics!.fourStarCount, total),
        _buildCompactRatingBar(3, statistics!.threeStarCount, total),
        _buildCompactRatingBar(2, statistics!.twoStarCount, total),
        _buildCompactRatingBar(1, statistics!.oneStarCount, total),
      ],
    );
  }

  Widget _buildCompactRatingBar(int stars, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 10,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 20,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewPreview(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStarRating(review.rating.toDouble()),
                const SizedBox(width: 8),
                Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (review.verifiedPurchase)
                  Icon(
                    Icons.verified,
                    size: 12,
                    color: Colors.green.shade600,
                  ),
              ],
            ),
            if (review.title.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    review.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToReviews(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductReviewsScreen(
          productId: productId,
          productName: productName,
        ),
      ),
    );
  }
}