import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment.dart';

class DeliveryAddress extends StatelessWidget {
  const DeliveryAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text(
          'Delivery Address',
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
                    'Add or select your delivery address to receive your order on time.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalspace(36.h),
                  AppTextFormField(
                    labelText: 'State',
                    hintText: 'Enter Your State',
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    labelText: 'City',
                    hintText: 'Enter Your City',
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    labelText: 'Town',
                    hintText: 'Enter Your Town',
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    labelText: 'Street No',
                    hintText: 'Enter Your Street No',
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
                      buttonText: 'Save Address',
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
  }
}
