import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiService _apiService = ApiService();

  // Get user payment methods
  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final response = await _apiService.get(ApiConstants.paymentMethods);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data =
            response.data!['payment_methods'] ?? response.data!;
        final paymentMethods = data
            .map((item) => PaymentMethod.fromJson(item))
            .toList();
        return ApiResponse.success(paymentMethods);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to add payment method',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch payment methods: ${e.toString()}',
      );
    }
  }

  // Add payment method
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

      return ApiResponse.error(response.message ?? 'Failed to fetch payments');
    } catch (e) {
      return ApiResponse.error('Failed to add payment method: ${e.toString()}');
    }
  }

  // Update payment method
  Future<ApiResponse<PaymentMethod>> updatePaymentMethod({
    required String paymentMethodId,
    Map<String, dynamic>? details,
    bool? isDefault,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (details != null) data['details'] = details;
      if (isDefault != null) data['is_default'] = isDefault;

      final response = await _apiService.put(
        '${ApiConstants.updatePaymentMethod}/$paymentMethodId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final paymentMethod = PaymentMethod.fromJson(response.data!);
        return ApiResponse.success(paymentMethod);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to update payment method',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to update payment method: ${e.toString()}',
      );
    }
  }

  // Delete payment method
  Future<ApiResponse<void>> deletePaymentMethod(String paymentMethodId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.deletePaymentMethod}/$paymentMethodId',
      );

      if (response.isSuccess) {
        return ApiResponse.success(null);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to delete payment method',
      );
    } catch (e) {
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
