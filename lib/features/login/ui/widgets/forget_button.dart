import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/features/login/ui/widgets/forget_form.dart';

class ForgetButton extends StatelessWidget {
  final GlobalKey<ForgetFormState> formKey;
  final String email;
  final bool isFormValid;
  
  const ForgetButton({
    super.key, 
    required this.formKey,
    required this.email,
    required this.isFormValid,
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
           Navigator.pushReplacementNamed(context, Routes.loginscreen);
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
      builder: (context, state) {
        return Column(
          children: [
            AppTextButton(
              onPressed: state is AuthLoading ? null : () {
                if (isFormValid && email.isNotEmpty) {
                  // Trigger forgot password event
                  context.read<AuthBloc>().add(
                    AuthForgotPasswordRequested(email: email),
                  );
                } else {
                  // Trigger form validation to show error messages
                  formKey.currentState?.validateForm();
                }
              },
              buttonText: state is AuthLoading ? 'Sending...' : 'Send Reset Link',
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
