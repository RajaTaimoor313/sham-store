import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

class MyChangePassword extends StatelessWidget {
  const MyChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text(
          context.tr('change_password'),
          style: TextStyle(color: ColorsManager.mainBlue),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('change_password_description'),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalspace(36.h),
                  AppTextFormField(
                     prefixIcon: Icon(Icons.lock),
                    labelText: context.tr('current_password'),
                    hintText: context.tr('enter_current_password'),
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                     prefixIcon: Icon(Icons.lock),
                    labelText: context.tr('new_password'),
                    hintText: context.tr('enter_new_password'),
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    prefixIcon: Icon(Icons.lock),
                    labelText: context.tr('confirm_password'),
                    hintText: context.tr('enter_confirm_password'),
                  ),
                  
                  verticalspace(30.h),
                  Center(
                    child: AppTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentScreen(),
                          ),
                        );
                      },
                      buttonText: context.tr('save'),
                      textStyle: TextStyle(
                        fontWeight: FontWeightHelper.medium,
                        color: ColorsManager.mainWhite,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        );
      },
    );
  }
}
