import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/head_text.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

class MyPaymentMethod extends StatelessWidget {
  const MyPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text(context.tr('payment_method'), style: TextStyle(color: ColorsManager.mainBlue)),
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
                    context.tr('card_details_description'),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),                 
                  verticalspace(26.h),
                  AppTextFormField(
                    labelText: context.tr('card_holder_name'),
                    hintText: context.tr('enter_card_holder_name'),
                  ),
                  verticalspace(15.h),
                  AppTextFormField(
                    labelText: context.tr('account_number'),
                    hintText: context.tr('enter_account_number'),
                  ),
                  verticalspace(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          labelText: context.tr('cvv'),
                          hintText: context.tr('enter_cvv'),
                        ),
                      ),
                      horizontalspace(15.w),
                      Expanded(
                        child: AppTextFormField(
                          labelText: context.tr('expiry'),
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
                        context.tr('use_card_future'),
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
                  HeadText(title: context.tr('payment_summary'),showActionButton: false,),
                 
                  verticalspace(36.h),

                  Center(
                    child: AppTextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const PaymentSuccessful(),
                        //   ),
                        // );
                      },
                      buttonText: context.tr('save'),
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
      },
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
