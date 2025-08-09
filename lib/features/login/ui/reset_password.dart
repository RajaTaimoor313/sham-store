import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/features/login/widgets/reset_password_form.dart';
import 'package:flutter_shamstore/features/login/widgets/reset_password_button.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String token;

  const ResetPassword({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String password = '';
  String passwordConfirmation = '';
  bool isFormValid = false;

  void onPasswordChanged(String value) {
    setState(() {
      password = value;
      _validateForm();
    });
  }

  void onPasswordConfirmationChanged(String value) {
    setState(() {
      passwordConfirmation = value;
      _validateForm();
    });
  }

  void _validateForm() {
    isFormValid = password.isNotEmpty &&
        passwordConfirmation.isNotEmpty &&
        password == passwordConfirmation &&
        password.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Reset\n',
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
                  Text(
                    'Enter your new password below to reset your account password.',
                    style: TextStyle(
                      color: ColorsManager.mainGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  SvgPicture.asset(
                    'assets/svgs/Forget Password Illustration.svg',
                    height: 200.h,
                  ),
                  SizedBox(height: 36.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        ResetPasswordForm(
                          onPasswordChanged: onPasswordChanged,
                          onPasswordConfirmationChanged: onPasswordConfirmationChanged,
                        ),
                        SizedBox(height: 40.h),
                        ResetPasswordButton(
                          formKey: formKey,
                          isFormValid: isFormValid,
                          email: widget.email,
                          token: widget.token,
                          password: password,
                          passwordConfirmation: passwordConfirmation,
                        ),
                      ],
                    ),
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