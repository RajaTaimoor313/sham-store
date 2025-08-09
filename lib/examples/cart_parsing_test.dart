import 'package:flutter/material.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';

/// Test widget to verify enhanced CartItem and Cart parsing
/// This demonstrates the improved error handling and safe parsing
class CartParsingTest extends StatefulWidget {
  const CartParsingTest({super.key});

  @override
  State<CartParsingTest> createState() => _CartParsingTestState();
}

class _CartParsingTestState extends State<CartParsingTest> {
  List<String> testResults = [];

  @override
  void initState() {
    super.initState();
    runParsingTests();
  }

  void runParsingTests() {
    testResults.clear();

    // Test 1: Valid cart item data
    testValidCartItem();

    // Test 2: Cart item with missing fields
    testCartItemWithMissingFields();

    // Test 3: Cart item with invalid data types
    testCartItemWithInvalidTypes();

    // Test 4: Cart with valid items
    testValidCart();

    // Test 5: Cart with mixed valid/invalid items
    testCartWithMixedItems();

    // Test 6: Cart with empty items array
    testCartWithEmptyItems();

    setState(() {});
  }

  void addTestResult(String result) {
    testResults.add(result);
    print('🧪 Test Result: $result');
  }

  void testValidCartItem() {
    try {
      final json = {
        'id': 1,
        'cart_id': 100,
        'product_id': 50,
        'product_name': 'Test Product',
        'product_image': 'https://example.com/image.jpg',
        'unit_price': 19.99,
        'quantity': 2,
        'total_price': 39.98,
        'product_sku': 'TEST-SKU-001',
        'product_attributes': {'color': 'red', 'size': 'M'},
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final cartItem = CartItem.fromJson(json);
      addTestResult(
        '✅ Valid CartItem: ${cartItem.productName} - \$${cartItem.unitPrice}',
      );
    } catch (e) {
      addTestResult('❌ Valid CartItem failed: $e');
    }
  }

  void testCartItemWithMissingFields() {
    try {
      final json = {
        'product_id': 51,
        // Missing: id, cart_id, product_name, unit_price, quantity, etc.
      };

      final cartItem = CartItem.fromJson(json);
      addTestResult(
        '✅ Missing Fields CartItem: ${cartItem.productName} (ID: ${cartItem.productId})',
      );
    } catch (e) {
      addTestResult('❌ Missing Fields CartItem failed: $e');
    }
  }

  void testCartItemWithInvalidTypes() {
    try {
      final json = {
        'id': 'invalid_id', // String instead of int
        'cart_id': null,
        'product_id': '52', // String that can be parsed
        'product_name': 123, // Number instead of string
        'unit_price': 'not_a_number', // Invalid price
        'quantity': 'two', // Invalid quantity
        'total_price': null,
      };

      final cartItem = CartItem.fromJson(json);
      addTestResult(
        '✅ Invalid Types CartItem: ${cartItem.productName} (Price: \$${cartItem.unitPrice})',
      );
    } catch (e) {
      addTestResult('❌ Invalid Types CartItem failed: $e');
    }
  }

  void testValidCart() {
    try {
      final json = {
        'id': 1,
        'user_id': 123,
        'items': [
          {
            'id': 1,
            'cart_id': 1,
            'product_id': 50,
            'product_name': 'Product 1',
            'unit_price': 10.00,
            'quantity': 1,
            'total_price': 10.00,
          },
          {
            'id': 2,
            'cart_id': 1,
            'product_id': 51,
            'product_name': 'Product 2',
            'unit_price': 15.00,
            'quantity': 2,
            'total_price': 30.00,
          },
        ],
        'subtotal': 40.00,
        'tax': 4.00,
        'shipping': 5.00,
        'total': 49.00,
      };

      final cart = Cart.fromJson(json);
      addTestResult(
        '✅ Valid Cart: ${cart.items.length} items, Total: \$${cart.total}',
      );
    } catch (e) {
      addTestResult('❌ Valid Cart failed: $e');
    }
  }

  void testCartWithMixedItems() {
    try {
      final json = {
        'id': 2,
        'user_id': 124,
        'items': [
          {
            'id': 1,
            'cart_id': 2,
            'product_id': 60,
            'product_name': 'Valid Product',
            'unit_price': 20.00,
            'quantity': 1,
            'total_price': 20.00,
          },
          {
            // Invalid item with missing critical fields
            'product_id': 'invalid',
            'unit_price': 'not_a_number',
          },
          {
            'id': 3,
            'cart_id': 2,
            'product_id': 62,
            'product_name': 'Another Valid Product',
            'unit_price': 25.00,
            'quantity': 1,
            'total_price': 25.00,
          },
        ],
        'subtotal': 45.00,
        'tax': 4.50,
        'shipping': 5.00,
        'total': 54.50,
      };

      final cart = Cart.fromJson(json);
      addTestResult(
        '✅ Mixed Items Cart: ${cart.items.length} items parsed (should handle invalid gracefully)',
      );
    } catch (e) {
      addTestResult('❌ Mixed Items Cart failed: $e');
    }
  }

  void testCartWithEmptyItems() {
    try {
      final json = {
        'id': 3,
        'user_id': 125,
        'items': [],
        'subtotal': 0.00,
        'tax': 0.00,
        'shipping': 0.00,
        'total': 0.00,
      };

      final cart = Cart.fromJson(json);
      addTestResult(
        '✅ Empty Cart: ${cart.items.length} items, Total: \$${cart.total}',
      );
    } catch (e) {
      addTestResult('❌ Empty Cart failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Parsing Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: runParsingTests,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cart Parsing Enhancement Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Testing enhanced CartItem.fromJson() and Cart.fromJson() methods with safe parsing, error handling, and defaults.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Coverage:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('✓ Valid cart item data'),
                  Text('✓ Cart item with missing fields'),
                  Text('✓ Cart item with invalid data types'),
                  Text('✓ Cart with valid items'),
                  Text('✓ Cart with mixed valid/invalid items'),
                  Text('✓ Cart with empty items array'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Test Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: testResults.isEmpty
                    ? const Center(
                        child: Text(
                          'Running tests...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: testResults.length,
                        itemBuilder: (context, index) {
                          final result = testResults[index];
                          final isSuccess = result.startsWith('✅');
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isSuccess ? Icons.check_circle : Icons.error,
                                  color: isSuccess ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    result.substring(2), // Remove emoji
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSuccess
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 16),

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
                    'Enhanced Features:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Safe parsing with .toString() and tryParse()'),
                  Text('• Default values for missing fields'),
                  Text('• Fallback product names (Product #ID)'),
                  Text('• Comprehensive debug logging'),
                  Text('• Graceful error handling'),
                  Text('• Individual item parsing with error isolation'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
