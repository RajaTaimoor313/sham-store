import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';

class ProductGalleryRepository {
  final ApiService _apiService = ApiService();

  // GET /api/productgaller - Get all product galleries
  Future<PaginatedResponse<ProductGallery>> getAllProductGalleries({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.productGallery,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> galleriesJson = response.data['data'] ?? [];
        final galleries = galleriesJson.map((json) => ProductGallery.fromJson(json)).toList();
        
        return PaginatedResponse<ProductGallery>(
          data: galleries,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? galleries.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch product galleries');
      }
    } catch (e) {
      throw Exception('Error fetching product galleries: $e');
    }
  }

  // GET /api/productgaller/:id - Get product gallery by ID
  Future<ApiResponse<ProductGallery>> getProductGalleryById(int id) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.productGallery}/$id',
      );

      if (response.isSuccess && response.data != null) {
        final gallery = ProductGallery.fromJson(response.data!);
        return ApiResponse.success(gallery);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to fetch product gallery');
      }
    } catch (e) {
      return ApiResponse.error('Error fetching product gallery: $e');
    }
  }

  // GET /api/search_productgaller/:search_term - Search product galleries
  Future<PaginatedResponse<ProductGallery>> searchProductGalleries(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.searchProductGallery}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> galleriesJson = response.data['data'] ?? [];
        final galleries = galleriesJson.map((json) => ProductGallery.fromJson(json)).toList();
        
        return PaginatedResponse<ProductGallery>(
          data: galleries,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? galleries.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to search product galleries');
      }
    } catch (e) {
      throw Exception('Error searching product galleries: $e');
    }
  }

  // POST /api/productgaller - Create product gallery
  Future<ApiResponse<ProductGallery>> createProductGallery(Map<String, dynamic> galleryData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.productGallery,
        body: galleryData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final gallery = ProductGallery.fromJson(response.data!);
        return ApiResponse.success(gallery);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to create product gallery');
      }
    } catch (e) {
      return ApiResponse.error('Error creating product gallery: $e');
    }
  }

  // PUT /api/productgaller/:id - Update product gallery
  Future<ApiResponse<ProductGallery>> updateProductGallery(int id, Map<String, dynamic> galleryData) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.productGallery}/$id',
        body: galleryData,
        requireAuth: true,
      );
      
      if (response.isSuccess && response.data != null) {
        final gallery = ProductGallery.fromJson(response.data!);
        return ApiResponse.success(gallery);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to update product gallery');
      }
    } catch (e) {
      return ApiResponse.error('Error updating product gallery: $e');
    }
  }

  // DELETE /api/productgaller/:id - Delete product gallery
  Future<ApiResponse<bool>> deleteProductGallery(int id) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.productGallery}/$id',
        requireAuth: true,
      );
      
      if (response.isSuccess) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(response.message ?? 'Failed to delete product gallery');
      }
    } catch (e) {
      return ApiResponse.error('Error deleting product gallery: $e');
    }
  }

  // GET /api/all_productgallers - Get all product galleries (alternative endpoint)
  Future<PaginatedResponse<ProductGallery>> fetchAllProductGalleries({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.allProductGalleries,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> galleriesJson = response.data['data'] ?? [];
        final galleries = galleriesJson.map((json) => ProductGallery.fromJson(json)).toList();
        
        return PaginatedResponse<ProductGallery>(
          data: galleries,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? galleries.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch all product galleries');
      }
    } catch (e) {
      throw Exception('Error fetching all product galleries: $e');
    }
  }
}