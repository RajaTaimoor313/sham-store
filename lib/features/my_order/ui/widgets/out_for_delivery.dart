import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/my_order/ui/widgets/feed_back_page.dart';

class OutForDelivery extends StatelessWidget {
  const OutForDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الجزء العلوي
              Container(
                width: double.infinity,
                height: 400, // قللت الارتفاع لتجنب المشاكل
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // الصورة الرئيسية
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
                        width: 200, // تطبيق العرض المطلوب
                        height: 200, // تطبيق الارتفاع المطلوب
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // الصور الصغيرة مع إصلاح الـ overflow
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildSmallImage(
                            'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=150&h=150&fit=crop',
                          ),
                          _buildSmallImage(
                            'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=150&h=150&fit=crop',
                          ),
                          _buildSmallImage(
                            'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=150&h=150&fit=crop',
                          ),
                          _buildSmallImage(
                            'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=150&h=150&fit=crop',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // باقي المحتوى
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nike Air Max',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Out for Delivery',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Step into all-day comfort and iconic style with Nike Air Max...',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Size: Medium"),
                        Text("Color: White"),
                        Text("Qty: 1"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            _dot(true),
                            _line(true),
                            _dot(true),
                            _line(true),
                            _dot(true),
                            _line(true),
                            _dot(true),
                            _line(false),
                            _dot(false),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _statusText('Order Placed', true),
                            const SizedBox(height: 30),
                            _statusText('Order Confirmed', true),
                            const SizedBox(height: 30),
                            _statusText('Order Packed', true),
                            const SizedBox(height: 30),
                            _statusText('Out for Delivery', true),
                            const SizedBox(height: 30),
                            _statusText('Delivered', false),
                          ],
                        ),
                      ],
                    ),
                    verticalspace(35.h),
                    Center(
                      child: AppTextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FeedBackPage(),
                            ),
                          );
                        },
                        buttonText: 'FeedBack',
                        textStyle: TextStyle(
                          fontWeight: FontWeightHelper.medium,
                          color: ColorsManager.mainWhite,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    verticalspace(16.h)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.green : Colors.grey[300],
      ),
    );
  }

  Widget _line(bool active) {
    return Container(
      width: 2,
      height: 40,
      color: active ? Colors.green : Colors.grey[300],
    );
  }

  Widget _statusText(String text, bool isActive) {
    return Text(
      text,
      style: TextStyle(
        color: isActive ? Colors.black : Colors.grey,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}

Widget _buildSmallImage(String imageUrl) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 75, // تطبيق العرض المطلوب
        height: 75, // تطبيق الارتفاع المطلوب
        fit: BoxFit.cover,
      ),
    ),
  );
}
