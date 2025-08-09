import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Email format validation using RegExp
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    // Use AuthBloc for login
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: email, password: password),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is AuthLoading;
        });

        if (state is AuthAuthenticated) {
          // Login successful, navigate to home
          Navigator.pushReplacementNamed(context, Routes.navigationMenu);
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            verticalspace(15),
            AppTextFormField(
              labelText: 'Email',
              controller: emailController,
              prefixIcon: const Icon(Icons.email),
              hintText: 'Enter Email',
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            verticalspace(15),
            AppTextFormField(
              labelText: 'Password',
              controller: passwordController,
              prefixIcon: const Icon(Icons.lock),
              isObscureText: true,
              hintText: 'Enter Password',
              validator: _validatePassword,
            ),
            verticalspace(16.h),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.forgetpassword);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.mainBlue,
                      fontWeight: FontWeightHelper.medium,
                    ),
                  ),
                ],
              ),
            ),
            verticalspace(30),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.mainBlue.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppTextButton(
                onPressed: _isLoading ? null : _handleLogin,
                buttonText: _isLoading ? '' : 'Login',
                backgroundColor: ColorsManager.mainBlue,
                textStyle: TextStyle(
                  fontWeight: FontWeightHelper.medium,
                  color: ColorsManager.mainWhite,
                  fontSize: 20.sp,
                  letterSpacing: 0.5,
                ),
                buttonHeight: 56.h,
                child: _isLoading
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
            ),
          ],
        ),
      ),
    );
  }
}
