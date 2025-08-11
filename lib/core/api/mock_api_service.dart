import 'dart:async';
import 'dart:math';
import 'api_response.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/payment_model.dart';
import '../models/product_model.dart';

/// Mock API Service for testing without backend access
class MockApiService {
  static const bool _enableMockMode = true; // Toggle this for testing
  static const int _mockDelay = 1000; // Simulate network delay
  static const double _errorRate = 0.1; // 10% chance of random errors

  final Random _random = Random();

  /// Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: _mockDelay));
  }

  /// Simulate random network errors
  bool _shouldSimulateError() {
    return _random.nextDouble() < _errorRate;
  }

  /// Mock Authentication
  Future<ApiResponse<User>> mockLogin(String email, String password) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Network error: Connection timeout');
    }

    if (email == 'test@example.com' && password == 'password123') {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: email,
        phone: '+1234567890',
        avatar: 'https://via.placeholder.com/150',
        address: '123 Main St, City, Country',
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        updatedAt: DateTime.now(),
      );
      return ApiResponse.success(user, 'Login successful');
    }

    return ApiResponse.error('Invalid email or password');
  }

  /// Mock Product Data
  Future<ApiResponse<List<Product>>> mockGetProducts() async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Failed to load products');
    }

    final products = [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone with advanced features',
        price: 999.99,
        discountPrice: 899.99,
        images: ['https://via.placeholder.com/300x300'],
        category: 'Electronics',
        brand: 'Apple',
        stock: 50,
        rating: 4.8,
        reviewCount: 1250,
        isActive: true,
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        description: 'Premium Android smartphone',
        price: 849.99,
        images: ['https://via.placeholder.com/300x300'],
        category: 'Electronics',
        brand: 'Samsung',
        stock: 30,
        rating: 4.6,
        reviewCount: 890,
        isActive: true,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Product(
        id: '3',
        name: 'MacBook Air M3',
        description: 'Lightweight laptop with M3 chip',
        price: 1299.99,
        discountPrice: 1199.99,
        images: ['https://via.placeholder.com/300x300'],
        category: 'Computers',
        brand: 'Apple',
        stock: 20,
        rating: 4.9,
        reviewCount: 567,
        isActive: true,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
    ];

    return ApiResponse.success(products);
  }

  /// Mock Order Data
  Future<ApiResponse<List<Order>>> mockGetOrders() async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Failed to load orders');
    }

    final orders = [
      Order(
        id: '1',
        userId: '1',
        orderNumber: 'ORD-2024-001',
        totalAmount: 999.99,
        status: 'delivered',
        shippingAddress: '123 Main St, City, Country',
        billingAddress: '123 Main St, City, Country',
        paymentMethod: 'Credit Card',
        paymentStatus: 'paid',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 2)),
        deliveredAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Order(
        id: '2',
        userId: '1',
        orderNumber: 'ORD-2024-002',
        totalAmount: 1299.99,
        status: 'processing',
        shippingAddress: '123 Main St, City, Country',
        billingAddress: '123 Main St, City, Country',
        paymentMethod: 'PayPal',
        paymentStatus: 'paid',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(hours: 6)),
      ),
    ];

    return ApiResponse.success(orders);
  }

  /// Mock Payment Methods
  Future<ApiResponse<List<PaymentMethod>>> mockGetPaymentMethods() async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Failed to load payment methods');
    }

    final paymentMethods = [
      PaymentMethod(
        id: '1',
        userId: '1',
        type: 'card',
        name: 'Visa ending in 1234',
        isDefault: true,
        cardNumber: '**** **** **** 1234',
        cardHolderName: 'John Doe',
        expiryDate: '12/26',
        isActive: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      PaymentMethod(
        id: '2',
        userId: '1',
        type: 'paypal',
        name: 'PayPal Account',
        isDefault: false,
        paypalEmail: 'john.doe@example.com',
        isActive: true,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
    ];

    return ApiResponse.success(paymentMethods);
  }

  /// Mock Create Order
  Future<ApiResponse<Order>> mockCreateOrder(
    Map<String, dynamic> orderData,
  ) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Order creation failed');
    }

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '1',
      orderNumber:
          'ORD-2024-${_random.nextInt(9999).toString().padLeft(3, '0')}',
      totalAmount: orderData['total_amount'] ?? 0.0,
      status: 'pending',
      shippingAddress: orderData['shipping_address'] ?? '',
      billingAddress: orderData['billing_address'] ?? '',
      paymentMethod: orderData['payment_method'] ?? '',
      paymentStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return ApiResponse.success(order, 'Order created successfully');
  }

  /// Mock Process Payment
  Future<ApiResponse<Payment>> mockProcessPayment(
    Map<String, dynamic> paymentData,
  ) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      return ApiResponse.error('Payment processing failed');
    }

    final payment = Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderId: paymentData['order_id'] ?? '',
      paymentMethodId: paymentData['payment_method_id'] ?? '',
      amount: paymentData['amount'] ?? 0.0,
      currency: paymentData['currency'] ?? 'USD',
      status: 'completed',
      transactionId: 'TXN-${_random.nextInt(999999)}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return ApiResponse.success(payment, 'Payment processed successfully');
  }

  /// Check if mock mode is enabled
  static bool get isMockMode => _enableMockMode;
}

/// Extension to add mock capabilities to existing repositories
extension MockApiExtension on dynamic {
  /// Helper to determine if we should use mock data
  bool get shouldUseMockData => MockApiService.isMockMode;
}
