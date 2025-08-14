import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/order_model.dart';

class OrderRepository {
  final ApiService _apiService = ApiService.instance;

  // Create order from cart
  Future<ApiResponse<Order>> createOrder({
    required String shippingAddressId,
    required String paymentMethodId,
    String? notes,
    String? couponCode,
  }) async {
    try {
      final data = {
        'shipping_address_id': shippingAddressId,
        'payment_method_id': paymentMethodId,
        if (notes != null) 'notes': notes,
        if (couponCode != null) 'coupon_code': couponCode,
      };

      final response = await _apiService.post(
        ApiConstants.createOrder,
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(response.message ?? 'Order creation failed');
    } catch (e) {
      return ApiResponse.error('Order creation failed: ${e.toString()}');
    }
  }

  // Place order with specific endpoint and parameters
  Future<ApiResponse<Order>> placeOrder({
    required int shippingAddressId,
    required int paymentMethodId,
    String? notes,
    String? coupon,
  }) async {
    try {
      print(
        'Placing order with shipping_address_id: $shippingAddressId, payment_method_id: $paymentMethodId',
      );

      final data = {
        'shipping_address_id': shippingAddressId,
        'payment_method_id': paymentMethodId,
        if (notes != null) 'notes': notes,
        if (coupon != null) 'coupon': coupon,
      };

      final response = await _apiService.post(
        ApiConstants.createOrder,
        body: data,
      );

      print('Place order response: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        print('Order placed successfully: ${order.id}');
        return ApiResponse.success(order);
      }

      print('Order placement failed: ${response.error}');
      return ApiResponse.error(response.error ?? 'Order placement failed');
    } catch (e) {
      print('Order placement error: ${e.toString()}');
      return ApiResponse.error('Order placement failed: ${e.toString()}');
    }
  }

  // Get user orders with pagination
  Future<ApiResponse<PaginatedResponse<Order>>> getUserOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.get(
        ApiConstants.userOrders,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch orders');
    } catch (e) {
      return ApiResponse.error('Failed to fetch orders: ${e.toString()}');
    }
  }

  // Get my orders - user order history
  Future<ApiResponse<List<Order>>> getMyOrders() async {
    try {
      final response = await _apiService.get(ApiConstants.allOrders);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data!
            : response.data!['orders'] ?? response.data!['data'] ?? [];

        final orders = data
            .map((orderJson) => Order.fromJson(orderJson))
            .toList();

        return ApiResponse.success(orders);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch my orders');
    } catch (e) {
      return ApiResponse.error('Failed to fetch my orders: ${e.toString()}');
    }
  }

