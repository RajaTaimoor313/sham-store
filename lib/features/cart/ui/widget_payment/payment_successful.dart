import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/navigate/navigate_menu.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text(
          context.tr('confirmation'),
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
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8, // لوسط الشاشة
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: ColorsManager.mainBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 50),
                    ),
                  ),
                  verticalspace(20.h),
                  Text(
                    context.tr('payment_successful'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.mainBlue,
                    ),
                  ),
                  verticalspace(10.h),
                  Text(
                    context.tr('order_placed_message'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  verticalspace(46.h),
                  AppTextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const PaymentScreen(),
                      //   ),
                      // );
                    },
                    buttonText: context.tr('continue_shopping'),
                    textStyle: TextStyle(
                      fontWeight: FontWeightHelper.medium,
                      color: ColorsManager.mainWhite,
                      fontSize: 16.sp,
                    ),
                  ),
                  verticalspace(40.h),
                  AppTextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NavigationMenu(),
                        ),
                      );
                    },
                    backgroundColor: ColorsManager.mainWhite,
                    buttonText: context.tr('back_to_home'),
                    textStyle: TextStyle(
                      fontWeight: FontWeightHelper.medium,
                      color: ColorsManager.mainBlue,
                      fontSize: 16.sp,
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
