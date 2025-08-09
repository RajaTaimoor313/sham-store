import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/orders/logic/order_bloc.dart';
import '../features/cart/logic/cart_bloc.dart';
import '../core/di/service_locator.dart';

class PlaceOrderExample extends StatefulWidget {
  const PlaceOrderExample({Key? key}) : super(key: key);

  @override
  State<PlaceOrderExample> createState() => _PlaceOrderExampleState();
}

class _PlaceOrderExampleState extends State<PlaceOrderExample> {
  final _formKey = GlobalKey<FormState>();
  final _shippingAddressController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _notesController = TextEditingController();
  final _couponController = TextEditingController();
  
  late OrderBloc _orderBloc;
  late CartBloc _cartBloc;
  bool _isOrderPlaced = false;

  @override
  void initState() {
    super.initState();
    _orderBloc = sl<OrderBloc>();
    _cartBloc = sl<CartBloc>();
  }

  @override
  void dispose() {
    _shippingAddressController.dispose();
    _paymentMethodController.dispose();
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      final shippingAddressId = int.tryParse(_shippingAddressController.text);
      final paymentMethodId = int.tryParse(_paymentMethodController.text);
      
      if (shippingAddressId != null && paymentMethodId != null) {
        _orderBloc.add(PlaceOrder(
          shippingAddressId: shippingAddressId,
          paymentMethodId: paymentMethodId,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          coupon: _couponController.text.isNotEmpty ? _couponController.text : null,
        ));
      }
    }
  }

  void _clearCart() {
    _cartBloc.add(ClearCart());
  }

  void _resetForm() {
    setState(() {
      _isOrderPlaced = false;
    });
    _shippingAddressController.clear();
    _paymentMethodController.clear();
    _notesController.clear();
    _couponController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _orderBloc),
          BlocProvider.value(value: _cartBloc),
        ],
        child: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderPlaced) {
              setState(() {
                _isOrderPlaced = true;
              });
              // Clear cart after successful order placement
              _clearCart();
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, orderState) {
              return BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: _isOrderPlaced
                        ? _buildOrderSuccessScreen()
                        : _buildOrderForm(orderState, cartState),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Order Success!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your order has been placed successfully.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Cart has been cleared automatically.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _resetForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Place Another Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm(OrderState orderState, CartState cartState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Shipping Address ID
          TextFormField(
            controller: _shippingAddressController,
            decoration: const InputDecoration(
              labelText: 'Shipping Address ID *',
              border: OutlineInputBorder(),
              hintText: 'Enter shipping address ID (e.g., 1)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter shipping address ID';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Payment Method ID
          TextFormField(
            controller: _paymentMethodController,
            decoration: const InputDecoration(
              labelText: 'Payment Method ID *',
              border: OutlineInputBorder(),
              hintText: 'Enter payment method ID (e.g., 2)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter payment method ID';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Notes (Optional)
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Enter delivery notes (e.g., Deliver between 5-6 PM)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          
          // Coupon (Optional)
          TextFormField(
            controller: _couponController,
            decoration: const InputDecoration(
              labelText: 'Coupon Code (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Enter coupon code',
            ),
          ),
          const SizedBox(height: 24),
          
          // Place Order Button
          ElevatedButton(
            onPressed: orderState is OrderLoading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: orderState is OrderLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Placing Order...'),
                    ],
                  )
                : const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(height: 16),
          
          // Clear Cart Button
          OutlinedButton(
            onPressed: cartState is CartLoading ? null : _clearCart,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: cartState is CartLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('Clearing Cart...'),
                    ],
                  )
                : const Text(
                    'Clear Cart',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(height: 20),
          
          // API Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'API Information:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Endpoint: POST http://ecom.addisanalytics.com/api/order'),
                const Text('Headers: Accept: application/json'),
                const Text('         Content-Type: application/json'),
                const Text('         Authorization: Bearer <token>'),
                const SizedBox(height: 8),
                Text('Order State: ${orderState.runtimeType}'),
                Text('Cart State: ${cartState.runtimeType}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}