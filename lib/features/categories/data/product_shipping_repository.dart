import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';

class ProductShippingRepository {
  final ApiService _apiService = ApiService();

  // GET /api/productshipping - Get all product shipping
  Future<PaginatedResponse<ProductShipping>> getAllProductShipping({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.productShipping,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> shippingJson = response.data['data'] ?? [];
        final shipping = shippingJson.map((json) => ProductShipping.fromJson(json)).toList();
        
        return PaginatedResponse<ProductShipping>(
          data: shipping,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? shipping.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch product shipping');
      }
    } catch (e) {
      throw Exception('Error fetching product shipping: $e');
    }
  }

  // GET /api/productshipping/:id - Get product shipping by ID
  Future<ApiResponse<ProductShipping>> getProductShippingById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.productShipping}/$id',
      );

      if (response.isSuccess && response.data != null) {
        final shipping = ProductShipping.fromJson(response.data!);
        return ApiResponse.success(shipping);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to fetch product shipping');
      }
    } catch (e) {
      return ApiResponse.error('Error fetching product shipping: $e');
    }
  }

  // GET /api/search_productshipping/:search_term - Search product shipping
  Future<PaginatedResponse<ProductShipping>> searchProductShipping(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchProductShipping}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> shippingJson = response.data['data'] ?? [];
        final shipping = shippingJson.map((json) => ProductShipping.fromJson(json)).toList();
        
        return PaginatedResponse<ProductShipping>(
          data: shipping,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? shipping.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to search product shipping');
      }
    } catch (e) {
      throw Exception('Error searching product shipping: $e');
    }
  }

  // POST /api/productshipping - Create product shipping
  Future<ApiResponse<ProductShipping>> createProductShipping(Map<String, dynamic> shippingData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.productShipping,
        body: shippingData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final shipping = ProductShipping.fromJson(response.data!);
        return ApiResponse.success(shipping);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to create product shipping');
      }
    } catch (e) {
      return ApiResponse.error('Error creating product shipping: $e');
    }
  }

  // PUT /api/productshipping/:id - Update product shipping
  Future<ApiResponse<ProductShipping>> updateProductShipping(int id, Map<String, dynamic> shippingData) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.productShipping}/$id',
        body: shippingData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final shipping = ProductShipping.fromJson(response.data!);
        return ApiResponse.success(shipping);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to update product shipping');
      }
    } catch (e) {
      return ApiResponse.error('Error updating product shipping: $e');
    }
  }

  // DELETE /api/productshipping/:id - Delete product shipping
  Future<ApiResponse<bool>> deleteProductShipping(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.productShipping}/$id',
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to delete product shipping');
      }
    } catch (e) {
      return ApiResponse.error('Error deleting product shipping: $e');
    }
  }

  // GET /api/all_productshippings - Get all product shipping (alternative endpoint)
  Future<PaginatedResponse<ProductShipping>> fetchAllProductShipping({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.allProductShippings,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> shippingJson = response.data['data'] ?? [];
        final shipping = shippingJson.map((json) => ProductShipping.fromJson(json)).toList();
        
        return PaginatedResponse<ProductShipping>(
          data: shipping,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? shipping.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch all product shipping');
      }
    } catch (e) {
      throw Exception('Error fetching all product shipping: $e');
    }
  }
}