import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';
import 'package:flutter_shamstore/features/cart/ui/my_cart_screen.dart';
import 'package:flutter_shamstore/features/home/ui/product_details_page.dart';

class AddToCartCompleteExample extends StatelessWidget {
  const AddToCartCompleteExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Cart Complete Example'),
        backgroundColor: ColorsManager.mainBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add to Cart Functionality Demo',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: ColorsManager.mainBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            
            Text(
              'Features Implemented:',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.mainBlue,
              ),
            ),
            SizedBox(height: 10.h),
            
            _buildFeatureItem('✅ Product Details Page with Add to Cart button'),
            _buildFeatureItem('✅ Toast message when item is added to cart'),
            _buildFeatureItem('✅ Cart screen accessible via bottom navigation'),
            _buildFeatureItem('✅ Cart displays list of added items'),
            _buildFeatureItem('✅ Total amount calculation'),
            _buildFeatureItem('✅ API integration for cart operations'),
            
            SizedBox(height: 30.h),
            
            Text(
              'Test the functionality:',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.mainBlue,
              ),
            ),
            SizedBox(height: 15.h),
            
            AppTextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      productId: 1,
                      productName: 'Nike Air Max Demo',
                      price: 199.99,
                      mainImageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
                      productImages: [
                        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=150&h=150&fit=crop',
                        'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=150&h=150&fit=crop',
                      ],
                      availableSizes: ['40', '41', '42'],
                      availableColors: [Colors.black, Colors.red, Colors.white],
                      description: 'Demo product for testing add to cart functionality',
                    ),
                  ),
                );
              },
              buttonText: 'Open Product Details',
              backgroundColor: ColorsManager.mainBlue,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: 15.h),
            
            AppTextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyCartScreen(),
                  ),
                );
              },
              buttonText: 'View Cart',
              backgroundColor: ColorsManager.mainOrange,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: 30.h),
            
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorsManager.lightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorsManager.mainBlue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to test:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorsManager.mainBlue,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '1. Tap "Open Product Details" to see the product page\n'
                    '2. Tap "Add to Cart" button to add item to cart\n'
                    '3. You\'ll see a toast message "Item added to cart"\n'
                    '4. Tap "View Cart" or use bottom navigation to see cart\n'
                    '5. Cart shows items with total amount calculation',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorsManager.mainGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorsManager.mainGrey,
        ),
      ),
    );
  }
}