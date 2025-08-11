import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        item.productImage ?? 'https://via.placeholder.com/50',
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      ),
      title: Text(item.productName),
      subtitle: Text(
        'Quantity: ${item.quantity} - Price: \$${item.unitPrice.toStringAsFixed(2)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(
                  UpdateCartItemQuantity(
                    cartItemId: item.id.toString(),
                    quantity: item.quantity - 1,
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<CartBloc>().add(
                UpdateCartItemQuantity(
                  cartItemId: item.id.toString(),
                  quantity: item.quantity + 1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
