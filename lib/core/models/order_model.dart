class Order {
  final int id;
  final int userId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String? shippingAddress;
  final String? billingAddress;
  final String? paymentMethod;
  final String? paymentStatus;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? items;
  final OrderShipping? shipping;
  final OrderPayment? payment;

  Order({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    this.shippingAddress,
    this.billingAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.orderDate,
    this.deliveryDate,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.shipping,
    this.payment,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'pending',
      shippingAddress: json['shipping_address'],
      billingAddress: json['billing_address'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      orderDate: json['order_date'] != null
          ? DateTime.tryParse(json['order_date'])
          : null,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.tryParse(json['delivery_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : null,
      shipping: json['shipping'] != null
          ? OrderShipping.fromJson(json['shipping'])
          : null,
      payment: json['payment'] != null
          ? OrderPayment.fromJson(json['payment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'billing_address': billingAddress,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'order_date': orderDate?.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayTotal => '\$${totalAmount.toStringAsFixed(2)}';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isShipped => status.toLowerCase() == 'shipped';
  bool get isDelivered => status.toLowerCase() == 'delivered';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

// Order Item Model
class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? productImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.productImage,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      productImage: json['product_image'],
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
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product_image': productImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get displayUnitPrice => '\$${unitPrice.toStringAsFixed(2)}';
  String get displayTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';
}

// Order Shipping Model
class OrderShipping {
  final int id;
  final int orderId;
  final String method;
  final double cost;
  final String? trackingNumber;
  final String? carrier;
  final DateTime? estimatedDelivery;
  final DateTime? actualDelivery;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderShipping({
    required this.id,
    required this.orderId,
    required this.method,
    required this.cost,
    this.trackingNumber,
    this.carrier,
    this.estimatedDelivery,
    this.actualDelivery,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderShipping.fromJson(Map<String, dynamic> json) {
    return OrderShipping(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      method: json['method'] ?? '',
      cost: double.tryParse(json['cost']?.toString() ?? '0') ?? 0.0,
      trackingNumber: json['tracking_number'],
      carrier: json['carrier'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.tryParse(json['estimated_delivery'])
          : null,
      actualDelivery: json['actual_delivery'] != null
          ? DateTime.tryParse(json['actual_delivery'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  String get displayCost => '\$${cost.toStringAsFixed(2)}';
}

// Order Payment Model
class OrderPayment {
  final int id;
  final int orderId;
  final int paymentMethodId;
  final double totalPaid;
  final String status;
  final String? refundStatus;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderPayment({
    required this.id,
    required this.orderId,
    required this.paymentMethodId,
    required this.totalPaid,
    required this.status,
    this.refundStatus,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      paymentMethodId: json['payment_method_id'] ?? 0,
      totalPaid: double.tryParse(json['total_paid']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'pending',
      refundStatus: json['refund_status'],
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  String get displayTotalPaid => '\$${totalPaid.toStringAsFixed(2)}';
  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';
}
