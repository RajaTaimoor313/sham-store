import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';

/// Test widget to verify that CartBloc is shared across the app
/// This widget demonstrates that the same CartBloc instance is used
/// throughout the application when accessed via BlocProvider.of CartBloc(context)
class CartSharedInstanceTest extends StatelessWidget {
  const CartSharedInstanceTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Shared Instance Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cart Shared Instance Verification',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This test verifies that CartBloc is shared across the app.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // Test button to load cart
            ElevatedButton(
              onPressed: () {
                print('🧪 Test: Loading cart using shared CartBloc instance');
                BlocProvider.of<CartBloc>(context).add(LoadCart());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Load Cart (Shared Instance)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test button to add item to cart
            ElevatedButton(
              onPressed: () {
                print('🧪 Test: Adding item using shared CartBloc instance');
                BlocProvider.of<CartBloc>(context).add(AddToCart(
                  productId: 999,
                  quantity: 1,
                  unitPrice: 19.99,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Add Test Item (Shared Instance)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Cart state display
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return Card(
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Cart State:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'State Type: ${state.runtimeType}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          if (state is CartLoading)
                            const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Text('Loading cart...'),
                              ],
                            )
                          else if (state is CartLoaded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('✅ Cart loaded successfully'),
                                Text('Items count: ${state.cart.items.length}'),
                                if (state.cart.items.isNotEmpty)
                                  ...state.cart.items.map((item) => 
                                    Text('- ${item.productName} (qty: ${item.quantity})')
                                  )
                                else
                                  const Text('Cart is empty'),
                              ],
                            )
                          else if (state is CartError)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('❌ Cart error:'),
                                Text(state.message),
                              ],
                            )
                          else if (state is CartItemAdded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('✅ Item added to cart:'),
                                Text(state.message),
                              ],
                            )
                          else
                            Text('State: ${state.toString()}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Instructions:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('1. Click "Load Cart" to test cart loading'),
                  Text('2. Click "Add Test Item" to test adding items'),
                  Text('3. Check console logs for debug information'),
                  Text('4. Verify state changes are reflected in real-time'),
                  Text('5. Navigate to other screens and verify shared state'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}