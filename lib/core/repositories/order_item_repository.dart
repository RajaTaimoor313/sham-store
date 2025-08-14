import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/order_model.dart';

class OrderItemRepository {
  final ApiService _apiService = ApiService.instance;

  // Get all order items with pagination
  Future<ApiResponse<PaginatedResponse<OrderItem>>> getOrderItems({
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.get(
        ApiConstants.orderItems,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<OrderItem>.fromJson(
          response.data!,
          (json) => OrderItem.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch order items');
    } catch (e) {
      return ApiResponse.error('Failed to fetch order items: ${e.toString()}');
    }
  }

  // Get all order items without pagination
  Future<ApiResponse<List<OrderItem>>> getAllOrderItems() async {
    try {
      final response = await _apiService.get(ApiConstants.allOrderItems);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data!
            : response.data!['order_items'] ?? response.data!['data'] ?? [];

        final orderItems = data
            .map((orderItemJson) => OrderItem.fromJson(orderItemJson))
            .toList();

        return ApiResponse.success(orderItems);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch all order items');
    } catch (e) {
      return ApiResponse.error('Failed to fetch all order items: ${e.toString()}');
    }
  }

  // Get order item by ID
  Future<ApiResponse<OrderItem>> getOrderItemById(String orderItemId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.getOrderItem}/$orderItemId',
      );

      if (response.isSuccess && response.data != null) {
        final orderItem = OrderItem.fromJson(response.data!);
        return ApiResponse.success(orderItem);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch order item');
    } catch (e) {
      return ApiResponse.error('Failed to fetch order item: ${e.toString()}');
    }
  }

  // Create new order item
  Future<ApiResponse<OrderItem>> createOrderItem({
    required int orderId,
    required int productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    String? productImage,
  }) async {
    try {
      final data = {
        'order_id': orderId,
        'product_id': productId,
        'product_name': productName,
        'quantity': quantity,
        'unit_price': unitPrice,
        'total_price': totalPrice,
        if (productImage != null) 'product_image': productImage,
      };

      final response = await _apiService.post(
        ApiConstants.createOrderItem,
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final orderItem = OrderItem.fromJson(response.data!);
        return ApiResponse.success(orderItem);
      }

      return ApiResponse.error(response.message ?? 'Order item creation failed');
    } catch (e) {
      return ApiResponse.error('Order item creation failed: ${e.toString()}');
    }
  }

  // Update order item
  Future<ApiResponse<OrderItem>> updateOrderItem({
    required String orderItemId,
    int? orderId,
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? productImage,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (orderId != null) data['order_id'] = orderId;
      if (productId != null) data['product_id'] = productId;
      if (productName != null) data['product_name'] = productName;
      if (quantity != null) data['quantity'] = quantity;
      if (unitPrice != null) data['unit_price'] = unitPrice;
      if (totalPrice != null) data['total_price'] = totalPrice;
      if (productImage != null) data['product_image'] = productImage;

      final response = await _apiService.put(
        '${ApiConstants.updateOrderItem}/$orderItemId',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final orderItem = OrderItem.fromJson(response.data!);
        return ApiResponse.success(orderItem);
      }

      return ApiResponse.error(response.message ?? 'Failed to update order item');
    } catch (e) {
      return ApiResponse.error('Failed to update order item: ${e.toString()}');
    }
  }

  // Delete order item
  Future<ApiResponse<bool>> deleteOrderItem(String orderItemId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.deleteOrderItem}/$orderItemId',
      );

      if (response.isSuccess) {
        return ApiResponse.success(true);
      }

      return ApiResponse.error(response.message ?? 'Failed to delete order item');
    } catch (e) {
      return ApiResponse.error('Failed to delete order item: ${e.toString()}');
    }
  }

  // Search order items
  Future<ApiResponse<PaginatedResponse<OrderItem>>> searchOrderItems({
    required String searchTerm,
    int page = 1,
    int limit = 10,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.get(
        '${ApiConstants.searchOrderItems}/$searchTerm',
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final paginatedResponse = PaginatedResponse<OrderItem>.fromJson(
          response.data!,
          (json) => OrderItem.fromJson(json),
        );
        return ApiResponse.success(paginatedResponse);
      }

      return ApiResponse.error(response.message ?? 'Order item search failed');
    } catch (e) {
      return ApiResponse.error('Order item search failed: ${e.toString()}');
    }
  }

  // Get order items by order ID
  Future<ApiResponse<List<OrderItem>>> getOrderItemsByOrderId(String orderId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.orderItems}?order_id=$orderId',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data!
            : response.data!['order_items'] ?? response.data!['data'] ?? [];

        final orderItems = data
            .map((orderItemJson) => OrderItem.fromJson(orderItemJson))
            .toList();

        return ApiResponse.success(orderItems);
      }

      return ApiResponse.error(response.message ?? 'Failed to fetch order items');
    } catch (e) {
      return ApiResponse.error('Failed to fetch order items: ${e.toString()}');
    }
  }

  // Bulk create order items
  Future<ApiResponse<List<OrderItem>>> createOrderItems({
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final data = {
        'order_items': orderItems,
      };

      final response = await _apiService.post(
        '${ApiConstants.createOrderItem}/bulk',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data!
            : response.data!['order_items'] ?? response.data!['data'] ?? [];

        final createdOrderItems = data
            .map((orderItemJson) => OrderItem.fromJson(orderItemJson))
            .toList();

        return ApiResponse.success(createdOrderItems);
      }

      return ApiResponse.error(response.message ?? 'Bulk order item creation failed');
    } catch (e) {
      return ApiResponse.error('Bulk order item creation failed: ${e.toString()}');
    }
  }

  // Update order item quantity
  Future<ApiResponse<OrderItem>> updateOrderItemQuantity({
    required String orderItemId,
    required int quantity,
  }) async {
    try {
      final data = {
        'quantity': quantity,
      };

      final response = await _apiService.put(
        '${ApiConstants.updateOrderItem}/$orderItemId/quantity',
        body: data,
      );

      if (response.isSuccess && response.data != null) {
        final orderItem = OrderItem.fromJson(response.data!);
        return ApiResponse.success(orderItem);
      }

      return ApiResponse.error(response.message ?? 'Failed to update order item quantity');
    } catch (e) {
      return ApiResponse.error('Failed to update order item quantity: ${e.toString()}');
    }
  }
}