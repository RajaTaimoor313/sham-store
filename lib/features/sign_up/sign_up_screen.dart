import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/repositories/auth_repository.dart';
import 'package:flutter_shamstore/core/models/auth_model.dart';
import 'package:flutter_shamstore/features/sign_up/ui/sign_up_button.dart';
import 'package:flutter_shamstore/features/sign_up/ui/sign_up_form.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SignUpFormState> _signUpFormKey =
      GlobalKey<SignUpFormState>();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final signUpFormState = _signUpFormKey.currentState;
    if (signUpFormState == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final registerRequest = RegisterRequest(
        name: signUpFormState.usernameController.text.trim(),
        email: signUpFormState.emailController.text.trim(),
        password: signUpFormState.passwordController.text,
        passwordConfirmation: signUpFormState.confirmPasswordController.text,
        phone: signUpFormState.contactController.text.trim(),
        agreeToTerms: true,
      );

      final response = await _authRepository.register(registerRequest);

      if (response.isSuccess) {
        // Add a small delay to ensure token is fully set in API service
        await Future.delayed(const Duration(milliseconds: 100));

        // Email verification will be handled via OTP only
        // Removed sendEmailVerification() to avoid sending duplicate emails

        // Registration successful, navigate to confirm email screen
        if (mounted) {
          Navigator.pushNamed(context, Routes.confirmemail);
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Registration failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
                          text: context.tr('sign_up') + '\n',
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
                    context.tr('fill_fields_create_account'),
                    style: TextStyle(
                      color: ColorsManager.mainBlack,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                verticalspace(32.h),
                Form(
                  key: _formKey,
                  child: SignUpForm(key: _signUpFormKey),
                ),
                verticalspace(38.h), // مسافة سفليّة
                SignUpButton(
                  onSignUpPressed: _isLoading ? null : _handleSignUp,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
