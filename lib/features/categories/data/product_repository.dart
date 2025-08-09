// // repositories/product_repository.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'models/product_model.dart';

// class ProductRepository {
//   Future<List<ProductModel>> fetchProductsByCategory(String categoryName) async {
//     final response = await http.get(Uri.parse('https://api.example.com/products?category=$categoryName'));

//     if (response.statusCode == 200) {
//       final List jsonData = json.decode(response.body);
//       return jsonData.map((e) => ProductModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
// }
import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  /// Fetch products with optional filters
  Future<PaginatedResponse<Product>> fetchProducts({
    int? categoryId,
    String? categoryName,
    String? search,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) async {
    print(
      '🔄 ProductRepository: fetchProducts called with categoryName: $categoryName, page: $page, limit: $limit',
    );
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      if (categoryName != null) {
        queryParams['category_name'] = categoryName;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }

      if (sortOrder != null) {
        queryParams['sort_order'] = sortOrder;
      }

      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }

      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }

      if (inStock != null) {
        queryParams['in_stock'] = inStock.toString();
      }

      print(
        '🌐 ProductRepository: Making API call to ${ApiConstants.allProducts} with params: $queryParams',
      );
      final response = await _apiService.get(
        ApiConstants.allProducts,
        queryParams: queryParams,
      );
      print(
        '📡 ProductRepository: API response received - Success: ${response.isSuccess}',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        print(
          '📊 ProductRepository: Found ${productsJson.length} products in API response',
        );
        final products = productsJson
            .map((json) => Product.fromJson(json))
            .toList();
        print(
          '✅ ProductRepository: Successfully parsed ${products.length} products',
        );

        return PaginatedResponse<Product>(
          data: products,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? products.length,
          perPage: limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        print('❌ ProductRepository: API call failed - ${response.message}');
        throw Exception(response.message ?? 'Failed to fetch products');
      }
    } catch (e) {
      print('🚨 ProductRepository: Exception occurred - $e');
      print('🔄 ProductRepository: Falling back to mock data');
      // Return fallback mock data if API fails
      final mockProducts = _getMockProducts(categoryName);
      print(
        '📦 ProductRepository: Returning ${mockProducts.length} mock products',
      );
      return PaginatedResponse<Product>(
        data: mockProducts,
        currentPage: 1,
        lastPage: 1,
        total: mockProducts.length,
        perPage: limit,
      );
    }
  }

  /// Fetch a single product by ID
  Future<Product?> fetchProductById(int id) async {
    try {
      final response = await _apiService.get('${ApiConstants.allProducts}/$id');

      if (response.isSuccess && response.data != null) {
        return Product.fromJson(response.data);
      } else {
        throw Exception(response.message ?? 'Failed to fetch product');
      }
    } catch (e) {
      return null;
    }
  }

  /// Fetch a single product by slug
  Future<ApiResponse<Product>> fetchProductBySlug(String slug) async {
    print('🔄 ProductRepository: fetchProductBySlug called with slug: $slug');
    try {
      print(
        '🌐 ProductRepository: Making API call to ${ApiConstants.allProducts}/$slug',
      );
      final response = await _apiService.get(
        '${ApiConstants.allProducts}/$slug',
        requireAuth: false, // Public endpoint, no authentication required
      );

      print(
        '📡 ProductRepository: API response received - Success: ${response.isSuccess}',
      );

      if (response.isSuccess && response.data != null) {
        print('✅ ProductRepository: Successfully received product data');
        final product = Product.fromJson(response.data);
        print(
          '📦 ProductRepository: Product parsed - Name: ${product.name}, ID: ${product.id}',
        );
        return ApiResponse.success(product);
      } else {
        print('❌ ProductRepository: API call failed - ${response.message}');
        return ApiResponse.error(
          response.message ?? 'Failed to fetch product by slug',
        );
      }
    } catch (e) {
      print('🚨 ProductRepository: Exception occurred - $e');
      return ApiResponse.error('Error fetching product: $e');
    }
  }

  /// Get product detail by slug - Public endpoint
  /// Makes GET request to http://ecom.addisanalytics.com/api/products/{slug}
  /// No authentication required, includes Accept: application/json header
  Future<ApiResponse<Product>> getProductDetail(String slug) async {
    print('🔄 ProductRepository: getProductDetail called with slug: $slug');
    try {
      final endpoint = '${ApiConstants.allProducts}/$slug';
      final fullUrl = '${ApiConstants.baseUrl}$endpoint';
      print('🌐 ProductRepository: Making API call to $fullUrl');

      // Make API request using ApiService with proper headers
      // ApiService automatically includes Accept: application/json header
      final response = await _apiService.get(
        endpoint,
        requireAuth: false, // Public endpoint, no authentication required
      );

      print(
        '📡 ProductRepository: API response received - Success: ${response.isSuccess}',
      );

      if (response.isSuccess && response.data != null) {
        print('✅ ProductRepository: Successfully received product detail data');
        final product = Product.fromJson(response.data);
        print(
          '📦 ProductRepository: Product detail parsed - Name: ${product.name}, ID: ${product.id}, Price: ${product.price}',
        );
        return ApiResponse.success(product);
      } else {
        print('❌ ProductRepository: API call failed - ${response.message}');
        return ApiResponse.error(
          response.message ?? 'Failed to fetch product detail',
        );
      }
    } catch (e) {
      print('🚨 ProductRepository: Exception occurred - $e');
      return ApiResponse.error('Error fetching product detail: $e');
    }
  }

  /// Search products
  Future<PaginatedResponse<Product>> searchProducts(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    return fetchProducts(search: searchTerm, page: page, limit: limit);
  }

  /// Fetch products by category
  Future<List<Product>> fetchProductsByCategory(String categoryName) async {
    final result = await fetchProducts(categoryName: categoryName);
    return result.data;
  }

  /// Fetch featured products
  Future<List<Product>> fetchFeaturedProducts({int limit = 10}) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.allProducts}/featured',
        queryParams: {'limit': limit.toString()},
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson =
            response.data['data'] ?? response.data;
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          response.message ?? 'Failed to fetch featured products',
        );
      }
    } catch (e) {
      return _getMockProducts().take(limit).toList();
    }
  }

  /// Fetch products with shipping information
  Future<List<Product>> fetchProductsWithShipping({int? categoryId}) async {
    try {
      final Map<String, String> queryParams = {'include_shipping': 'true'};

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      final response = await _apiService.get(
        '${ApiConstants.allProducts}/with-shipping',
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson =
            response.data['data'] ?? response.data;
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          response.message ?? 'Failed to fetch products with shipping',
        );
      }
    } catch (e) {
      return _getMockProducts();
    }
  }

  /// Fetch seller products (for seller dashboard)
  Future<PaginatedResponse<Product>> fetchSellerProducts({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _apiService.get(
        '${ApiConstants.allProducts}/seller',
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        final products = productsJson
            .map((json) => Product.fromJson(json))
            .toList();

        return PaginatedResponse<Product>(
          data: products,
          currentPage: response.data['current_page'] ?? page,
          lastPage: response.data['last_page'] ?? 1,
          total: response.data['total'] ?? products.length,
          perPage: response.data['per_page'] ?? limit,
          nextPageUrl: response.data['next_page_url'],
          prevPageUrl: response.data['prev_page_url'],
        );
      } else {
        throw Exception(response.message ?? 'Failed to fetch seller products');
      }
    } catch (e) {
      return PaginatedResponse<Product>(
        data: [],
        currentPage: 1,
        lastPage: 1,
        total: 0,
        perPage: limit,
      );
    }
  }

  /// Fallback mock data for offline/error scenarios
  List<Product> _getMockProducts([String? categoryName]) {
    switch (categoryName?.toLowerCase()) {
      case 'electronics':
        return [
          Product(
            id: 1,
            name: 'iPhone 15 Pro',
            price: 999.99,
            imageUrl:
                'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'IPH15PRO001',
            stock: 50,
            status: 'active',
            discountPrice: 899.99,
            images: [
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
            ],
            category: 'Electronics',
            brand: 'Apple',
            rating: 4.8,
            pricingTiers: [
              ProductPricingTier(
                id: 1,
                productId: 1,
                price: 999.99,
                minQuantity: 1,
                maxQuantity: null,
              ),
            ],
          ),
          Product(
            id: 2,
            name: 'Samsung Galaxy S24',
            price: 899.99,
            imageUrl:
                'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'SAM24001',
            stock: 30,
            status: 'active',
            discountPrice: 799.99,
            images: [
              'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&h=300&fit=crop',
            ],
            category: 'Electronics',
            brand: 'Samsung',
            rating: 4.6,
            pricingTiers: [
              ProductPricingTier(
                id: 2,
                productId: 2,
                price: 899.99,
                minQuantity: 1,
                maxQuantity: null,
              ),
            ],
          ),
        ];
      case 'fashion':
        return [
          Product(
            id: 4,
            name: 'Nike Air Max',
            price: 129.99,
            imageUrl:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
            categoryId: 2,
            sku: 'NIKE001',
            stock: 25,
            status: 'active',
            discountPrice: 109.99,
            images: [
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
            ],
            category: 'Fashion',
            brand: 'Nike',
            rating: 4.5,
            pricingTiers: [
              ProductPricingTier(
                id: 4,
                productId: 4,
                price: 129.99,
                minQuantity: 1,
                maxQuantity: null,
              ),
            ],
          ),
        ];
      default:
        return [
          Product(
            id: 1,
            name: 'iPhone 15 Pro',
            price: 999.99,
            imageUrl:
                'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'IPH15PRO001',
            stock: 50,
            status: 'active',
            discountPrice: 899.99,
            images: [
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
            ],
            category: 'Electronics',
            brand: 'Apple',
            rating: 4.8,
            pricingTiers: [
              ProductPricingTier(
                id: 1,
                productId: 1,
                price: 999.99,
                minQuantity: 1,
                maxQuantity: null,
              ),
            ],
          ),
          Product(
            id: 4,
            name: 'Nike Air Max',
            price: 129.99,
            imageUrl:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
            categoryId: 2,
            sku: 'NIKE001',
            stock: 25,
            status: 'active',
            discountPrice: 109.99,
            images: [
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
            ],
            category: 'Fashion',
            brand: 'Nike',
            rating: 4.5,
            pricingTiers: [
              ProductPricingTier(
                id: 4,
                productId: 4,
                price: 129.99,
                minQuantity: 1,
                maxQuantity: null,
              ),
            ],
          ),
        ];
    }
  }
}
