import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/enter_reset_code_form.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/enter_reset_code_button.dart';

class EnterResetCode extends StatefulWidget {
  final String email;

  const EnterResetCode({super.key, required this.email});

  @override
  State<EnterResetCode> createState() => _EnterResetCodeState();
}

class _EnterResetCodeState extends State<EnterResetCode> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String resetCode = '';
  String password = '';
  String passwordConfirmation = '';
  bool isFormValid = false;

  void onResetCodeChanged(String value) {
    setState(() {
      resetCode = value;
      _validateForm();
    });
  }

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
    isFormValid =
        resetCode.isNotEmpty &&
        password.isNotEmpty &&
        passwordConfirmation.isNotEmpty &&
        password == passwordConfirmation &&
        password.length >= 6 &&
        resetCode.length >= 4;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),

                  // Enter Reset Code title
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Enter\n',
                            style: TextStyle(
                              color: ColorsManager.mainBlue,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Reset Code',
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

                  // Description
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      'Enter the reset code sent to your email, then create your new password.',
                      style: TextStyle(
                        color: ColorsManager.mainGrey,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  verticalspace(32.h),
                  Center(
                    child: SvgPicture.asset(
                      'assets/svgs/Mail Sent Illustration.svg',
                      height: 200.h,
                    ),
                  ),

                  verticalspace(32.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        EnterResetCodeForm(
                          onResetCodeChanged: onResetCodeChanged,
                          onPasswordChanged: onPasswordChanged,
                          onPasswordConfirmationChanged:
                              onPasswordConfirmationChanged,
                        ),
                        SizedBox(height: 40.h),
                        EnterResetCodeButton(
                          formKey: formKey,
                          isFormValid: isFormValid,
                          email: widget.email,
                          resetCode: resetCode,
                          password: password,
                          passwordConfirmation: passwordConfirmation,
                        ),
                      ],
                    ),
                  ),
                  verticalspace(38.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
