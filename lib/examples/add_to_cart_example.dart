import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';

class AddToCartExample extends StatefulWidget {
  const AddToCartExample({super.key});

  @override
  State<AddToCartExample> createState() => _AddToCartExampleState();
}

class _AddToCartExampleState extends State<AddToCartExample> {
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values for testing
    _productIdController.text = '49';
    _quantityController.text = '2';
    _priceController.text = '99.99';
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final productIdText = _productIdController.text.trim();
    final quantityText = _quantityController.text.trim();
    final priceText = _priceController.text.trim();

    if (productIdText.isEmpty || quantityText.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter product ID, quantity, and price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final productId = int.tryParse(productIdText);
    final quantity = int.tryParse(quantityText);
    final price = double.tryParse(priceText);

    if (productId == null ||
        quantity == null ||
        quantity <= 0 ||
        price == null ||
        price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print(
      '🛒 Adding to cart: Product ID: $productId, Quantity: $quantity, Price: $price',
    );
    BlocProvider.of<CartBloc>(context).add(
      AddToCart(productId: productId, quantity: quantity, unitPrice: price),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Cart API Example'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemAdded) {
            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CartError) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add to Cart API Test',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Test the POST /api/cart/add endpoint with authentication',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _productIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Product ID',
                  hintText: 'e.g., 49',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 2',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is CartAddingItem ? null : _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: state is CartAddingItem
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Adding to Cart...'),
                            ],
                          )
                        : const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'API Details:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• Endpoint: POST /api/cart/add'),
                      Text('• Base URL: http://ecom.addisanalytics.com'),
                      Text('• Headers: Accept, Content-Type, Authorization'),
                      Text('• Authentication: Bearer token required'),
                      Text('• Body: {"product_id": int, "quantity": int}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    return Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cart Status:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Items in cart: ${state.cart.items.length}'),
                            Text(
                              'Total: \$${state.cart.total.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
