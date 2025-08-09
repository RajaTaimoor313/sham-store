import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/my_order/ui/order_item.dart';
import 'package:flutter_shamstore/features/my_order/ui/widgets/out_for_delivery.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, required this.order});
  final OrderItem order;

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return ColorsManager.mainOrange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // الانتقال إلى صفحة OutForDelivery فقط عند In Progress
        if (order.status == 'In Progress') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OutForDelivery(),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: ColorsManager.mainWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 88.w, maxHeight: 88.w),
                child: Image.network(
                  order.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 40.sp),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // تفاصيل المنتج
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.mainBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${order.pieces} pieces',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsManager.mainGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ColorsManager.mainBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // حالة الطلب
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                order.status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: getStatusColor(order.status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
