import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';
import 'package:flutter_shamstore/features/cart/ui/widget_payment/delivery_address.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        // Use the shared CartBloc instance and trigger LoadCart
        WidgetsBinding.instance.addPostFrameCallback((_) {
          BlocProvider.of<CartBloc>(context).add(LoadCart());
        });

        return Scaffold(
          appBar: AppBar(
            title: Text(
              context.tr('cart'),
              style: TextStyle(color: ColorsManager.mainBlue),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // منطق "Add More"
                },
                child: Text(
                  context.tr('add_more'),
                  style: TextStyle(
                    color: ColorsManager.mainOrange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CartError) {
                  return Center(child: Text(state.message));
                }

                if (state is CartLoaded && state.cart.items.isEmpty) {
                  return Center(child: Text(context.tr('cart_empty')));
                }

                return _CartItemList(
                  items: state is CartLoaded ? state.cart.items : [],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _CartItemList extends StatefulWidget {
  final List<CartItem> items;
  const _CartItemList({required this.items});

  @override
  State<_CartItemList> createState() => _CartItemListState();
}

class _CartItemListState extends State<_CartItemList> {
  double _calculateTotal() {
    double total = 0;
    for (int i = 0; i < widget.items.length; i++) {
      final price = widget.items[i].unitPrice;
      final qty = widget.items[i].quantity;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Center(
        child: Text(
          context.tr('cart_empty'),
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10.w),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];

              return Dismissible(
                key: Key(item.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  alignment: Alignment.centerRight,
                  color: Colors.redAccent,
                  child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
                ),
                onDismissed: (direction) {
                  final removedItem = item;

                  // Call the API to remove the item from cart
                  context.read<CartBloc>().add(RemoveCartItem(id: removedItem.id));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${removedItem.productName} ${context.tr('removed_from_cart')}',
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: _buildCartItem(item, index),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('total'),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculateTotal().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsManager.mainOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: AppTextButton(
            buttonText: context.tr('payment'),
            backgroundColor: ColorsManager.mainBlue,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeliveryAddress()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: SizedBox(
              width: 100.w,
              height: 100.w,
              child: Image.network(
                item.productImage ?? 'https://example.com/default-image.png',
                fit: BoxFit.cover,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.mainBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorsManager.mainGrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item.quantity} ${context.tr('pieces')}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorsManager.mainGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.unitPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorsManager.mainOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (item.quantity > 1) {
                        context.read<CartBloc>().add(
                          UpdateCartItemQuantity(
                            cartItemId: item.id.toString(),
                            quantity: item.quantity - 1,
                          ),
                        );
                      }
                    },
                    child: Icon(Icons.remove_circle_outline, size: 18.sp),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${item.quantity}',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(width: 4.w),
                  InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(
                        UpdateCartItemQuantity(
                          cartItemId: item.id.toString(),
                          quantity: item.quantity + 1,
                        ),
                      );
                    },
                    child: Icon(Icons.add_circle_outline, size: 18.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
