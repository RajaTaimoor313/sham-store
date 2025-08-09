import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';

Widget buildPageIndicator(int currentPage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        width: 24.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: index == currentPage
              ? ColorsManager.mainBlue
              : ColorsManager.lightBlue,
          borderRadius: BorderRadius.circular(4.r),
        ),
      );
    }),
  );
}
