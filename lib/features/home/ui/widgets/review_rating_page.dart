import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
class ReviewModel extends StatelessWidget {
  final String name;
  final String review;
  final double rate;
  final Color avatarColor;

  const ReviewModel({
    super.key,
    required this.name,
    required this.review,
    required this.rate,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: avatarColor,
            child:  Icon(
              Icons.person,
              size: 35.sp,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // الاسم
          Text(
            name,
            style:  TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
           SizedBox(height: 8.h),

          // النجوم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rate.round()
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                );
              }),
               SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  rate.toStringAsFixed(1),
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
           SizedBox(height: 12.h),

          // المراجعة
          Text(
            review,
            textAlign: TextAlign.center,
            style:  TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ReviewRatingPage extends StatelessWidget {
  const ReviewRatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating & Reviews'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children:  [
                  Expanded(
                    child: ReviewModel(
                      name: 'خالد سعد',
                      review:
                          'Super comfortable and stylish! Perfect for long walks.',
                      rate: 3.0,
                      avatarColor: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ReviewModel(
                      name: 'Samir Ahmad',
                      review:
                          'Super comfortable and stylish! Perfect for long walks.',
                      rate: 4.0,
                      avatarColor: Colors.purple,
                    ),
                  ),
                ],
              ),
              verticalspace(20.h),
              Row(
                children:  [
                  Expanded(
                    child: ReviewModel(
                      name: 'خالد سعد',
                      review:
                          'Super comfortable and stylish! Perfect for long walks.',
                      rate: 3.0,
                      avatarColor: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ReviewModel(
                      name: 'Samir Ahmad',
                      review:
                          'Super comfortable and stylish! Perfect for long walks.',
                      rate: 4.0,
                      avatarColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
