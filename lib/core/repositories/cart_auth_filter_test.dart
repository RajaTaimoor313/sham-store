import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_model.dart';

class CartAuthFilterTest extends StatefulWidget {
  const CartAuthFilterTest({super.key});

  @override
  State<CartAuthFilterTest> createState() => _CartAuthFilterTestState();
}

class _CartAuthFilterTestState extends State<CartAuthFilterTest> {
  final AuthRepository _authRepository = AuthRepository();
  User? currentUser;
  String testResults = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await _authRepository.getStoredUser();
      setState(() {
        currentUser = user;
        testResults = user != null
            ? 'Current user loaded: ${user.name} (ID: ${user.id})'
            : 'No current user found';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        testResults = 'Error loading current user: $e';
        isLoading = false;
      });
    }
  }

  void _testCartFiltering() {
    setState(() {
      testResults += '\n\nTesting cart filtering with AuthRepository...';
    });

    // Trigger cart load to test filtering
    context.read<CartBloc>().add(LoadCart());
  }

  void _refreshUserData() async {
    setState(() {
      testResults += '\n\nRefreshing user data from API...';
      isLoading = true;
    });

    try {
      final response = await _authRepository.getCurrentUser();
      if (response.isSuccess && response.data != null) {
        setState(() {
          currentUser = response.data;
          testResults +=
              '\nUser data refreshed: ${response.data!.name} (ID: ${response.data!.id})';
          isLoading = false;
        });
      } else {
        setState(() {
          testResults += '\nFailed to refresh user data: ${response.message}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        testResults += '\nError refreshing user data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Auth Filter Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                    const Text(
                      'Current User Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (currentUser != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${currentUser!.name}'),
                          Text('Email: ${currentUser!.email}'),
                          Text('ID: ${currentUser!.id}'),
                          Text('Phone: ${currentUser!.phone ?? 'N/A'}'),
                        ],
                      )
                    else
                      const Text(
                        'No user logged in',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _loadCurrentUser,
                          child: const Text('Reload User'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _refreshUserData,
                          child: const Text('Refresh from API'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _testCartFiltering,
                          child: const Text('Test Cart Filter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          testResults.isEmpty
                              ? 'No test results yet'
                              : testResults,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
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
                      const Text(
                        'Cart State',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                  Text('Cart ID: ${state.cart.id}'),
                                  Text('User ID: ${state.cart.userId}'),
                                  Text(
                                    'Items Count: ${state.cart.items.length}',
                                  ),
                                  Text(
                                    'Total: \$${state.cart.total.toStringAsFixed(2)}',
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Cart Items:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.cart.items.length,
                                      itemBuilder: (context, index) {
                                        final item = state.cart.items[index];
                                        return ListTile(
                                          title: Text(item.productName),
                                          subtitle: Text(
                                            'Qty: ${item.quantity}',
                                          ),
                                          trailing: Text(
                                            '\$${item.totalPrice.toStringAsFixed(2)}',
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
                                      size: 48,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Cart Error: ${state.message}',
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
