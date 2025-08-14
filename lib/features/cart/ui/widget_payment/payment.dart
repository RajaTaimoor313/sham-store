import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/helpers/head_text.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/payment_successful.dart';
import 'package:flutter_shamstore/features/orders/logic/order_bloc.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCashOnDelivery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainWhite,
        title: Text(
          context.tr('payment'),
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
                    context.tr('card_details_description'),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalspace(20.h),

                  // Cash on Delivery Option
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isCashOnDelivery,
                          onChanged: (value) {
                            setState(() {
                              isCashOnDelivery = value ?? false;
                            });
                          },
                          activeColor: ColorsManager.mainBlue,
                        ),
                        horizontalspace(8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('cash_on_delivery'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                context.tr('pay_on_delivery'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isCashOnDelivery) ...[
                    verticalspace(20.h),
                    Text(
                      context.tr('payment_method'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],

                  if (!isCashOnDelivery) ...[
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
                  ],
                  verticalspace(26.h),
                  HeadText(
                    title: context.tr('payment_summary'),
                    showActionButton: false,
                  ),
                  verticalspace(26.h),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('sub_total'),
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
                            context.tr('delivery_charges'),
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
                            context.tr('discount'),
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
                            context.tr('grand_total'),
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

                  BlocProvider(
                    create: (context) => sl<OrderBloc>(),
                    child: BlocConsumer<OrderBloc, OrderState>(
                      listener: (context, state) {
                        if (state is OrderPlaced) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentSuccessful(),
                            ),
                          );
                        } else if (state is OrderError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Center(
                          child: AppTextButton(
                            onPressed: state is OrderLoading
                                ? null
                                : () {
                                    // Place order using the API
                                    context.read<OrderBloc>().add(
                                      PlaceOrder(
                                        shippingAddressId:
                                            1, // Default address ID
                                        paymentMethodId: isCashOnDelivery
                                            ? 2
                                            : 1, // 2 for COD, 1 for card
                                        notes: isCashOnDelivery
                                            ? 'Cash on Delivery'
                                            : null,
                                      ),
                                    );
                                  },
                            buttonText: state is OrderLoading
                                ? context.tr('processing')
                                : context.tr('checkout'),
                            textStyle: TextStyle(
                              fontWeight: FontWeightHelper.medium,
                              color: ColorsManager.mainWhite,
                              fontSize: 20.sp,
                            ),
                          ),
                        );
                      },
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
