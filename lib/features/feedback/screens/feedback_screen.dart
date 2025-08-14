import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/feedback_model.dart' as FeedbackModel;
import '../bloc/feedback_bloc.dart';
import '../../../core/localization/localization_helper.dart';
import '../../../core/themina/colors.dart';
import '../../../core/widgets/app_text_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _searchController = TextEditingController();

  int _selectedRating = 5;
  int _selectedScale = 9;
  bool _isCreatingFeedback = true;
  List<FeedbackModel.Feedback> _feedbacks = [];
  FeedbackModel.Feedback? _selectedFeedback;

  @override
  void dispose() {
    _feedbackController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providedBloc = context.read<FeedbackBloc>();
    // ignore: avoid_print
    print('[FeedbackScreen] Using provided FeedbackBloc: $providedBloc');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('feedback_title'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('feedback_created_successfully')),
                backgroundColor: ColorsManager.mainBlue,
              ),
            );
            _resetForm();
            context.read<FeedbackBloc>().add(const LoadAllFeedbacks());
          } else if (state is FeedbackUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('feedback_updated_successfully')),
                backgroundColor: ColorsManager.mainBlue,
              ),
            );
            _resetForm();
            context.read<FeedbackBloc>().add(const LoadAllFeedbacks());
          } else if (state is FeedbackDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('feedback_deleted_successfully')),
                backgroundColor: ColorsManager.mainBlue,
              ),
            );
            context.read<FeedbackBloc>().add(const LoadAllFeedbacks());
          } else if (state is FeedbacksLoaded) {
            setState(() {
              _feedbacks = state.feedbacks;
            });
          } else if (state is FeedbackError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle between Create and View modes
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isCreatingFeedback = true;
                            _selectedFeedback = null;
                          });
                          _resetForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCreatingFeedback
                              ? ColorsManager.mainBlue
                              : Colors.grey[300],
                          foregroundColor: _isCreatingFeedback
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(context.tr('create_feedback')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isCreatingFeedback = false;
                          });
                          context.read<FeedbackBloc>().add(
                            const LoadAllFeedbacks(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isCreatingFeedback
                              ? ColorsManager.mainBlue
                              : Colors.grey[300],
                          foregroundColor: !_isCreatingFeedback
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Text(context.tr('view_feedbacks')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_isCreatingFeedback)
                  ..._buildCreateFeedbackForm(state)
                else
                  ..._buildViewFeedbacksSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCreateFeedbackForm(FeedbackState state) {
    return [
      Text(
        _selectedFeedback == null
            ? context.tr('create_new_feedback')
            : context.tr('update_feedback'),
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),

      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Section
            Text(
              context.tr('rating_1_5'),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Icon(
                    Icons.star,
                    size: 32,
                    color: index < _selectedRating
                        ? ColorsManager.mainBlue
                        : Colors.grey[300],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Scale Section
            Text(
              context.tr('scale_1_10'),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _selectedScale.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _selectedScale.toString(),
              activeColor: ColorsManager.mainBlue,
              onChanged: (value) {
                setState(() {
                  _selectedScale = value.round();
                });
              },
            ),
            Text(
              '${context.tr('selected')}: $_selectedScale',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Content
            Text(
              context.tr('feedback_content'),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            AppTextFormField(
              controller: _feedbackController,
              hintText: context.tr('enter_feedback_hint'),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr('please_enter_feedback');
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state is FeedbackLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainBlue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  state is FeedbackLoading
                      ? context.tr('processing')
                      : (_selectedFeedback == null
                            ? context.tr('submit_feedback')
                            : context.tr('update_feedback_button')),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            if (_selectedFeedback != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    _resetForm();
                  },
                  child: Text(
                    context.tr('cancel_update'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildViewFeedbacksSection(FeedbackState state) {
    return [
      Text(
        context.tr('all_feedbacks'),
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),

      // Search Section
      Row(
        children: [
          Expanded(
            child: AppTextFormField(
              controller: _searchController,
              hintText: context.tr('search'),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.trim().isNotEmpty) {
                context.read<FeedbackBloc>().add(
                  SearchFeedbacks(_searchController.text.trim()),
                );
              } else {
                context.read<FeedbackBloc>().add(const LoadAllFeedbacks());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.mainBlue,
              foregroundColor: Colors.white,
            ),
            child: Text(context.tr('search')),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Feedbacks List
      if (state is FeedbackLoading)
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: ColorsManager.mainBlue),
          ),
        )
      else if (_feedbacks.isEmpty)
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              context.tr('no_feedbacks_found'),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      else
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _feedbacks.length,
          itemBuilder: (context, index) {
            final feedback = _feedbacks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Star Rating
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              color: starIndex < feedback.star
                                  ? ColorsManager.mainBlue
                                  : Colors.grey[300],
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${context.tr('scale_1_10').split(' ').first}: ${feedback.scale}/10',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        // Action Buttons
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editFeedback(feedback),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteFeedback(feedback.id!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feedback.feedbackContent,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    if (feedback.createdAt != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${context.tr('created')}: ${_formatDate(feedback.createdAt!)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
    ];
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final feedbackBloc = BlocProvider.of<FeedbackBloc>(context);
      if (_selectedFeedback == null) {
        // Create new feedback
        feedbackBloc.add(
          CreateFeedback(
            star: _selectedRating,
            feedbackContent: _feedbackController.text.trim(),
            scale: _selectedScale,
          ),
        );
      } else {
        // Update existing feedback
        feedbackBloc.add(
          UpdateFeedback(
            id: _selectedFeedback!.id!,
            star: _selectedRating,
            feedbackContent: _feedbackController.text.trim(),
            scale: _selectedScale,
          ),
        );
      }
    }
  }

  void _editFeedback(FeedbackModel.Feedback feedback) {
    setState(() {
      _isCreatingFeedback = true;
      _selectedFeedback = feedback;
      _selectedRating = feedback.star;
      _selectedScale = feedback.scale;
      _feedbackController.text = feedback.feedbackContent;
    });
  }

  void _deleteFeedback(int id) {
    final bloc = context.read<FeedbackBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('delete_feedback')),
        content: Text(context.tr('delete_feedback_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(DeleteFeedback(id));
            },
            child: Text(
              context.tr('delete_feedback'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedFeedback = null;
      _selectedRating = 5;
      _selectedScale = 9;
    });
    _feedbackController.clear();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
