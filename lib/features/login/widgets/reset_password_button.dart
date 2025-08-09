import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';

class ResetPasswordButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isFormValid;
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordButton({
    super.key,
    required this.formKey,
    required this.isFormValid,
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to login screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginscreen,
            (route) => false,
          );
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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return AppTextButton(
            buttonText: state is AuthLoading ? 'Resetting...' : 'Reset Password',
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            onPressed: (state is AuthLoading || !isFormValid)
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            AuthResetPasswordRequested(
                              email: email,
                              token: token,
                              password: password,
                              passwordConfirmation: passwordConfirmation,
                            ),
                          );
                    }
                  },
          );
        },
      ),
    );
  }
}