import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiService _apiService = ApiService();

  // Get payment methods with pagination
  Future<ApiResponse<PaginatedResponse<PaymentMethod>>> getPaymentMethods({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('🔍 [PaymentRepository] Getting payment methods - Page: $page, Limit: $limit');
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get(
        ApiConstants.paymentMethods,
        queryParams: queryParams,
      );

      print('📡 [PaymentRepository] API Response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<PaymentMethod>.fromJson(
          response.data!,
          (json) => PaymentMethod.fromJson(json),
        );
        print('✅ [PaymentRepository] Successfully parsed ${paginatedResponse.data.length} payment methods');
        return ApiResponse.success(paginatedResponse);
      }

      print('❌ [PaymentRepository] Failed to get payment methods: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to fetch payment methods',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in getPaymentMethods: $e');
      return ApiResponse.error(
        'Failed to fetch payment methods: ${e.toString()}',
      );
    }
  }

  // Get all payment methods
  Future<ApiResponse<List<PaymentMethod>>> getAllPaymentMethods() async {
    try {
      final response = await _apiService.get(ApiConstants.allPaymentMethods);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data =
            response.data!['payment_methods'] ?? response.data!;
        final paymentMethods = data
            .map((item) => PaymentMethod.fromJson(item))
            .toList();
        return ApiResponse.success(paymentMethods);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch all payment methods',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch all payment methods: ${e.toString()}',
      );
    }
  }

  // Get payment method by ID
  Future<ApiResponse<PaymentMethod>> getPaymentMethodById(String id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.getPaymentMethod}/$id',
      );

      if (response.isSuccess && response.data != null) {
        final paymentMethod = PaymentMethod.fromJson(response.data!);
        return ApiResponse.success(paymentMethod);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch payment method',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch payment method: ${e.toString()}',
      );
    }
  }

  // Search payment methods
  Future<ApiResponse<List<PaymentMethod>>> searchPaymentMethods(
    String searchTerm, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('🔍 [PaymentRepository] Searching payment methods - Term: "$searchTerm", Page: $page');
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      print('📤 [PaymentRepository] Search payment methods query params: $queryParams');
      final response = await _apiService.get(
        '${ApiConstants.searchPaymentMethods}/$searchTerm',
        queryParams: queryParams,
      );

      print('📡 [PaymentRepository] Search payment methods response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data!['payment_methods'] ?? response.data!;
        final paymentMethods = data.map((item) => PaymentMethod.fromJson(item)).toList();
        print('✅ [PaymentRepository] Found ${paymentMethods.length} payment methods matching "$searchTerm"');
        return ApiResponse.success(paymentMethods);
      }

      print('❌ [PaymentRepository] Failed to search payment methods: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to search payment methods',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in searchPaymentMethods: $e');
      return ApiResponse.error(
        'Failed to search payment methods: ${e.toString()}',
      );
    }
  }

  // Create payment method
  Future<ApiResponse<PaymentMethod>> createPaymentMethod({
    required String type,
    required String name,
    String? cardNumber,
    String? cardHolderName,
    String? expiryMonth,
    String? expiryYear,
    String? cvv,
    String? bankName,
    String? accountNumber,
    String? routingNumber,
    String? paypalEmail,
    bool isDefault = false,
  }) async {
    try {
      print('🔍 [PaymentRepository] Creating payment method - Type: $type, Name: $name, Default: $isDefault');
      final data = {
        'type': type,
        'name': name,
        if (cardNumber != null) 'card_number': cardNumber,
        if (cardHolderName != null) 'card_holder_name': cardHolderName,
        if (expiryMonth != null) 'expiry_month': expiryMonth,
        if (expiryYear != null) 'expiry_year': expiryYear,
        if (cvv != null) 'cvv': cvv,
        if (bankName != null) 'bank_name': bankName,
        if (accountNumber != null) 'account_number': accountNumber,
        if (routingNumber != null) 'routing_number': routingNumber,
        if (paypalEmail != null) 'paypal_email': paypalEmail,
        'is_default': isDefault,
      };

      print('📤 [PaymentRepository] Sending payment method data: $data');
      final response = await _apiService.post(
        ApiConstants.createPaymentMethod,
        body: data,
      );

      print('📡 [PaymentRepository] Create payment method response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final paymentMethod = PaymentMethod.fromJson(response.data!);
        print('✅ [PaymentRepository] Successfully created payment method with ID: ${paymentMethod.id}');
        return ApiResponse.success(paymentMethod);
      }

      print('❌ [PaymentRepository] Failed to create payment method: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to create payment method',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in createPaymentMethod: $e');
      return ApiResponse.error(
        'Failed to create payment method: ${e.toString()}',
      );
    }
  }

  // Add payment method (legacy method for backward compatibility)
  Future<ApiResponse<PaymentMethod>> addPaymentMethod({
    required String type,
    required String provider,
    required Map<String, dynamic> details,
    bool isDefault = false,
  }) async {
    try {
      final data = {
        'type': type,
        'provider': provider,
        'details': details,
        'is_default': isDefault,
      };

      final response = await _apiService.post(
        ApiConstants.addPaymentMethod,
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final paymentMethod = PaymentMethod.fromJson(response.data!);
        return ApiResponse.success(paymentMethod);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to add payment method',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to add payment method: ${e.toString()}',
      );
    }
  }

  // Update payment method
  Future<ApiResponse<PaymentMethod>> updatePaymentMethod({
    required String paymentMethodId,
    Map<String, dynamic>? details,
    bool? isDefault,
  }) async {
    try {
      print('🔄 [PaymentRepository] Updating payment method - ID: $paymentMethodId');
      final data = <String, dynamic>{};
      if (details != null) data['details'] = details;
      if (isDefault != null) data['is_default'] = isDefault;

      print('📤 [PaymentRepository] Update data: $data');
      final response = await _apiService.put(
        '${ApiConstants.updatePaymentMethod}/$paymentMethodId',
        body: data,
      );

      print('📡 [PaymentRepository] Update payment method response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final paymentMethod = PaymentMethod.fromJson(response.data!);
        print('✅ [PaymentRepository] Successfully updated payment method: $paymentMethodId');
        return ApiResponse.success(paymentMethod);
      }

      print('❌ [PaymentRepository] Failed to update payment method: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to update payment method',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in updatePaymentMethod: $e');
      return ApiResponse.error(
        'Failed to update payment method: ${e.toString()}',
      );
    }
  }

  // Delete payment method
  Future<ApiResponse<void>> deletePaymentMethod(String paymentMethodId) async {
    try {
      print('🗑️ [PaymentRepository] Deleting payment method - ID: $paymentMethodId');
      
      final response = await _apiService.delete(
        '${ApiConstants.deletePaymentMethod}/$paymentMethodId',
      );

      print('📡 [PaymentRepository] Delete payment method response - Success: ${response.isSuccess}, Message: ${response.message}');

      if (response.isSuccess) {
        print('✅ [PaymentRepository] Successfully deleted payment method: $paymentMethodId');
        return ApiResponse.success(null);
      }

      print('❌ [PaymentRepository] Failed to delete payment method: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to delete payment method',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in deletePaymentMethod: $e');
      return ApiResponse.error(
        'Failed to delete payment method: ${e.toString()}',
      );
    }
  }

  // Set default payment method
  Future<ApiResponse<void>> setDefaultPaymentMethod(
    String paymentMethodId,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.setDefaultPaymentMethod}/$paymentMethodId',
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to set default payment method',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to set default payment method: ${e.toString()}',
      );
    }
  }

  // Process payment
  Future<ApiResponse<Payment>> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    String? currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final data = {
        'order_id': orderId,
        'payment_method_id': paymentMethodId,
        'amount': amount,
        'currency': currency ?? 'USD',
        if (metadata != null) 'metadata': metadata,
      };

      final response = await _apiService.post(
        ApiConstants.processPayment,
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final payment = Payment.fromJson(response.data!);
        return ApiResponse.success(payment);
      }

      return ApiResponse.error(response.message ?? 'Payment processing failed');
    } catch (e) {
      return ApiResponse.error('Payment processing failed: ${e.toString()}');
    }
  }

  // Get payments with pagination
  Future<ApiResponse<PaginatedResponse<Payment>>> getPayments({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('🔍 [PaymentRepository] Getting payments - Page: $page, Limit: $limit, Status: $status');
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      print('📤 [PaymentRepository] Query params: $queryParams');
      final response = await _apiService.get(
        ApiConstants.payments,
        queryParams: queryParams,
      );

      print('📡 [PaymentRepository] Get payments response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Payment>.fromJson(
          response.data!,
          (json) => Payment.fromJson(json),
        );
        print('✅ [PaymentRepository] Successfully retrieved ${paginatedResponse.data.length} payments (Page ${paginatedResponse.currentPage}/${paginatedResponse.lastPage})');
        return ApiResponse.success(paginatedResponse);
      }

      print('❌ [PaymentRepository] Failed to get payments: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to fetch payments',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in getPayments: $e');
      return ApiResponse.error(
        'Failed to fetch payments: ${e.toString()}',
      );
    }
  }

  // Get all payments
  Future<ApiResponse<List<Payment>>> getAllPayments() async {
    try {
      final response = await _apiService.get(ApiConstants.allPayments);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data!['payments'] ?? response.data!;
        final payments = data.map((item) => Payment.fromJson(item)).toList();
        return ApiResponse.success(payments);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch all payments',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch all payments: ${e.toString()}',
      );
    }
  }

  // Get payment by ID
  Future<ApiResponse<Payment>> getPaymentById(String paymentId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.getPayment}/$paymentId',
      );

      if (response.isSuccess && response.data != null) {
        final payment = Payment.fromJson(response.data!);
        return ApiResponse.success(payment);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch payment');
    } catch (e) {
      return ApiResponse.error('Failed to fetch payment: ${e.toString()}');
    }
  }

  // Create payment
  Future<ApiResponse<Payment>> createPayment({
    required int orderId,
    required int userId,
    int? paymentMethodId,
    required String paymentMethod,
    required double amount,
    String currency = 'USD',
    String status = 'pending',
    String? transactionId,
    String? gatewayResponse,
    String? failureReason,
  }) async {
    try {
      print('🔍 [PaymentRepository] Creating payment - Order: $orderId, User: $userId, Amount: $amount $currency');
      final data = {
        'order_id': orderId,
        'user_id': userId,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
        'payment_method': paymentMethod,
        'amount': amount,
        'currency': currency,
        'status': status,
        if (transactionId != null) 'transaction_id': transactionId,
        if (gatewayResponse != null) 'gateway_response': gatewayResponse,
        if (failureReason != null) 'failure_reason': failureReason,
      };

      print('📤 [PaymentRepository] Sending payment data: $data');
      final response = await _apiService.post(
        ApiConstants.createPayment,
        body: data,
      );

      print('📡 [PaymentRepository] Create payment response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final payment = Payment.fromJson(response.data!);
        print('✅ [PaymentRepository] Successfully created payment with ID: ${payment.id}');
        return ApiResponse.success(payment);
      }

      print('❌ [PaymentRepository] Failed to create payment: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to create payment',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in createPayment: $e');
      return ApiResponse.error(
        'Failed to create payment: ${e.toString()}',
      );
    }
  }

  // Update payment
  Future<ApiResponse<Payment>> updatePayment({
    required String paymentId,
    String? status,
    String? transactionId,
    String? gatewayResponse,
    String? failureReason,
    DateTime? processedAt,
  }) async {
    try {
      print('🔄 [PaymentRepository] Updating payment - ID: $paymentId');
      final data = <String, dynamic>{};
      if (status != null) data['status'] = status;
      if (transactionId != null) data['transaction_id'] = transactionId;
      if (gatewayResponse != null) data['gateway_response'] = gatewayResponse;
      if (failureReason != null) data['failure_reason'] = failureReason;
      if (processedAt != null) data['processed_at'] = processedAt.toIso8601String();

      print('📤 [PaymentRepository] Update data: $data');
      final response = await _apiService.put(
        '${ApiConstants.updatePayment}/$paymentId',
        body: data,
      );

      print('📡 [PaymentRepository] Update payment response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final payment = Payment.fromJson(response.data!);
        print('✅ [PaymentRepository] Successfully updated payment: $paymentId');
        return ApiResponse.success(payment);
      }

      print('❌ [PaymentRepository] Failed to update payment: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to update payment',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in updatePayment: $e');
      return ApiResponse.error(
        'Failed to update payment: ${e.toString()}',
      );
    }
  }

  // Delete payment
  Future<ApiResponse<void>> deletePayment(String paymentId) async {
    try {
      print('🗑️ [PaymentRepository] Deleting payment - ID: $paymentId');
      
      final response = await _apiService.delete(
        '${ApiConstants.deletePayment}/$paymentId',
      );

      print('📡 [PaymentRepository] Delete payment response - Success: ${response.isSuccess}, Message: ${response.message}');

      if (response.isSuccess) {
        print('✅ [PaymentRepository] Successfully deleted payment: $paymentId');
        return ApiResponse.success(null);
      }

      print('❌ [PaymentRepository] Failed to delete payment: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to delete payment',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in deletePayment: $e');
      return ApiResponse.error(
        'Failed to delete payment: ${e.toString()}',
      );
    }
  }

  // Search payments
  Future<ApiResponse<List<Payment>>> searchPayments(
    String searchTerm, {
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('🔍 [PaymentRepository] Searching payments - Term: "$searchTerm", Page: $page, Status: $status');
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      print('📤 [PaymentRepository] Search query params: $queryParams');
      final response = await _apiService.get(
        '${ApiConstants.searchPayments}/$searchTerm',
        queryParams: queryParams,
      );

      print('📡 [PaymentRepository] Search payments response - Success: ${response.isSuccess}, Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data!['payments'] ?? response.data!;
        final payments = data.map((item) => Payment.fromJson(item)).toList();
        print('✅ [PaymentRepository] Found ${payments.length} payments matching "$searchTerm"');
        return ApiResponse.success(payments);
      }

      print('❌ [PaymentRepository] Failed to search payments: ${response.message}');
      return ApiResponse.error(
        response.message ?? 'Failed to search payments',
      );
    } catch (e) {
      print('💥 [PaymentRepository] Exception in searchPayments: $e');
      return ApiResponse.error(
        'Failed to search payments: ${e.toString()}',
      );
    }
  }

  // Get user payments with pagination
  Future<ApiResponse<PaginatedResponse<Payment>>> getUserPayments({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      };

      final response = await _apiService.get(
        ApiConstants.userPayments,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Payment>.fromJson(
          response.data!,
          (json) => Payment.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Refund failed');
    } catch (e) {
      return ApiResponse.error('Failed to fetch payments: ${e.toString()}');
    }
  }

  // Refund payment
  Future<ApiResponse<Payment>> refundPayment({
    required String paymentId,
    required double amount,
    String? reason,
  }) async {
    try {
      final data = {'amount': amount, if (reason != null) 'reason': reason};

      final response = await _apiService.post(
        '${ApiConstants.refundPayment}/$paymentId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final payment = Payment.fromJson(response.data!);
        return ApiResponse.success(payment);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch payment statistics',
      );
    } catch (e) {
      return ApiResponse.error('Refund failed: ${e.toString()}');
    }
  }

  // Get payment schedules
  Future<ApiResponse<List<PaymentSchedule>>> getPaymentSchedules() async {
    try {
      final response = await _apiService.get(ApiConstants.paymentSchedules);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data =
            response.data!['schedules'] ?? response.data!;
        final schedules = data
            .map((item) => PaymentSchedule.fromJson(item))
            .toList();
        return ApiResponse.success(schedules);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to create payment schedule',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch payment schedules: ${e.toString()}',
      );
    }
  }

  // Create payment schedule
  Future<ApiResponse<PaymentSchedule>> createPaymentSchedule({
    required String paymentMethodId,
    required double amount,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
  }) async {
    try {
      final data = {
        'payment_method_id': paymentMethodId,
        'amount': amount,
        'frequency': frequency,
        'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (description != null) 'description': description,
      };

      final response = await _apiService.post(
        ApiConstants.createPaymentSchedule,
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final schedule = PaymentSchedule.fromJson(response.data!);
        return ApiResponse.success(schedule);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to update payment schedule',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to create payment schedule: ${e.toString()}',
      );
    }
  }

  // Update payment schedule
  Future<ApiResponse<PaymentSchedule>> updatePaymentSchedule({
    required String scheduleId,
    double? amount,
    String? frequency,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (amount != null) data['amount'] = amount;
      if (frequency != null) data['frequency'] = frequency;
      if (startDate != null) data['start_date'] = startDate.toIso8601String();
      if (endDate != null) data['end_date'] = endDate.toIso8601String();
      if (description != null) data['description'] = description;
      if (isActive != null) data['is_active'] = isActive;

      final response = await _apiService.put(
        '${ApiConstants.updatePaymentSchedule}/$scheduleId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final schedule = PaymentSchedule.fromJson(response.data!);
        return ApiResponse.success(schedule);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to delete payment schedule',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to update payment schedule: ${e.toString()}',
      );
    }
  }

  // Delete payment schedule
  Future<ApiResponse<void>> deletePaymentSchedule(String scheduleId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.deletePaymentSchedule}/$scheduleId',
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(
        response.message ?? 'Payment method validation failed',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to delete payment schedule: ${e.toString()}',
      );
    }
  }

  // Validate payment method (for testing purposes)
  Future<ApiResponse<bool>> validatePaymentMethod({
    required String type,
    required Map<String, dynamic> details,
  }) async {
    try {
      final data = {'type': type, 'details': details};

      final response = await _apiService.post(
        ApiConstants.validatePaymentMethod,
        body: data,
      );

      if (response.isSuccess) {
        final isValid = response.data?['is_valid'] ?? false;
        return ApiResponse.success(isValid);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch payment statistics',
      );
    } catch (e) {
      return ApiResponse.error(
        'Payment method validation failed: ${e.toString()}',
      );
    }
  }

  // Get payment statistics
  Future<ApiResponse<Map<String, dynamic>>> getPaymentStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _apiService.get(
        ApiConstants.paymentStatistics,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(response.data!);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch payment statistics',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch payment statistics: ${e.toString()}',
      );
    }
  }
}
