import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';

class ShowProduct extends StatelessWidget {
  final List<ProductItem> products;

  const ShowProduct({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return GestureDetector(
            onTap: product.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: ColorsManager.lightBlue,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.mainGrey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 190.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: ColorsManager.mainGrey.withOpacity(0.3),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40.sp,
                                    color: ColorsManager.mainGrey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                product.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18.sp,
                                color: product.isFavorite
                                    ? Colors.red
                                    : ColorsManager.mainGrey,
                              ),
                              onPressed: product.onFavoritePressed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorsManager.mainBlack,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          verticalspace(4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.price,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorsManager.mainGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 34.w,
                                height: 34.w,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    product.cartIcon,
                                    size: 18.sp,
                                    color: ColorsManager.mainBlue,
                                  ),
                                  onPressed: product.onCartPressed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// كلاس المنتج
class ProductItem {
  final VoidCallback? onTap;
  final String imageUrl;
  final String title;
  final String price;
  final IconData cartIcon;
  final bool isFavorite;
  final VoidCallback onCartPressed;
  final VoidCallback onFavoritePressed;

  ProductItem({
    this.onTap,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.cartIcon,
    required this.onCartPressed,
    required this.onFavoritePressed,
    this.isFavorite = false,
  });
}
