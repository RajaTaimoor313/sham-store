import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/head_text.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment_successful.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text('Payment', style: TextStyle(color: ColorsManager.mainBlue)),
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
                    'Enter your preferred card details to complete your order securely.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalspace(15.h),
                  Text(
                    'Card Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  verticalspace(26.h),
                  AppTextFormField(
                    labelText: 'Card Holder Name',
                    hintText: 'Enter Card Holder Name',
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    labelText: 'Acoount Number',
                    hintText: 'Enter Acoount Number',
                  ),
                  verticalspace(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          labelText: 'Cvv',
                          hintText: 'Enter Cvv',
                        ),
                      ),
                      horizontalspace(15.w),
                      Expanded(
                        child: AppTextFormField(
                          labelText: 'Expiry',
                          hintText: 'MM/YY',
                        ),
                      ),
                    ],
                  ),
                  verticalspace(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Use this card in future', // يمكنك تغيير النص حسب الحاجة
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          bool isSwitched = false;
                          return Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeColor: ColorsManager.mainBlue,
                          );
                        },
                      ),
                    ],
                  ),
                  verticalspace(26.h),
                  HeadText(title: 'Payment Summary',showActionButton: false,),
                  verticalspace(26.h),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub Total',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '\$3400',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      verticalspace(16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Charges',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '\$50',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      verticalspace(16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '\$20',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      verticalspace(26.h),
                      DashedDivider(),
                      verticalspace(26.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            '\$3430',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  verticalspace(36.h),

                  Center(
                    child: AppTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentSuccessful(),
                          ),
                        );
                      },
                      buttonText: 'Checkout',
                      textStyle: TextStyle(
                        fontWeight: FontWeightHelper.medium,
                        color: ColorsManager.mainWhite,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  verticalspace(50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashSpace = 5.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }
}
