import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/models/review_model.dart';
import '../../logic/review_bloc.dart';
import '../../logic/review_event.dart';
import '../../logic/review_state.dart';

class AddReviewDialog extends StatefulWidget {
  final String productId;
  final Review? existingReview; // For editing
  final VoidCallback? onReviewAdded;

  const AddReviewDialog({
    super.key,
    required this.productId,
    this.existingReview,
    this.onReviewAdded,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  double _rating = 5.0;
  final List<File> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _titleController.text = widget.existingReview!.title;
      _commentController.text = widget.existingReview!.comment;
      _rating = widget.existingReview!.rating.toDouble();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(
            images.map((xFile) => File(xFile.path)).toList(),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick images: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitReview() {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSubmitting = true;
    });

    if (widget.existingReview != null) {
      // Update existing review
      final updateRequest = UpdateReviewRequest(
        reviewId: widget.existingReview!.id,
        title: _titleController.text.trim(),
        comment: _commentController.text.trim(),
        rating: _rating.toInt(),
        images: _selectedImages.map((file) => file.path).toList(),
      );
      
      context.read<ReviewBloc>().add(UpdateReview(updateRequest));
    } else {
      // Add new review
      final addRequest = AddReviewRequest(
        productId: int.tryParse(widget.productId.toString()) ?? 0,
        title: _titleController.text.trim(),
        comment: _commentController.text.trim(),
        rating: _rating.toInt(),
        images: _selectedImages.map((file) => file.path).toList(),
      );
      
      context.read<ReviewBloc>().add(AddReview(addRequest));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is ReviewActionSuccess) {
          setState(() {
            _isSubmitting = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.of(context).pop();
          widget.onReviewAdded?.call();
        } else if (state is ReviewActionError) {
          setState(() {
            _isSubmitting = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.existingReview != null 
                            ? 'Edit Review' 
                            : 'Write a Review',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating
                        const Text(
                          'Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = (index + 1).toDouble();
                                  });
                                },
                                child: Icon(
                                  index < _rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 32,
                                ),
                              );
                            }),
                            const SizedBox(width: 16),
                            Text(
                              _getRatingText(_rating),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _getRatingColor(_rating),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Title
                        const Text(
                          'Review Title (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: 'Summarize your review in a few words',
                            border: OutlineInputBorder(),
                          ),
                          maxLength: 100,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Comment
                        const Text(
                          'Your Review *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Share your experience with this product',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 4,
                          maxLength: 1000,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please write your review';
                            }
                            if (value.trim().length < 10) {
                              return 'Review must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Images
                        Row(
                          children: [
                            const Text(
                              'Photos (Optional)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _selectedImages.length < 5 ? _pickImages : null,
                              icon: const Icon(Icons.add_photo_alternate),
                              label: const Text('Add Photos'),
                            ),
                          ],
                        ),
                        
                        if (_selectedImages.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              _selectedImages[index],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You can add up to 5 photos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReview,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(widget.existingReview != null ? 'Update' : 'Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    switch (rating.toInt()) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Rate this product';
    }
  }

  Color _getRatingColor(double rating) {
    switch (rating.toInt()) {
      case 1:
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}