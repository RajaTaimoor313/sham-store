import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';

class ResetPasswordForm extends StatefulWidget {
  final Function(String) onPasswordChanged;
  final Function(String) onPasswordConfirmationChanged;

  const ResetPasswordForm({
    super.key,
    required this.onPasswordChanged,
    required this.onPasswordConfirmationChanged,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          hintText: 'New Password',
          isObscureText: isPasswordObscureText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordObscureText = !isPasswordObscureText;
              });
            },
            child: Icon(
              isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your new password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          controller: passwordController,
          onChanged: widget.onPasswordChanged,
        ),
        SizedBox(height: 18.h),
        AppTextFormField(
          hintText: 'Confirm New Password',
          isObscureText: isPasswordConfirmationObscureText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordConfirmationObscureText = !isPasswordConfirmationObscureText;
              });
            },
            child: Icon(
              isPasswordConfirmationObscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          controller: passwordConfirmationController,
          onChanged: widget.onPasswordConfirmationChanged,
        ),
      ],
    );
  }
}