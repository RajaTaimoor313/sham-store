import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class SignUpButton extends StatelessWidget {
  final VoidCallback? onSignUpPressed;
  final bool isLoading;
  const SignUpButton({super.key, this.onSignUpPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextButton(
          onPressed: isLoading
              ? null
              : (onSignUpPressed ??
                    () {
                      Navigator.pushNamed(context, Routes.confirmemail);
                    }),
          buttonText: isLoading ? '' : context.tr('sign_up'),
          textStyle: TextStyle(
            fontWeight: FontWeightHelper.medium,
            color: ColorsManager.mainWhite,
            fontSize: 20.sp,
          ),
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorsManager.mainWhite,
                    ),
                  ),
                )
              : null,
        ),
        verticalspace(16.h),

        // Text "Login" clickable
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr('already_have_account'),
              style: TextStyle(fontSize: 14.sp, color: ColorsManager.mainGrey),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.loginscreen);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.tr('login'),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorsManager.mainBlue,
                  fontWeight: FontWeightHelper.semiBold,
                ),
              ),
            ),
          ],
        ),

        verticalspace(32.h),
        // تمت إزالة زر "تسجيل الدخول بجوجل" حسب المتطلبات
        verticalspace(38.h),
      ],
    );
  }
}
