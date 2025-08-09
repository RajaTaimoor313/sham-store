import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';

class ForgetForm extends StatefulWidget {
  final Function(String)? onEmailChanged;
  final Function(bool)? onFormValidityChanged;
  
  const ForgetForm({
    super.key,
    this.onEmailChanged,
    this.onFormValidityChanged,
  });

  @override
  State<ForgetForm> createState() => ForgetFormState();
}

class ForgetFormState extends State<ForgetForm> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initial form validity check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onFormValidityChanged?.call(false);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          verticalspace(15),
          AppTextFormField(
            controller: emailController,
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            hintText: 'Enter your email address',
            onChanged: (value) {
              widget.onEmailChanged?.call(value.trim());
              // Check form validity after email change
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final isValid = formKey.currentState?.validate() ?? false;
                widget.onFormValidityChanged?.call(isValid);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          verticalspace(16.h),
        ],
      ),
    );
  }

  // Method to get email for parent widget
  String get email {
    return emailController.text.trim();
  }
  
  // Method to validate form for parent widget
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