  // Get order by ID
  Future<ApiResponse<Order>> getOrderById(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.getOrder}/$orderId',
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(response.message ?? 'Order creation failed');
    } catch (e) {
      return ApiResponse.error('Failed to fetch order: ${e.toString()}');
    }
  }

  // Update order status (for sellers/admin)
  Future<ApiResponse<Order>> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      final data = {'status': status, if (notes != null) 'notes': notes};

      final response = await _apiService.put(
        '${ApiConstants.updateOrder}/$orderId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch orders');
    } catch (e) {
      return ApiResponse.error('Failed to update order: ${e.toString()}');
    }
  }

  // Cancel order
  Future<ApiResponse<Order>> cancelOrder({
    required String orderId,
    String? reason,
  }) async {
    try {
      final data = {if (reason != null) 'cancellation_reason': reason};

      final response = await _apiService.put(
        '${ApiConstants.cancelOrder}/$orderId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to update order status',
      );
    } catch (e) {
      return ApiResponse.error('Failed to cancel order: ${e.toString()}');
    }
  }

  // Track order
  Future<ApiResponse<Map<String, dynamic>>> trackOrder(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.trackOrder}/$orderId',
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(response.data!);
      }

      return ApiResponse.error(response.message ?? 'Failed to cancel order');
    } catch (e) {
      return ApiResponse.error('Failed to track order: ${e.toString()}');
    }
  }

  // Get order items
  Future<ApiResponse<List<OrderItem>>> getOrderItems(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.orderItems}/$orderId',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data!['items'] ?? response.data!;
        final orderItems = data
            .map((item) => OrderItem.fromJson(item))
            .toList();
        return ApiResponse.success(orderItems);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch order items',
      );
    } catch (e) {
      return ApiResponse.error('Failed to fetch order items: ${e.toString()}');
    }
  }

  // Search orders
  Future<ApiResponse<PaginatedResponse<Order>>> searchOrders({
    required String searchTerm,
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
        '${ApiConstants.searchOrders}/$searchTerm',
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Order search failed');
    } catch (e) {
      return ApiResponse.error('Order search failed: ${e.toString()}');
    }
  }

  // Get order statistics
  Future<ApiResponse<Map<String, dynamic>>> getOrderStatistics({
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
        ApiConstants.orderStatistics,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        return ApiResponse.success(response.data!);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch order statistics',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch order statistics: ${e.toString()}',
      );
    }
  }

  // For sellers - get seller orders
  Future<ApiResponse<PaginatedResponse<Order>>> getSellerOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.get(
        ApiConstants.sellerOrders,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch seller orders',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch seller orders: ${e.toString()}',
      );
    }
  }

  // For delivery - get available orders
  Future<ApiResponse<PaginatedResponse<Order>>> getAvailableOrders({
    int page = 1,
    int limit = 10,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (latitude != null) 'latitude': latitude.toString(),
        if (longitude != null) 'longitude': longitude.toString(),
        if (radius != null) 'radius': radius.toString(),
      };

      final response = await _apiService.get(
        ApiConstants.availableOrders,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch available orders',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch available orders: ${e.toString()}',
      );
    }
  }

  // For delivery - assign driver to order
  Future<ApiResponse<Order>> assignDriver({
    required String orderId,
    required String driverId,
  }) async {
    try {
      final data = {'driver_id': driverId};

      final response = await _apiService.put(
        '${ApiConstants.assignDriver}/$orderId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(response.message ?? 'Failed to assign driver');
    } catch (e) {
      return ApiResponse.error('Failed to assign driver: ${e.toString()}');
    }
  }

  // For delivery - get driver orders
  Future<ApiResponse<PaginatedResponse<Order>>> getDriverOrders({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
      };

      final response = await _apiService.get(
        ApiConstants.driverOrders,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to fetch driver orders',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to fetch driver orders: ${e.toString()}',
      );
    }
  }

  // Mark order as delivered
  Future<ApiResponse<Order>> markAsDelivered({
    required String orderId,
    String? deliveryNotes,
    String? deliveryPhoto,
  }) async {
    try {
      final data = {
        if (deliveryNotes != null) 'delivery_notes': deliveryNotes,
        if (deliveryPhoto != null) 'delivery_photo': deliveryPhoto,
      };

      final response = await _apiService.put(
        '${ApiConstants.markDelivered}/$orderId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(
        response.message ?? 'Failed to mark as delivered',
      );
    } catch (e) {
      return ApiResponse.error('Failed to mark as delivered: ${e.toString()}');
    }
  }

  // Get all orders with pagination (GET /api/order)
  Future<ApiResponse<PaginatedResponse<Order>>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.get(
        ApiConstants.orders,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<Order>.fromJson(
          response.data!,
          (json) => Order.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch orders');
    } catch (e) {
      return ApiResponse.error('Failed to fetch orders: ${e.toString()}');
    }
  }

  // Update order (PUT /api/order/:id)
  Future<ApiResponse<Order>> updateOrder({
    required String orderId,
    String? status,
    String? shippingAddress,
    String? billingAddress,
    String? paymentMethod,
    String? paymentStatus,
    String? notes,
    DateTime? deliveryDate,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (status != null) data['status'] = status;
      if (shippingAddress != null) data['shipping_address'] = shippingAddress;
      if (billingAddress != null) data['billing_address'] = billingAddress;
      if (paymentMethod != null) data['payment_method'] = paymentMethod;
      if (paymentStatus != null) data['payment_status'] = paymentStatus;
      if (notes != null) data['notes'] = notes;
      if (deliveryDate != null) {
        data['delivery_date'] = deliveryDate.toIso8601String();
      }

      final response = await _apiService.put(
        '${ApiConstants.updateOrder}/$orderId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final order = Order.fromJson(response.data!);
        return ApiResponse.success(order);
      }

      return ApiResponse.error(response.message ?? 'Failed to update order');
    } catch (e) {
      return ApiResponse.error('Failed to update order: ${e.toString()}');
    }
  }

  // Delete order (DELETE /api/order/:id)
  Future<ApiResponse<bool>> deleteOrder(String orderId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.deleteOrder}/$orderId',
      );

      if (response.isSuccess) {
        return ApiResponse.success(true);
      }

      return ApiResponse.error(response.message ?? 'Failed to delete order');
    } catch (e) {
      return ApiResponse.error('Failed to delete order: ${e.toString()}');
    }
  }
}
