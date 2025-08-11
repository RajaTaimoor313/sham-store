import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';

class EnterResetCodeButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isFormValid;
  final String email;
  final String resetCode;
  final String password;
  final String passwordConfirmation;

  const EnterResetCodeButton({
    super.key,
    required this.formKey,
    required this.isFormValid,
    required this.email,
    required this.resetCode,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
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
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            AppTextButton(
              onPressed: state is AuthLoading
                  ? null
                  : () {
                      if (isFormValid &&
                          email.isNotEmpty &&
                          resetCode.isNotEmpty &&
                          password.isNotEmpty &&
                          passwordConfirmation.isNotEmpty) {
                        // Trigger reset password event with pin
                        context.read<AuthBloc>().add(
                          AuthResetPasswordRequested(
                            email: email,
                            pin: resetCode,
                            password: password,
                            passwordConfirmation: passwordConfirmation,
                          ),
                        );
                      } else {
                        // Trigger form validation to show error messages
                        formKey.currentState?.validate();
                      }
                    },
              buttonText: state is AuthLoading
                  ? 'Resetting...'
                  : 'Reset Password',
              textStyle: TextStyle(
                fontWeight: FontWeightHelper.medium,
                color: ColorsManager.mainWhite,
                fontSize: 20.sp,
              ),
            ),
            verticalspace(38.h),
          ],
        );
      },
    );
  }
}
