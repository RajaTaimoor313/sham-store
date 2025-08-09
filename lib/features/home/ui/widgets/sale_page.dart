import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';

class SalePage extends StatelessWidget {
  final String imageUrl1;
  final String title1;
  final String subtitle1;
  final VoidCallback onTap1;

  final String imageUrl2;
  final String title2;
  final String subtitle2;
  final VoidCallback onTap2;

  const SalePage({
    super.key,
    required this.imageUrl1,
    required this.title1,
    required this.subtitle1,
    required this.onTap1,
    required this.imageUrl2,
    required this.title2,
    required this.subtitle2,
    required this.onTap2, 
  });

  Widget buildSaleCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.black.withOpacity(0.45),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorsManager.mainWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  color: ColorsManager.mainWhite,
                  fontSize: 14,
                ),
              ),
              verticalspace(14.h),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                        context.tr('shop_now'),
                  style: TextStyle(
                    color: ColorsManager.mainWhite,
                    fontWeight: FontWeight.w200,
                    fontSize: 16.sp,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: buildSaleCard(
            context: context,
            imageUrl: imageUrl1,
            title: title1,
            subtitle: subtitle1,
            onTap: onTap1,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
          ),
        ),
        Expanded(
          child: buildSaleCard(
            context: context,
            imageUrl: imageUrl2,
            title: title2,
            subtitle: subtitle2,
            onTap: onTap2,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}
