import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../helpers/storage_helper.dart';

class CartUserFilterTest extends StatefulWidget {
  const CartUserFilterTest({Key? key}) : super(key: key);

  @override
  State<CartUserFilterTest> createState() => _CartUserFilterTestState();
}

class _CartUserFilterTestState extends State<CartUserFilterTest> {
  final StorageHelper _storageHelper = StorageHelper.instance;
  String? currentUserId;
  String testResults = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final userId = await _storageHelper.getString('user_id');
    setState(() {
      currentUserId = userId;
    });
  }

  void _testCartFiltering() {
    setState(() {
      testResults = 'Testing cart filtering by user ID...';
    });

    // Trigger cart load to test filtering
    context.read<CartBloc>().add(LoadCart());
  }

  void _simulateUserChange(String newUserId) async {
    await _storageHelper.saveString('user_id', newUserId);
    setState(() {
      currentUserId = newUserId;
      testResults = 'User ID changed to: $newUserId\nTesting cart filtering...';
    });

    // Reload cart with new user ID
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart User Filter Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current User Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: ${currentUserId ?? "Not set"}'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _testCartFiltering,
                          child: const Text('Test Cart Filtering'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _simulateUserChange('1'),
                          child: const Text('Set User ID: 1'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _simulateUserChange('2'),
                          child: const Text('Set User ID: 2'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (testResults.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Results',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(testResults),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cart State (Filtered by User)',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is CartLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cart ID: ${state.cart.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Cart User ID: ${state.cart.userId}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Items Count: ${state.cart.items.length}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Total: \$${state.cart.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (state.cart.items.isEmpty)
                                    const Text(
                                      'No items in cart (filtered by user ID)',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.cart.items.length,
                                        itemBuilder: (context, index) {
                                          final item = state.cart.items[index];
                                          return ListTile(
                                            leading:
                                                item.productImage.isNotEmpty
                                                ? Image.network(
                                                    item.productImage,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                          );
                                                        },
                                                  )
                                                : const Icon(
                                                    Icons.shopping_cart,
                                                  ),
                                            title: Text(item.productName),
                                            subtitle: Text(
                                              'Qty: ${item.quantity} | Price: \$${item.unitPrice.toStringAsFixed(2)}',
                                            ),
                                            trailing: Text(
                                              '\$${item.totalPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              );
                            } else if (state is CartError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error: ${state.message}',
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('Cart not loaded'),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
