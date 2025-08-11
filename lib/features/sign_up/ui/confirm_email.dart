import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }


  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _verifyOtp() {
    final otpCode = _getOtpCode();
    if (otpCode.length == 6) {
      context.read<AuthBloc>().add(AuthVerifyOtpRequested(otp: otpCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendOtp() {
    if (_canResend) {
      context.read<AuthBloc>().add(AuthResendOtpRequested());
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.message.contains('Email verified')) {
              Navigator.pushReplacementNamed(context, Routes.loginscreen);
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),

                  // Title
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Confirm\n',
                            style: TextStyle(
                              color: ColorsManager.mainBlue,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Mail!',
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
                      'We\'ve sent a 6-digit OTP to your email. Please enter the code below to verify your account.',
                      style: TextStyle(
                        color: ColorsManager.mainGrey,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  verticalspace(40.h),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45.w,
                        height: 55.h,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.mainBlack,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: ColorsManager.mainGrey,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: ColorsManager.mainBlue,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            _onOtpChanged(value, index);
                          },
                          onTap: () {
                            _otpControllers[index].selection = TextSelection.fromPosition(
                              TextPosition(offset: _otpControllers[index].text.length),
                            );
                          },
                        ),
                      );
                    }),
                  ),

                  verticalspace(40.h),

                  // Verify Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  verticalspace(30.h),

                  // Timer and Resend
                  Center(
                    child: Column(
                      children: [
                        Text(
                          _canResend ? '00:00' : _formatTime(_secondsRemaining),
                          style: TextStyle(
                            color: _canResend
                                ? ColorsManager.mainGrey
                                : ColorsManager.mainBlack,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        verticalspace(12.h),
                        TextButton(
                          onPressed: _canResend ? _resendOtp : null,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: _canResend
                                  ? ColorsManager.mainBlue
                                  : ColorsManager.mainGrey,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              decoration: _canResend
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        verticalspace(30.h),
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
