import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';

class EnterResetCodeForm extends StatefulWidget {
  final Function(String) onResetCodeChanged;
  final Function(String) onPasswordChanged;
  final Function(String) onPasswordConfirmationChanged;

  const EnterResetCodeForm({
    super.key,
    required this.onResetCodeChanged,
    required this.onPasswordChanged,
    required this.onPasswordConfirmationChanged,
  });

  @override
  State<EnterResetCodeForm> createState() => _EnterResetCodeFormState();
}

class _EnterResetCodeFormState extends State<EnterResetCodeForm> {
  bool isPasswordObscureText = true;
  bool isPasswordConfirmationObscureText = true;
  late TextEditingController resetCodeController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  @override
  void initState() {
    super.initState();
    resetCodeController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    resetCodeController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          controller: resetCodeController,
          labelText: 'Reset Code',
          prefixIcon: const Icon(Icons.security),
          hintText: 'Enter the reset code',
          keyboardType: TextInputType.text,
          onChanged: widget.onResetCodeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the reset code';
            }
            if (value.length < 4) {
              return 'Reset code must be at least 4 characters';
            }
            return null;
          },
        ),
        verticalspace(18.h),
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
                isPasswordConfirmationObscureText =
                    !isPasswordConfirmationObscureText;
              });
            },
            child: Icon(
              isPasswordConfirmationObscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
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
