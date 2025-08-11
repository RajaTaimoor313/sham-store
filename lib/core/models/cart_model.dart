class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    print('🛒 Cart.fromJson: Starting cart parsing');
    print('🛒 Cart.fromJson: Raw JSON data: $json');

    List<CartItem> parsedItems = [];

    try {
      // Parse from json['data'] instead of json['items'] to match API response structure
      if (json['data'] != null) {
        print(
          '🛒 Cart.fromJson: Data field exists, type: ${json['data'].runtimeType}',
        );

        if (json['data'] is List) {
          final itemsList = json['data'] as List;
          print('🛒 Cart.fromJson: Raw items count: ${itemsList.length}');

          for (int i = 0; i < itemsList.length; i++) {
            try {
              print(
                '🛒 Cart.fromJson: Parsing item ${i + 1}/${itemsList.length}: ${itemsList[i]}',
              );
              final cartItem = CartItem.fromJson(itemsList[i]);
              parsedItems.add(cartItem);
              print(
                '🛒 Cart.fromJson: ✅ Successfully parsed item ${i + 1}: ${cartItem.productName} (ID: ${cartItem.productId}, Qty: ${cartItem.quantity})',
              );
            } catch (e, stackTrace) {
              print('❌ Cart.fromJson: Failed to parse item ${i + 1}: $e');
              print('❌ Cart.fromJson: Item data: ${itemsList[i]}');
              print('❌ Cart.fromJson: Stack trace: $stackTrace');
              // Continue parsing other items instead of failing completely
            }
          }
        } else {
          print(
            '❌ Cart.fromJson: Data field is not a List, type: ${json['data'].runtimeType}',
          );
        }
      } else {
        print('🛒 Cart.fromJson: Data field is null or missing');
        // Fallback: try parsing from 'items' field for backward compatibility
        if (json['items'] != null) {
          print('🛒 Cart.fromJson: Fallback - trying items field');
          if (json['items'] is List) {
            final itemsList = json['items'] as List;
            print(
              '🛒 Cart.fromJson: Raw items count (fallback): ${itemsList.length}',
            );

            for (int i = 0; i < itemsList.length; i++) {
              try {
                print(
                  '🛒 Cart.fromJson: Parsing fallback item ${i + 1}/${itemsList.length}: ${itemsList[i]}',
                );
                final cartItem = CartItem.fromJson(itemsList[i]);
                parsedItems.add(cartItem);
                print(
                  '🛒 Cart.fromJson: ✅ Successfully parsed fallback item ${i + 1}: ${cartItem.productName} (ID: ${cartItem.productId}, Qty: ${cartItem.quantity})',
                );
              } catch (e, stackTrace) {
                print(
                  '❌ Cart.fromJson: Failed to parse fallback item ${i + 1}: $e',
                );
                print('❌ Cart.fromJson: Item data: ${itemsList[i]}');
                print('❌ Cart.fromJson: Stack trace: $stackTrace');
              }
            }
          }
        }
      }
    } catch (e, stackTrace) {
      print('❌ Cart.fromJson: Error parsing cart data: $e');
      print('❌ Cart.fromJson: Stack trace: $stackTrace');
    }

    print('🛒 Cart.fromJson: Final parsed items count: ${parsedItems.length}');

    // Extract user ID from cart items if not present at cart level
    int extractedUserId = int.tryParse(json['user_id']?.toString() ?? '0') ?? 0;
    
    // Since the API returns all cart items from all users, we need to handle this differently
    // The cart parsing should not filter by user - that should be done in the repository
    // For now, set userId to 0 to indicate this is a mixed cart that needs filtering
    if (extractedUserId == 0) {
      print('🛒 Cart.fromJson: No user_id at cart level, setting to 0 for repository filtering');
    }
    
    print('🛒 Cart.fromJson: Final user ID: $extractedUserId');

    return Cart(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: extractedUserId,
      items: parsedItems,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      shipping: double.tryParse(json['shipping']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  String get displaySubtotal => '\$${subtotal.toStringAsFixed(2)}';
  String get displayTax => '\$${tax.toStringAsFixed(2)}';
  String get displayShipping => '\$${shipping.toStringAsFixed(2)}';
  String get displayTotal => '\$${total.toStringAsFixed(2)}';

  // Helper methods
  CartItem? findItemByProductId(int productId) {
    try {
      return items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasProduct(int productId) {
    return items.any((item) => item.productId == productId);
  }

  double calculateSubtotal() {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Create empty cart
  factory Cart.empty(int userId) {
    return Cart(
      id: 0,
      userId: userId,
      items: [],
      subtotal: 0.0,
      tax: 0.0,
      shipping: 0.0,
      total: 0.0,
    );
  }
}

// Cart Item Model
class CartItem {
  final int id;
  final int cartId;
  final int customerId;
  final int productId;
  final String productName;
  final String? productImage;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? productSku;
  final Map<String, dynamic>? productAttributes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem({
    required this.id,
    required this.cartId,
    required this.customerId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.productSku,
    this.productAttributes,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    print('🛍️ CartItem.fromJson: Starting item parsing');
    print('🛍️ CartItem.fromJson: Raw item data: $json');

    try {
      // Safe parsing with comprehensive error handling and defaults
      final id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      final cartId = int.tryParse(json['cart_id']?.toString() ?? '0') ?? 0;
      final customerId = int.tryParse(json['customer_id']?.toString() ?? '0') ?? 0;
      final productId =
          int.tryParse(json['product_id']?.toString() ?? '0') ?? 0;

      // Ensure product name is never empty - use fallback if missing
      String productName = json['product_name']?.toString() ?? '';
      if (productName.isEmpty) {
        productName = 'Product #$productId';
        print(
          '🛍️ CartItem.fromJson: Using fallback product name: $productName',
        );
      }

      // Ensure product image has a default if missing
      String? productImage = json['product_image']?.toString();
      if (productImage != null && productImage.isEmpty) {
        productImage = null; // Convert empty string to null
      }

      final unitPrice =
          double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0;
      final quantity = int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;
      final totalPrice =
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0;

      // Calculate total price if not provided or invalid
      final calculatedTotalPrice = totalPrice > 0
          ? totalPrice
          : (unitPrice * quantity);

      final productSku = json['product_sku']?.toString();

      // Safe parsing of product attributes
      Map<String, dynamic>? productAttributes;
      try {
        if (json['product_attributes'] != null) {
          if (json['product_attributes'] is Map<String, dynamic>) {
            productAttributes =
                json['product_attributes'] as Map<String, dynamic>;
          } else if (json['product_attributes'] is String) {
            // Try to parse JSON string
            productAttributes = {}; // Fallback to empty map if parsing fails
          }
        }
      } catch (e) {
        print('🛍️ CartItem.fromJson: Error parsing product_attributes: $e');
        productAttributes = null;
      }

      final createdAt = json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null;
      final updatedAt = json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null;

      final cartItem = CartItem(
        id: id,
        cartId: cartId,
        customerId: customerId,
        productId: productId,
        productName: productName,
        productImage: productImage,
        unitPrice: unitPrice,
        quantity: quantity,
        totalPrice: calculatedTotalPrice,
        productSku: productSku,
        productAttributes: productAttributes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      print('🛍️ CartItem.fromJson: Successfully parsed item:');
      print('🛍️ CartItem.fromJson: - ID: $id');
      print('🛍️ CartItem.fromJson: - Customer ID: $customerId');
      print('🛍️ CartItem.fromJson: - Product ID: $productId');
      print('🛍️ CartItem.fromJson: - Product Name: $productName');
      print('🛍️ CartItem.fromJson: - Unit Price: $unitPrice');
      print('🛍️ CartItem.fromJson: - Quantity: $quantity');
      print('🛍️ CartItem.fromJson: - Total Price: $calculatedTotalPrice');

      return cartItem;
    } catch (e, stackTrace) {
      print('❌ CartItem.fromJson: Critical error parsing cart item: $e');
      print('❌ CartItem.fromJson: Raw data: $json');
      print('❌ CartItem.fromJson: Stack trace: $stackTrace');

      // Return a minimal valid CartItem to prevent complete failure
      return CartItem(
        id: 0,
        cartId: 0,
        productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
        productName: json['product_name']?.toString() ?? 'Unknown Product',
        productImage: null,
        unitPrice: 0.0,
        quantity: 1,
        totalPrice: 0.0,
        productSku: null,
        productAttributes: null,
        createdAt: null,
        updatedAt: null,
        customerId: int.tryParse(json['customer_id']?.toString() ?? '0') ?? 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'customer_id': customerId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'unit_price': unitPrice,
      'quantity': quantity,
      'total_price': totalPrice,
      'product_sku': productSku,
      'product_attributes': productAttributes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayUnitPrice => '\$${unitPrice.toStringAsFixed(2)}';
  String get displayTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  // Helper methods
  CartItem copyWith({
    int? id,
    int? cartId,
    int? customerId,
    int? productId,
    String? productName,
    String? productImage,
    double? unitPrice,
    int? quantity,
    double? totalPrice,
    String? productSku,
    Map<String, dynamic>? productAttributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      customerId: customerId ?? this.customerId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      totalPrice:
          totalPrice ??
          (quantity ?? this.quantity) * (unitPrice ?? this.unitPrice),
      productSku: productSku ?? this.productSku,
      productAttributes: productAttributes ?? this.productAttributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Create cart item from product
  factory CartItem.fromProduct({
    required int productId,
    required String productName,
    String? productImage,
    required double unitPrice,
    int quantity = 1,
    int customerId = 0,
    String? productSku,
    Map<String, dynamic>? productAttributes,
  }) {
    return CartItem(
      id: 0, // Will be set by backend
      cartId: 0, // Will be set by backend
      customerId: customerId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      unitPrice: unitPrice,
      quantity: quantity,
      totalPrice: unitPrice * quantity,
      productSku: productSku,
      productAttributes: productAttributes,
    );
  }
}

// Wishlist Model
class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final String productName;
  final String? productImage;
  final double productPrice;
  final String? productSku;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.productPrice,
    this.productSku,
    this.createdAt,
    this.updatedAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      productPrice:
          double.tryParse(json['product_price']?.toString() ?? '0') ?? 0.0,
      productSku: json['product_sku'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'product_price': productPrice,
      'product_sku': productSku,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get displayPrice => '\$${productPrice.toStringAsFixed(2)}';
}
