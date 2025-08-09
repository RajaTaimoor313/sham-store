import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';

class HomeCategories extends StatelessWidget {
  final List<IconData> icons;
  final List<String> categoryNames;
  final Function(String categoryName, int index)? onCategoryTap;

  const HomeCategories({
    super.key,
    required this.icons,
    required this.categoryNames,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // استدعاء دالة النقر إذا كانت موجودة
              if (onCategoryTap != null) {
                onCategoryTap!(categoryNames[index], index);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.mainBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColorsManager.mainBlue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icons[index],
                      color: ColorsManager.mainBlue,
                      size: 28.w,
                    ),
                  ),
                  verticalspace(8.h),
                  Text(
                    categoryNames[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorsManager.mainBlack,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}