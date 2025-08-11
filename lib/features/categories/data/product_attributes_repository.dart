import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';

class ProductAttributesRepository {
  final ApiService _apiService = ApiService();

  // GET /api/productattributes - Get all product attributes
  Future<PaginatedResponse<ProductAttribute>> getAllProductAttributes({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.productAttributes,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> attributesJson = response.data['data'] ?? [];
        final attributes = attributesJson.map((json) => ProductAttribute.fromJson(json)).toList();
        
        return PaginatedResponse<ProductAttribute>(
          data: attributes,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? attributes.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch product attributes');
      }
    } catch (e) {
      throw Exception('Error fetching product attributes: $e');
    }
  }

  // GET /api/productattributes/:id - Get product attribute by ID
  Future<ApiResponse<ProductAttribute>> getProductAttributeById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.productAttributes}/$id',
      );

      if (response.isSuccess && response.data != null) {
        final attribute = ProductAttribute.fromJson(response.data!);
        return ApiResponse.success(attribute);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to fetch product attribute');
      }
    } catch (e) {
      return ApiResponse.error('Error fetching product attribute: $e');
    }
  }

  // GET /api/search_productattributes/:search_term - Search product attributes
  Future<PaginatedResponse<ProductAttribute>> searchProductAttributes(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchProductAttributes}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> attributesJson = response.data['data'] ?? [];
        final attributes = attributesJson.map((json) => ProductAttribute.fromJson(json)).toList();
        
        return PaginatedResponse<ProductAttribute>(
          data: attributes,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? attributes.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to search product attributes');
      }
    } catch (e) {
      throw Exception('Error searching product attributes: $e');
    }
  }

  // POST /api/productattributes - Create product attribute
  Future<ApiResponse<ProductAttribute>> createProductAttribute(Map<String, dynamic> attributeData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.productAttributes,
        body: attributeData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final attribute = ProductAttribute.fromJson(response.data!);
        return ApiResponse.success(attribute);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to create product attribute');
      }
    } catch (e) {
      return ApiResponse.error('Error creating product attribute: $e');
    }
  }

  // PUT /api/productattributes/:id - Update product attribute
  Future<ApiResponse<ProductAttribute>> updateProductAttribute(int id, Map<String, dynamic> attributeData) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.productAttributes}/$id',
        body: attributeData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final attribute = ProductAttribute.fromJson(response.data!);
        return ApiResponse.success(attribute);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to update product attribute');
      }
    } catch (e) {
      return ApiResponse.error('Error updating product attribute: $e');
    }
  }

  // DELETE /api/productattributes/:id - Delete product attribute
  Future<ApiResponse<bool>> deleteProductAttribute(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.productAttributes}/$id',
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to delete product attribute');
      }
    } catch (e) {
      return ApiResponse.error('Error deleting product attribute: $e');
    }
  }

  // GET /api/all_productattributes - Get all product attributes (alternative endpoint)
  Future<PaginatedResponse<ProductAttribute>> fetchAllProductAttributes({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.allProductAttributes,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> attributesJson = response.data['data'] ?? [];
        final attributes = attributesJson.map((json) => ProductAttribute.fromJson(json)).toList();
        
        return PaginatedResponse<ProductAttribute>(
          data: attributes,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? attributes.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch all product attributes');
      }
    } catch (e) {
      throw Exception('Error fetching all product attributes: $e');
    }
  }
}