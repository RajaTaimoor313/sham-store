import 'package:flutter/material.dart';
import '../../../../core/models/review_model.dart';
import 'package:intl/intl.dart';

class ReviewItem extends StatelessWidget {
  final Review review;
  final Function(String reviewId, bool isHelpful)? onHelpfulPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final bool showActions;

  const ReviewItem({
    Key? key,
    required this.review,
    this.onHelpfulPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  child: review.userAvatar != null && review.userAvatar!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            review.userAvatar!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                review.userName.isNotEmpty 
                                    ? review.userName[0].toUpperCase() 
                                    : 'U',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          review.userName.isNotEmpty 
                              ? review.userName[0].toUpperCase() 
                              : 'U',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStarRating(review.rating.toDouble()),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(review.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onEditPressed != null || onDeletePressed != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEditPressed != null) {
                        onEditPressed!();
                      } else if (value == 'delete' && onDeletePressed != null) {
                        onDeletePressed!();
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEditPressed != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                      if (onDeletePressed != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Review title
            if (review.title.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            
            // Review content
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            
            // Review images
            if (review.images?.isNotEmpty == true)
              Column(
                children: [
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: review.images?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _showImageDialog(context, review.images!, index),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                review.images![index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Helpful section
            if (showActions)
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onHelpfulPressed != null
                        ? () => onHelpfulPressed!(review.id.toString(), !review.isHelpful)
                        : null,
                    icon: Icon(
                      review.isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 18,
                      color: review.isHelpful ? Colors.blue : Colors.grey,
                    ),
                    label: Text(
                      'Helpful (${review.helpfulCount})',
                      style: TextStyle(
                        color: review.isHelpful ? Colors.blue : Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (review.verifiedPurchase)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Purchase',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  void _showImageDialog(BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white,
                            size: 64,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}