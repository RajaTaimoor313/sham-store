import 'package:flutter/material.dart';
import '../../../../core/models/review_model.dart';

class ReviewStatisticsWidget extends StatelessWidget {
  final ReviewStatistics statistics;

  const ReviewStatisticsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall rating section
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statistics.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStarRating(statistics.averageRating, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        '${statistics.totalReviews} reviews',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRatingBar(5, statistics.fiveStarCount, statistics.totalReviews),
                      _buildRatingBar(4, statistics.fourStarCount, statistics.totalReviews),
                      _buildRatingBar(3, statistics.threeStarCount, statistics.totalReviews),
                      _buildRatingBar(2, statistics.twoStarCount, statistics.totalReviews),
                      _buildRatingBar(1, statistics.oneStarCount, statistics.totalReviews),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Additional statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Verified Purchases',
                    '${statistics.verifiedPurchaseCount}',
                    Icons.verified,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'With Photos',
                    '${statistics.reviewsWithPhotosCount}',
                    Icons.photo_camera,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Helpful Votes',
                    '${statistics.totalHelpfulVotes}',
                    Icons.thumb_up,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(
            Icons.star,
            color: Colors.amber,
            size: size,
          );
        } else if (index < rating) {
          return Icon(
            Icons.star_half,
            color: Colors.amber,
            size: size,
          );
        } else {
          return Icon(
            Icons.star_border,
            color: Colors.amber,
            size: size,
          );
        }
      }),
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}