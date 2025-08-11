import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/review_model.dart';
import '../logic/review_bloc.dart';
import '../logic/review_event.dart';
import '../logic/review_state.dart';
import 'widgets/review_item.dart';
import 'widgets/review_statistics_widget.dart';
import 'widgets/add_review_dialog.dart';

class ProductReviewsScreen extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductReviewsScreen({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'created_at';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadReviews() {
    context.read<ReviewBloc>().add(
      LoadProductReviews(
        productId: int.tryParse(widget.productId) ?? 0,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<ReviewBloc>().state;
      if (state is ReviewLoaded && state.hasMoreReviews) {
        context.read<ReviewBloc>().add(
          LoadMoreProductReviews(
            productId: int.tryParse(widget.productId) ?? 0,
            page: state.currentPage + 1,
            sortBy: _sortBy,
            sortOrder: _sortOrder,
          ),
        );
      }
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Newest First', 'created_at', 'desc'),
            _buildSortOption('Oldest First', 'created_at', 'asc'),
            _buildSortOption('Highest Rating', 'rating', 'desc'),
            _buildSortOption('Lowest Rating', 'rating', 'asc'),
            _buildSortOption('Most Helpful', 'helpful_count', 'desc'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String sortBy, String sortOrder) {
    final isSelected = _sortBy == sortBy && _sortOrder == sortOrder;
    
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() {
          _sortBy = sortBy;
          _sortOrder = sortOrder;
        });
        Navigator.pop(context);
        _loadReviews();
      },
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        productId: widget.productId,
        onReviewAdded: () {
          // Refresh reviews after adding
          context.read<ReviewBloc>().add(
            RefreshReviews(int.tryParse(widget.productId) ?? 0),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.productName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReviewError && state.previousReviews == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReviews,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final reviews = _getReviewsFromState(state);
          final statistics = _getStatisticsFromState(state);
          final isLoadingMore = state is ReviewLoadingMore;
          final hasError = state is ReviewError;

          if (reviews.isEmpty && !hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.rate_review_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Be the first to review this product!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _showAddReviewDialog,
                    child: const Text('Write a Review'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReviewBloc>().add(
                RefreshReviews(int.tryParse(widget.productId) ?? 0),
              );
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (statistics != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ReviewStatisticsWidget(statistics: statistics),
                    ),
                  ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${reviews.length} Reviews',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showAddReviewDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Write Review'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < reviews.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ReviewItem(
                            review: reviews[index],
                            onHelpfulPressed: (reviewId, isHelpful) {
                              context.read<ReviewBloc>().add(
                                MarkReviewHelpful(
                                  reviewId: int.tryParse(reviewId) ?? 0,
                                  isHelpful: isHelpful,
                                ),
                              );
                            },
                          ),
                        );
                      } else if (isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return null;
                    },
                    childCount: reviews.length + (isLoadingMore ? 1 : 0),
                  ),
                ),
                
                if (hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                (state).message,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _loadReviews,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Review> _getReviewsFromState(ReviewState state) {
    if (state is ReviewLoaded) return state.reviews;
    if (state is ReviewLoadingMore) return state.currentReviews;
    if (state is ReviewActionLoading) return state.currentReviews;
    if (state is ReviewActionSuccess) return state.reviews;
    if (state is ReviewActionError) return state.currentReviews;
    if (state is ReviewError && state.previousReviews != null) {
      return state.previousReviews!;
    }
    return [];
  }

  ReviewStatistics? _getStatisticsFromState(ReviewState state) {
    if (state is ReviewLoaded) return state.statistics;
    if (state is ReviewLoadingMore) return state.statistics;
    if (state is ReviewActionLoading) return state.statistics;
    if (state is ReviewActionSuccess) return state.statistics;
    if (state is ReviewActionError) return state.statistics;
    if (state is ReviewError) return state.statistics;
    return null;
  }
}