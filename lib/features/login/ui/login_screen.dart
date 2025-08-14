import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/login_form.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ حل overflow
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),

                // Hello There! text
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: context.tr('login') + '\n',
                          style: TextStyle(
                            color: ColorsManager.mainBlue,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '',
                          style: TextStyle(
                            color: ColorsManager.mainOrange,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // وصف سطر واحد فقط
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    context.tr('enter_credentials_login'),
                    style: TextStyle(
                      color: ColorsManager.mainGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                verticalspace(32.h),
                LoginForm(),
                // verticalspace(38.h), // مسافة سفليّة
                //  LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
