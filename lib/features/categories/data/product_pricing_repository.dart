import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';

class ProductPricingRepository {
  final ApiService _apiService = ApiService();

  // GET /api/productpricingtier - Get all product pricing tiers
  Future<PaginatedResponse<ProductPricingTier>> getAllProductPricingTiers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.productPricingTier,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> pricingTiersJson = response.data['data'] ?? [];
        final pricingTiers = pricingTiersJson.map((json) => ProductPricingTier.fromJson(json)).toList();
        
        return PaginatedResponse<ProductPricingTier>(
          data: pricingTiers,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? pricingTiers.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch product pricing tiers');
      }
    } catch (e) {
      throw Exception('Error fetching product pricing tiers: $e');
    }
  }

  // GET /api/productpricingtier/:id - Get product pricing tier by ID
  Future<ApiResponse<ProductPricingTier>> getProductPricingTierById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.productPricingTier}/$id',
      );

      if (response.isSuccess && response.data != null) {
        final pricingTier = ProductPricingTier.fromJson(response.data!);
        return ApiResponse.success(pricingTier);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to fetch product pricing tier');
      }
    } catch (e) {
      return ApiResponse.error('Error fetching product pricing tier: $e');
    }
  }

  // GET /api/search_productpricingtier/:search_term - Search product pricing tiers
  Future<PaginatedResponse<ProductPricingTier>> searchProductPricingTiers(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchProductPricingTier}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> pricingTiersJson = response.data['data'] ?? [];
        final pricingTiers = pricingTiersJson.map((json) => ProductPricingTier.fromJson(json)).toList();
        
        return PaginatedResponse<ProductPricingTier>(
          data: pricingTiers,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? pricingTiers.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to search product pricing tiers');
      }
    } catch (e) {
      throw Exception('Error searching product pricing tiers: $e');
    }
  }

  // POST /api/productpricingtier - Create product pricing tier
  Future<ApiResponse<ProductPricingTier>> createProductPricingTier(Map<String, dynamic> pricingData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.productPricingTier,
        body: pricingData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final pricingTier = ProductPricingTier.fromJson(response.data!);
        return ApiResponse.success(pricingTier);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to create product pricing tier');
      }
    } catch (e) {
      return ApiResponse.error('Error creating product pricing tier: $e');
    }
  }

  // PUT /api/productpricingtier/:id - Update product pricing tier
  Future<ApiResponse<ProductPricingTier>> updateProductPricingTier(int id, Map<String, dynamic> pricingData) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.productPricingTier}/$id',
        body: pricingData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final pricingTier = ProductPricingTier.fromJson(response.data!);
        return ApiResponse.success(pricingTier);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to update product pricing tier');
      }
    } catch (e) {
      return ApiResponse.error('Error updating product pricing tier: $e');
    }
  }

  // DELETE /api/productpricingtier/:id - Delete product pricing tier
  Future<ApiResponse<bool>> deleteProductPricingTier(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.productPricingTier}/$id',
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to delete product pricing tier');
      }
    } catch (e) {
      return ApiResponse.error('Error deleting product pricing tier: $e');
    }
  }

  // GET /api/all_productpricingtiers - Get all product pricing tiers (alternative endpoint)
  Future<PaginatedResponse<ProductPricingTier>> fetchAllProductPricingTiers({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.allProductPricingTiers,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> pricingTiersJson = response.data['data'] ?? [];
        final pricingTiers = pricingTiersJson.map((json) => ProductPricingTier.fromJson(json)).toList();
        
        return PaginatedResponse<ProductPricingTier>(
          data: pricingTiers,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? pricingTiers.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch all product pricing tiers');
      }
    } catch (e) {
      throw Exception('Error fetching all product pricing tiers: $e');
    }
  }
}