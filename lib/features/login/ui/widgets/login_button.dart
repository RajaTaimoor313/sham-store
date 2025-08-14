import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.navigationMenu);
          },
          buttonText: context.tr('login'),
          textStyle: TextStyle(
            fontWeight: FontWeightHelper.medium,
            color: ColorsManager.mainWhite,
            fontSize: 20.sp,
          ),
        ),

        verticalspace(32.h),

        // خط منقط وكلمة OR
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1,
                height: 1,
                indent: 10.w,
                endIndent: 10.w,
              ),
            ),
            Text(
              context.tr('or'),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Expanded(
            //   child: Divider(
            //     color: Colors.grey.shade400,
            //     thickness: 1,
            //     height: 1,
            //     indent: 10.w,
            //     endIndent: 10.w,
            //   ),
            // ),
          ],
        ),
        // verticalspace(32.h),
        // AppTextButton(
        //   onPressed: () {},
        //   backgroundColor: ColorsManager.lightBlue,
        //   buttonText: 'Login with Google',
        //   textStyle: TextStyle(
        //     fontWeight: FontWeightHelper.medium,
        //     color: ColorsManager.mainBlue,
        //     fontSize: 16.sp,
        //   ),
        // ),
        verticalspace(38.h),
      ],
    );
  }
}
