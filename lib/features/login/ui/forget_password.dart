import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/forget_button.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/forget_form.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_svg/svg.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<ForgetFormState> _formKey = GlobalKey<ForgetFormState>();
  
  String _email = '';
  bool _isFormValid = false;
  
  void _onEmailChanged(String email) {
    setState(() {
      _email = email;
    });
  }
  
  void _onFormValidityChanged(bool isValid) {
    setState(() {
      _isFormValid = isValid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
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
                            text: 'Forget\n',
                            style: TextStyle(
                              color: ColorsManager.mainBlue,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Password',
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
                      'Forgot your password? Dont worry — weve got you.\n Enter your email and we will send you a reset link.',
                      style: TextStyle(
                        color: ColorsManager.mainGrey,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  verticalspace(32.h),
                  Center(
                    child: SvgPicture.asset('assets/svgs/Forget Password Illustration.svg'),
                  ),

                  verticalspace(32.h),
                  ForgetForm(
                    key: _formKey,
                    onEmailChanged: _onEmailChanged,
                    onFormValidityChanged: _onFormValidityChanged,
                  ),
                  verticalspace(38.h), // مسافة سفليّة
                  ForgetButton(
                    formKey: _formKey,
                    email: _email,
                    isFormValid: _isFormValid,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
