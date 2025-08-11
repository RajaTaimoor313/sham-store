import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/cart/logic/cart_bloc.dart';
import '../features/cart/logic/cart_event.dart';
import '../features/cart/logic/cart_state.dart';
import '../core/di/service_locator.dart';

class ViewCartExample extends StatefulWidget {
  const ViewCartExample({super.key});

  @override
  State<ViewCartExample> createState() => _ViewCartExampleState();
}

class _ViewCartExampleState extends State<ViewCartExample> {
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = sl<CartBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Cart API Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider.value(
        value: _cartBloc,
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
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
                  'View Cart API Test',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'This example demonstrates the View Cart API functionality using GET /api/cart with authentication.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _cartBloc.add(GetCartItems());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Fetch Cart Items from API',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Fetching cart items...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is CartLoaded) {
                        final cart = state.cart;
                        return Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cart Summary',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Items:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${cart.items.length}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Amount:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '\$${cart.total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (cart.items.isNotEmpty) ...<Widget>[
                                  const Text(
                                    'Cart Items:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: cart.items.length,
                                      itemBuilder: (context, index) {
                                        final item = cart.items[index];
                                        return Card(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.blue[100],
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: Colors.blue[800],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              item.productName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Product ID: ${item.productId}',
                                                ),
                                                Text(
                                                  'Quantity: ${item.quantity}',
                                                ),
                                                if (item.productAttributes !=
                                                    null)
                                                  Text(
                                                    'Attributes: ${item.productAttributes}',
                                                  ),
                                              ],
                                            ),
                                            trailing: Text(
                                              '\$${item.totalPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ] else
                                  const Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Your cart is empty',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is CartError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.message}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  _cartBloc.add(GetCartItems());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return const Center(
                        child: Text(
                          'Press the button to fetch cart items',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cartBloc.close();
    super.dispose();
  }
}
