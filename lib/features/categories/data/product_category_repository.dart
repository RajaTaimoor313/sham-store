import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/category_model.dart';

class ProductCategoryRepository {
  final ApiService _apiService = ApiService();

  // GET /api/productcategor - Get all product categories
  Future<PaginatedResponse<Category>> getAllProductCategories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.productCategory,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson = response.data['data'] ?? [];
        final categories = categoriesJson.map((json) => Category.fromJson(json)).toList();
        
        return PaginatedResponse<Category>(
          data: categories,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? categories.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch product categories');
      }
    } catch (e) {
      throw Exception('Error fetching product categories: $e');
    }
  }

  // GET /api/productcategor/:id - Get product category by ID
  Future<ApiResponse<Category>> getProductCategoryById(int id) async {
    try {
      final response = await _apiService.get('${ApiConstants.productCategory}/$id');
      
      if (response.isSuccess && response.data != null) {
        final category = Category.fromJson(response.data);
        return ApiResponse.success(category);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to fetch product category');
      }
    } catch (e) {
      return ApiResponse.error('Error fetching product category: $e');
    }
  }

  // GET /api/search_productcategor/:search_term - Search product categories
  Future<PaginatedResponse<Category>> searchProductCategories(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchProductCategory}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson = response.data['data'] ?? [];
        final categories = categoriesJson.map((json) => Category.fromJson(json)).toList();
        
        return PaginatedResponse<Category>(
          data: categories,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? categories.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to search product categories');
      }
    } catch (e) {
      throw Exception('Error searching product categories: $e');
    }
  }

  // POST /api/productcategor - Create new product category
  Future<ApiResponse<Category>> createProductCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.productCategory,
        body: categoryData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final category = Category.fromJson(response.data);
        return ApiResponse.success(category);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to create product category');
      }
    } catch (e) {
      return ApiResponse.error('Error creating product category: $e');
    }
  }

  // PUT /api/productcategor/:id - Update product category
  Future<ApiResponse<Category>> updateProductCategory(int id, Map<String, dynamic> categoryData) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.productCategory}/$id',
        body: categoryData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final category = Category.fromJson(response.data);
        return ApiResponse.success(category);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to update product category');
      }
    } catch (e) {
      return ApiResponse.error('Error updating product category: $e');
    }
  }

  // DELETE /api/productcategor/:id - Delete product category
  Future<ApiResponse<bool>> deleteProductCategory(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.productCategory}/$id',
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to delete product category');
      }
    } catch (e) {
      return ApiResponse.error('Error deleting product category: $e');
    }
  }

  // GET /api/all_productcategors - Get all product categories (alternative endpoint)
  Future<PaginatedResponse<Category>> fetchAllProductCategories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.allProductCategories,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson = response.data['data'] ?? [];
        final categories = categoriesJson.map((json) => Category.fromJson(json)).toList();
        
        return PaginatedResponse<Category>(
          data: categories,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? categories.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch all product categories');
      }
    } catch (e) {
      throw Exception('Error fetching all product categories: $e');
    }
  }
}