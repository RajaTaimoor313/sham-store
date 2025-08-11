import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/logic/cart_bloc.dart';
import '../features/cart/logic/cart_event.dart';
import '../features/cart/logic/cart_state.dart';

class RemoveCartItemExample extends StatefulWidget {
  const RemoveCartItemExample({super.key});

  @override
  State<RemoveCartItemExample> createState() => _RemoveCartItemExampleState();
}

class _RemoveCartItemExampleState extends State<RemoveCartItemExample> {
  late CartBloc _cartBloc;
  final TextEditingController _itemIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartBloc = getIt<CartBloc>();
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    super.dispose();
  }

  void _removeCartItem() {
    final itemIdText = _itemIdController.text.trim();
    if (itemIdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a cart item ID'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final itemId = int.tryParse(itemIdText);
    if (itemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid numeric cart item ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _cartBloc.add(RemoveCartItem(id: itemId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Cart Item API Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider.value(
        value: _cartBloc,
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              _itemIdController.clear();
            } else if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remove Cart Item API Test',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This example demonstrates the Remove Cart Item API functionality using DELETE /api/cart/remove/{id} with authentication.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                const Text(
                  'API Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• Method: DELETE'),
                const Text('• Endpoint: DELETE /api/cart/remove/{id}'),
                const Text('• Headers: Authorization: Bearer <token>'),
                const Text('• Headers: Accept: application/json'),
                const SizedBox(height: 24),
                TextField(
                  controller: _itemIdController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cart Item ID',
                    hintText: 'Enter cart item ID to remove',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is CartLoading ? null : _removeCartItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is CartLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Removing Item...'),
                                ],
                              )
                            : const Text(
                                'Remove Item from Cart',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Expected Response:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• Success: "Item removed from cart successfully."'),
                const Text('• Error: Error message from API'),
                const SizedBox(height: 16),
                const Text(
                  'Note: This will make a real API call to remove the specified cart item. Make sure you have a valid authentication token and the cart item ID exists.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}