import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

class PromoSectionWhite extends StatelessWidget {
  final VoidCallback? onTap;

  final String image1;
  final String image2;
  final String image3;

  final String title1;
  final String title2;
  final String title3;

  final String text1;
  final String text2;
  final String text3;

  const PromoSectionWhite({
    super.key,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.text1,
    required this.text2,
    required this.text3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> images = [image1, image2, image3];
    final List<String> titles = [title1, title2, title3];
    final List<String> texts = [text1, text2, text3];

    // الألوان ثابتة بحسب الترتيب المطلوب
    final List<Color> backgrounds = [
      ColorsManager.mainBlue,
      ColorsManager.mainOrange,
      ColorsManager.mainBlue,
    ];

    return Container(
      height: 1000.h,
      width: double.infinity,
      color: ColorsManager.mainWhite,
      padding: EdgeInsets.all(10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return Container(
            height: 300.h,
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: backgrounds[index],
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                bool isArabicMode = languageState is LanguageLoaded && languageState.languageCode == 'ar';
                return Row(
                  textDirection: isArabicMode ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                // صورة يمين
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    images[index],
                    height: 150.h,
                    width: 150.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 16.w),

                // كتابات + زر يسار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        titles[index],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.mainWhite,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        texts[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorsManager.mainWhite,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.mainWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Shop',
                          style: TextStyle(
                            color: ColorsManager.mainWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
