import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/features/categories/ui/product_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/features/categories/logic/category_cubit.dart';
import 'package:flutter_shamstore/features/categories/data/models/category_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/features/categories/data/category_repository.dart';

class MyAllCategories extends StatelessWidget {
  const MyAllCategories({super.key});

  // Default icon mapping for categories
  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    print('🔍 MyAllCategories: Getting icon for category: $categoryName (lowercase: $name)');
    
    IconData icon;
    if (name.contains('electronic') || name.contains('phone') || name.contains('tech')) {
      icon = Icons.phone_android;
    } else if (name.contains('fashion') || name.contains('cloth') || name.contains('apparel')) {
      icon = Icons.checkroom;
    } else if (name.contains('home') || name.contains('garden') || name.contains('furniture')) {
      icon = Icons.home;
    } else if (name.contains('sport') || name.contains('fitness') || name.contains('outdoor')) {
      icon = Icons.sports_soccer;
    } else if (name.contains('book') || name.contains('education') || name.contains('learning')) {
      icon = Icons.menu_book;
    } else if (name.contains('beauty') || name.contains('cosmetic') || name.contains('health')) {
       icon = Icons.face;
     } else {
       icon = Icons.category;
     }
     
     print('🎯 MyAllCategories: Selected icon for $categoryName: $icon');
     return icon;
   }

   // Default color mapping for categories
   Color _getCategoryColor(String categoryName) {
     final name = categoryName.toLowerCase();
     print('🎨 MyAllCategories: Getting color for category: $categoryName (lowercase: $name)');
     
     Color color;
     if (name.contains('electronic') || name.contains('phone') || name.contains('tech')) {
       color = Colors.blue;
     } else if (name.contains('fashion') || name.contains('cloth') || name.contains('apparel')) {
       color = Colors.pink;
     } else if (name.contains('home') || name.contains('garden') || name.contains('furniture')) {
       color = Colors.green;
     } else if (name.contains('sport') || name.contains('fitness') || name.contains('outdoor')) {
       color = Colors.orange;
     } else if (name.contains('book') || name.contains('education') || name.contains('learning')) {
       color = Colors.purple;
     } else if (name.contains('beauty') || name.contains('cosmetic') || name.contains('health')) {
       color = Colors.red;
     } else {
       color = ColorsManager.mainBlue;
     }
     
     print('🌈 MyAllCategories: Selected color for $categoryName: $color');
     return color;
   }

  @override
  Widget build(BuildContext context) {
    print('🎨 MyAllCategories: build() method called');
    
    return BlocProvider(
      create: (context) {
        print('🏗️ MyAllCategories: Creating CategoryCubit and calling loadCategories()');
        return CategoryCubit(repository: sl<CategoryRepository>())..loadCategories();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.mainWhite,
          title: Text(
            context.tr('all_categories'),
            style: TextStyle(
              color: ColorsManager.mainBlue,
              fontWeight: FontWeightHelper.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorsManager.mainBlue),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                print('🔄 MyAllCategories: BlocBuilder rebuilding with state: ${state.runtimeType}');
                
                if (state is CategoryLoading) {
                  print('⏳ MyAllCategories: Showing loading indicator');
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.mainBlue,
                    ),
                  );
                } else if (state is CategoryError) {
                  print('❌ MyAllCategories: Showing error state: ${state.message}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: Colors.red,
                        ),
                        verticalspace(16.h),
                        Text(
                          context.tr('error_loading_categories'),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsManager.mainBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        verticalspace(16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CategoryCubit>().loadCategories();
                          },
                          child: Text(context.tr('retry')),
                        ),
                      ],
                    ),
                  );
                } else if (state is CategoryLoaded) {
                  print('✅ MyAllCategories: CategoryLoaded state received');
                  final categories = state.categories;
                  print('📊 MyAllCategories: Displaying ${categories.length} categories');
                  
                  for (var category in categories) {
                    print('   📦 Category: ${category.name} (ID: ${category.id})');
                  }
                  
                  if (categories.isEmpty) {
                    print('📭 MyAllCategories: No categories to display');
                    return Center(
                      child: Text(
                        context.tr('no_categories_found'),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsManager.mainBlack,
                        ),
                      ),
                    );
                  }
                  
                  print('🎯 MyAllCategories: Building GridView with ${categories.length} items');
                  return GridView.builder(
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                       crossAxisSpacing: 12.w,
                       mainAxisSpacing: 12.h,
                       childAspectRatio: 1.0,
                     ),
                     itemCount: categories.length,
                     itemBuilder: (context, index) {
                       print('🏗️ MyAllCategories: Building grid item $index for ${categories[index].name}');
                       return _buildCategoryContainer(context, categories[index]);
                     },
                   );
                 }
                 return Container(); // Default fallback
               },
             ),
           ),
         ),
       ),
     );
   }

  Widget _buildCategoryContainer(BuildContext context, Category category) {
    print('🎨 MyAllCategories: Building container for category: ${category.name}');
    
    final categoryColor = _getCategoryColor(category.name);
    final categoryIcon = _getCategoryIcon(category.name);
    
    print('🎨 MyAllCategories: Category ${category.name} - Color: $categoryColor, Icon: $categoryIcon');
    
    return GestureDetector(
      onTap: () {
        print('👆 MyAllCategories: Category ${category.name} tapped, navigating to ProductsPage');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(categoryName: category.name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(categoryIcon, size: 24.w, color: categoryColor),
            ),
            verticalspace(8.h),
            Text(
              category.name,
              style: TextStyle(
                color: ColorsManager.mainBlack,
                fontSize: 12.sp,
                fontWeight: FontWeightHelper.medium,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
