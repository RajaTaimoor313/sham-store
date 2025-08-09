class PaymentMethod {
  final int id;
  final int userId;
  final String type;
  final String name;
  final String? cardNumber;
  final String? cardHolderName;
  final String? expiryMonth;
  final String? expiryYear;
  final String? cvv;
  final String? bankName;
  final String? accountNumber;
  final String? routingNumber;
  final String? paypalEmail;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    this.cardNumber,
    this.cardHolderName,
    this.expiryMonth,
    this.expiryYear,
    this.cvv,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    this.paypalEmail,
    required this.isDefault,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      cardNumber: json['card_number'],
      cardHolderName: json['card_holder_name'],
      expiryMonth: json['expiry_month'],
      expiryYear: json['expiry_year'],
      cvv: json['cvv'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      routingNumber: json['routing_number'],
      paypalEmail: json['paypal_email'],
      isDefault: json['is_default'] ?? false,
      isActive: json['is_active'] ?? true,
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
      'type': type,
      'name': name,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cvv': cvv,
      'bank_name': bankName,
      'account_number': accountNumber,
      'routing_number': routingNumber,
      'paypal_email': paypalEmail,
      'is_default': isDefault,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  bool get isCreditCard =>
      type.toLowerCase() == 'credit_card' || type.toLowerCase() == 'debit_card';
  bool get isBankAccount => type.toLowerCase() == 'bank_account';
  bool get isPayPal => type.toLowerCase() == 'paypal';
  bool get isDigitalWallet => type.toLowerCase() == 'digital_wallet';

  String get displayName {
    switch (type.toLowerCase()) {
      case 'credit_card':
      case 'debit_card':
        return cardNumber != null
            ? '**** **** **** ${cardNumber!.substring(cardNumber!.length - 4)}'
            : name;
      case 'bank_account':
        return accountNumber != null
            ? '****${accountNumber!.substring(accountNumber!.length - 4)}'
            : name;
      case 'paypal':
        return paypalEmail ?? name;
      default:
        return name;
    }
  }

  String get typeDisplay {
    switch (type.toLowerCase()) {
      case 'credit_card':
        return 'Credit Card';
      case 'debit_card':
        return 'Debit Card';
      case 'bank_account':
        return 'Bank Account';
      case 'paypal':
        return 'PayPal';
      case 'digital_wallet':
        return 'Digital Wallet';
      default:
        return type;
    }
  }

  String? get maskedCardNumber {
    if (cardNumber == null || cardNumber!.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber!.substring(cardNumber!.length - 4)}';
  }

  String? get cardExpiry {
    if (expiryMonth == null || expiryYear == null) return null;
    return '$expiryMonth/$expiryYear';
  }

  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;
    final now = DateTime.now();
    final expiry = DateTime(
      int.parse('20$expiryYear!'),
      int.parse(expiryMonth!),
    );
    return expiry.isBefore(now);
  }
}

// Payment Transaction Model
class Payment {
  final int id;
  final int orderId;
  final int userId;
  final int? paymentMethodId;
  final String paymentMethod;
  final double amount;
  final String currency;
  final String status;
  final String? transactionId;
  final String? gatewayResponse;
  final String? failureReason;
  final DateTime? processedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.userId,
    this.paymentMethodId,
    required this.paymentMethod,
    required this.amount,
    required this.currency,
    required this.status,
    this.transactionId,
    this.gatewayResponse,
    this.failureReason,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      paymentMethodId: json['payment_method_id'],
      paymentMethod: json['payment_method'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'pending',
      transactionId: json['transaction_id'],
      gatewayResponse: json['gateway_response'],
      failureReason: json['failure_reason'],
      processedAt: json['processed_at'] != null
          ? DateTime.tryParse(json['processed_at'])
          : null,
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
      'user_id': userId,
      'payment_method_id': paymentMethodId,
      'payment_method': paymentMethod,
      'amount': amount,
      'currency': currency,
      'status': status,
      'transaction_id': transactionId,
      'gateway_response': gatewayResponse,
      'failure_reason': failureReason,
      'processed_at': processedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayAmount => '\$${amount.toStringAsFixed(2)}';

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isProcessing => status.toLowerCase() == 'processing';
  bool get isCompleted =>
      status.toLowerCase() == 'completed' || status.toLowerCase() == 'success';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isRefunded => status.toLowerCase() == 'refunded';

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'completed':
      case 'success':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }
}

// Payment Schedule Model
class PaymentSchedule {
  final int id;
  final int userId;
  final int orderId;
  final String name;
  final double amount;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final int? maxPayments;
  final int completedPayments;
  final String status;
  final DateTime? nextPaymentDate;
  final DateTime? lastPaymentDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentSchedule({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.maxPayments,
    required this.completedPayments,
    required this.status,
    this.nextPaymentDate,
    this.lastPaymentDate,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentSchedule.fromJson(Map<String, dynamic> json) {
    return PaymentSchedule(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      name: json['name'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      frequency: json['frequency'] ?? 'monthly',
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'])
          : null,
      maxPayments: json['max_payments'],
      completedPayments: json['completed_payments'] ?? 0,
      status: json['status'] ?? 'active',
      nextPaymentDate: json['next_payment_date'] != null
          ? DateTime.tryParse(json['next_payment_date'])
          : null,
      lastPaymentDate: json['last_payment_date'] != null
          ? DateTime.tryParse(json['last_payment_date'])
          : null,
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
      'order_id': orderId,
      'name': name,
      'amount': amount,
      'frequency': frequency,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'max_payments': maxPayments,
      'completed_payments': completedPayments,
      'status': status,
      'next_payment_date': nextPaymentDate?.toIso8601String(),
      'last_payment_date': lastPaymentDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters
  String get displayAmount => '\$${amount.toStringAsFixed(2)}';

  bool get isActive => status.toLowerCase() == 'active';
  bool get isPaused => status.toLowerCase() == 'paused';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  String get frequencyDisplay {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      case 'quarterly':
        return 'Quarterly';
      case 'yearly':
        return 'Yearly';
      default:
        return frequency;
    }
  }

  double get totalAmount {
    if (maxPayments != null) {
      return amount * maxPayments!;
    }
    return amount; // For indefinite schedules
  }

  double get remainingAmount {
    if (maxPayments != null) {
      return amount * (maxPayments! - completedPayments);
    }
    return amount; // For indefinite schedules
  }

  int? get remainingPayments {
    if (maxPayments != null) {
      return maxPayments! - completedPayments;
    }
    return null; // For indefinite schedules
  }
}
