import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/my_order/ui/order_item.dart';
import 'package:flutter_shamstore/features/my_order/ui/order_item_widget.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/orders/logic/order_bloc.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/models/order_model.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderBloc>()..add(LoadMyOrders()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.tr('orders'),
                style: TextStyle(
                  color: ColorsManager.mainBlue,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: IconButton(
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.navigationMenu),
                icon: Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              backgroundColor: ColorsManager.mainWhite,
            ),
            body: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, orderState) {
                if (orderState is OrderLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.mainBlue,
                    ),
                  );
                }

                if (orderState is OrderError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          orderState.message,
                          style: TextStyle(fontSize: 16.sp, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<OrderBloc>().add(LoadMyOrders());
                          },
                          child: Text(context.tr('retry')),
                        ),
                      ],
                    ),
                  );
                }

                if (orderState is MyOrdersLoaded) {
                  final orders = orderState.orders;

                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            context.tr('no_orders_found'),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: ListView.separated(
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderCard(order);
                      },
                    ),
                  );
                }

                return Center(
                  child: Text(
                    context.tr('no_orders_found'),
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber ?? order.id}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status ?? ''),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    order.status ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.mainBlue,
              ),
            ),
            if (order.createdAt != null) ...[
              SizedBox(height: 4.h),
              Text(
                'Date: ${_formatDate(order.createdAt!)}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
            if (order.orderDate != null) ...[
              SizedBox(height: 4.h),
              Text(
                'Order Date: ${_formatDate(order.orderDate!)}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'processing':
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
      case 'out_for_delivery':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
