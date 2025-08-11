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

  // GET /api/product - Get all products
  Future<PaginatedResponse<Product>> getAllProducts({
    int page = 1,
    int limit = 20,
  }) async {
    print('🔄 ProductRepository: getAllProducts called with page: $page, limit: $limit');
    try {
      print('🌐 ProductRepository: Making API call to ${ApiConstants.product}');
      print('📝 ProductRepository: Query params: {page: $page, limit: $limit}');
      
      final response = await _apiService.get(
        ApiConstants.product,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        print('📦 ProductRepository: Found ${productsJson.length} products in response');
        final products = productsJson.map((json) => Product.fromJson(json)).toList();
        print('✅ ProductRepository: Successfully parsed ${products.length} products');
        
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
      throw Exception('Error fetching products: $e');
    }
  }

  // GET /api/product/:id - Get product by ID
  Future<ApiResponse<Product>> getProductById(int id) async {
    print('🔄 ProductRepository: getProductById called with id: $id');
    try {
      print('🌐 ProductRepository: Making API call to ${ApiConstants.product}/$id');
      final response = await _apiService.get('${ApiConstants.product}/$id');
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');
      
      if (response.isSuccess && response.data != null) {
        final product = Product.fromJson(response.data);
        print('✅ ProductRepository: Successfully parsed product - Name: ${product.name}, ID: ${product.id}');
        return ApiResponse.success(product);
      } else {
        print('❌ ProductRepository: API call failed - ${response.message}');
        return ApiResponse.error(response.message ?? 'Failed to fetch product');
      }
    } catch (e) {
      print('🚨 ProductRepository: Exception occurred - $e');
      return ApiResponse.error('Error fetching product: $e');
    }
  }

  // GET /api/search_product/:search_term - Search products
  Future<PaginatedResponse<Product>> searchProducts(
    String searchTerm, {
    int page = 1,
    int limit = 20,
  }) async {
    print('🔄 ProductRepository: searchProducts called with term: "$searchTerm", page: $page, limit: $limit');
    try {
      print('🌐 ProductRepository: Making API call to ${ApiConstants.searchProduct}/$searchTerm');
      print('📝 ProductRepository: Query params: {page: $page, limit: $limit}');
      
      final response = await _apiService.get(
        '${ApiConstants.searchProduct}/$searchTerm',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        print('📦 ProductRepository: Found ${productsJson.length} products matching "$searchTerm"');
        final products = productsJson.map((json) => Product.fromJson(json)).toList();
        print('✅ ProductRepository: Successfully parsed ${products.length} search results');
        
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
        print('❌ ProductRepository: Search API call failed - ${response.message}');
        throw Exception(response.message ?? 'Failed to search products');
      }
    } catch (e) {
      print('🚨 ProductRepository: Search exception occurred - $e');
      throw Exception('Error searching products: $e');
    }
  }

  // POST /api/product - Create new product
  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> productData) async {
    print('🔄 ProductRepository: createProduct called');
    print('📝 ProductRepository: Product data: $productData');
    try {
      print('🌐 ProductRepository: Making POST API call to ${ApiConstants.product}');
      print('🔐 ProductRepository: Using authentication for create operation');
      
      final response = await _apiService.post(
        ApiConstants.product,
        body: productData,
        requireAuth: true,
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');
      
      if (response.isSuccess && response.data != null) {
        final product = Product.fromJson(response.data);
        print('✅ ProductRepository: Successfully created product - Name: ${product.name}, ID: ${product.id}');
        return ApiResponse.success(product);
      } else {
        print('❌ ProductRepository: Create API call failed - ${response.message}');
        return ApiResponse.error(response.message ?? 'Failed to create product');
      }
    } catch (e) {
      print('🚨 ProductRepository: Create exception occurred - $e');
      return ApiResponse.error('Error creating product: $e');
    }
  }

  // PUT /api/product/:id - Update product
  Future<ApiResponse<Product>> updateProduct(int id, Map<String, dynamic> productData) async {
    print('🔄 ProductRepository: updateProduct called with id: $id');
    print('📝 ProductRepository: Update data: $productData');
    try {
      print('🌐 ProductRepository: Making PUT API call to ${ApiConstants.product}/$id');
      print('🔐 ProductRepository: Using authentication for update operation');
      
      final response = await _apiService.put(
        '${ApiConstants.product}/$id',
        body: productData,
        requireAuth: true,
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');
      
      if (response.isSuccess && response.data != null) {
        final product = Product.fromJson(response.data);
        print('✅ ProductRepository: Successfully updated product - Name: ${product.name}, ID: ${product.id}');
        return ApiResponse.success(product);
      } else {
        print('❌ ProductRepository: Update API call failed - ${response.message}');
        return ApiResponse.error(response.message ?? 'Failed to update product');
      }
    } catch (e) {
      print('🚨 ProductRepository: Update exception occurred - $e');
      return ApiResponse.error('Error updating product: $e');
    }
  }

  // DELETE /api/product/:id - Delete product
  Future<ApiResponse<bool>> deleteProduct(int id) async {
    print('🔄 ProductRepository: deleteProduct called with id: $id');
    try {
      print('🌐 ProductRepository: Making DELETE API call to ${ApiConstants.product}/$id');
      print('🔐 ProductRepository: Using authentication for delete operation');
      
      final response = await _apiService.delete(
        '${ApiConstants.product}/$id',
        requireAuth: true,
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response message: ${response.message}');
      
      if (response.isSuccess) {
        print('✅ ProductRepository: Successfully deleted product with id: $id');
        return ApiResponse.success(true);
      } else {
        print('❌ ProductRepository: Delete API call failed - ${response.message}');
        return ApiResponse.error(response.message ?? 'Failed to delete product');
      }
    } catch (e) {
      print('🚨 ProductRepository: Delete exception occurred - $e');
      return ApiResponse.error('Error deleting product: $e');
    }
  }

  // GET /api/all_products - Get all products (alternative endpoint)
  Future<PaginatedResponse<Product>> fetchAllProducts({
    int page = 1,
    int limit = 20,
  }) async {
    print('🔄 ProductRepository: fetchAllProducts called with page: $page, limit: $limit');
    try {
      print('🌐 ProductRepository: Making API call to ${ApiConstants.allProducts}');
      print('📝 ProductRepository: Query params: {page: $page, limit: $limit}');
      
      final response = await _apiService.get(
        ApiConstants.allProducts,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      
      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        print('📦 ProductRepository: Found ${productsJson.length} products in all products response');
        final products = productsJson.map((json) => Product.fromJson(json)).toList();
        print('✅ ProductRepository: Successfully parsed ${products.length} products from all products');
        
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
        print('❌ ProductRepository: Fetch all products API call failed - ${response.message}');
        throw Exception(response.message ?? 'Failed to fetch all products');
      }
    } catch (e) {
      print('🚨 ProductRepository: Fetch all products exception occurred - $e');
      throw Exception('Error fetching all products: $e');
    }
  }

  /// Fetch products by category using dedicated endpoint
  Future<PaginatedResponse<Product>> fetchProductsByCategory({
    required String categoryName,
    int? categoryId,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) async {
    print(
      '🔄 ProductRepository: fetchProductsByCategory called with categoryName: $categoryName, categoryId: $categoryId, page: $page, limit: $limit',
    );
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'category_name': categoryName,
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
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
        '🌐 ProductRepository: Making API call to ${ApiConstants.productsByCategory} with params: $queryParams',
      );
      final response = await _apiService.get(
        ApiConstants.productsByCategory,
        queryParams: queryParams,
      );
      print(
        '📡 ProductRepository: API response received - Success: ${response.isSuccess}',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> productsJson = response.data['data'] ?? [];
        print(
          '📊 ProductRepository: Found ${productsJson.length} products in category API response',
        );
        final products = productsJson
            .map((json) => Product.fromJson(json))
            .toList();
        print(
          '✅ ProductRepository: Successfully parsed ${products.length} products for category: $categoryName',
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
        print('❌ ProductRepository: Category API call failed - ${response.message}');
        throw Exception(response.message ?? 'Failed to fetch products by category');
      }
    } catch (e) {
      print('🚨 ProductRepository: Category API exception occurred - $e');
      print('🔄 ProductRepository: Falling back to mock data for category: $categoryName');
      // Return fallback mock data if API fails
      final mockProducts = _getMockProducts(categoryName);
      print(
        '📦 ProductRepository: Returning ${mockProducts.length} mock products for category: $categoryName',
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

  /// Fetch products with optional filters (legacy method for backward compatibility)
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
    
    // If category is specified, use the dedicated category endpoint
    if (categoryName != null && categoryName.isNotEmpty) {
      return fetchProductsByCategory(
        categoryName: categoryName,
        categoryId: categoryId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStock,
      );
    }
    
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
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
    print('🔄 ProductRepository: fetchProductById called with id: $id');
    try {
      print('🌐 ProductRepository: Making API call to ${ApiConstants.allProducts}/$id');
      final response = await _apiService.get('${ApiConstants.allProducts}/$id');

      print('📡 ProductRepository: API response received');
      print('✅ ProductRepository: Response success: ${response.isSuccess}');
      print('📊 ProductRepository: Response data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final product = Product.fromJson(response.data);
        print('✅ ProductRepository: Successfully fetched product - Name: ${product.name}, ID: ${product.id}');
        return product;
      } else {
        print('❌ ProductRepository: Fetch product by ID failed - ${response.message}');
        throw Exception(response.message ?? 'Failed to fetch product');
      }
    } catch (e) {
      print('🚨 ProductRepository: Fetch product by ID exception occurred - $e');
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
            id: 101,
            name: 'iPhone 15 Pro',
            price: 999.99,
            imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'IPH15PRO001',
            stock: 50,
            status: 'active',
            discountPrice: 899.99,
            images: ['https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=300&h=300&fit=crop'],
            category: 'Electronics',
            brand: 'Apple',
            rating: 4.8,
            pricingTiers: [ProductPricingTier(id: 1, productId: 101, price: 999.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 102,
            name: 'Samsung Galaxy S24',
            price: 899.99,
            imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'SAM24001',
            stock: 30,
            status: 'active',
            discountPrice: 799.99,
            images: ['https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300&h=300&fit=crop'],
            category: 'Electronics',
            brand: 'Samsung',
            rating: 4.6,
            pricingTiers: [ProductPricingTier(id: 2, productId: 102, price: 899.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 103,
            name: 'MacBook Air M3',
            price: 1299.99,
            imageUrl: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=300&h=300&fit=crop',
            categoryId: 1,
            sku: 'MBA001',
            stock: 15,
            status: 'active',
            discountPrice: 1199.99,
            images: ['https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=300&h=300&fit=crop'],
            category: 'Electronics',
            brand: 'Apple',
            rating: 4.9,
            pricingTiers: [ProductPricingTier(id: 3, productId: 103, price: 1299.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
      case 'fashion':
      case 'clothing':
        return [
          Product(
            id: 201,
            name: 'Nike Air Max 270',
            price: 129.99,
            imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
            categoryId: 2,
            sku: 'NIKE270001',
            stock: 25,
            status: 'active',
            discountPrice: 109.99,
            images: ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop'],
            category: 'Fashion',
            brand: 'Nike',
            rating: 4.5,
            pricingTiers: [ProductPricingTier(id: 4, productId: 201, price: 129.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 202,
            name: 'Adidas Ultraboost 22',
            price: 159.99,
            imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=300&h=300&fit=crop',
            categoryId: 2,
            sku: 'ADI22001',
            stock: 20,
            status: 'active',
            discountPrice: 139.99,
            images: ['https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=300&h=300&fit=crop'],
            category: 'Fashion',
            brand: 'Adidas',
            rating: 4.7,
            pricingTiers: [ProductPricingTier(id: 5, productId: 202, price: 159.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 203,
            name: 'Levi\'s 501 Jeans',
            price: 89.99,
            imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=300&h=300&fit=crop',
            categoryId: 2,
            sku: 'LEV501001',
            stock: 40,
            status: 'active',
            discountPrice: 79.99,
            images: ['https://images.unsplash.com/photo-1542272604-787c3835535d?w=300&h=300&fit=crop'],
            category: 'Fashion',
            brand: 'Levi\'s',
            rating: 4.4,
            pricingTiers: [ProductPricingTier(id: 6, productId: 203, price: 89.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
      case 'home':
      case 'home & garden':
        return [
          Product(
            id: 301,
            name: 'IKEA Malm Bed Frame',
            price: 199.99,
            imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=300&fit=crop',
            categoryId: 3,
            sku: 'IKE001',
            stock: 12,
            status: 'active',
            discountPrice: 179.99,
            images: ['https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300&h=300&fit=crop'],
            category: 'Home & Garden',
            brand: 'IKEA',
            rating: 4.3,
            pricingTiers: [ProductPricingTier(id: 7, productId: 301, price: 199.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 302,
            name: 'Philips Hue Smart Bulb',
            price: 49.99,
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
            categoryId: 3,
            sku: 'PHI001',
            stock: 35,
            status: 'active',
            discountPrice: 44.99,
            images: ['https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop'],
            category: 'Home & Garden',
            brand: 'Philips',
            rating: 4.6,
            pricingTiers: [ProductPricingTier(id: 8, productId: 302, price: 49.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
      case 'books':
        return [
          Product(
            id: 401,
            name: 'The Great Gatsby',
            price: 12.99,
            imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=300&fit=crop',
            categoryId: 4,
            sku: 'BOOK001',
            stock: 100,
            status: 'active',
            discountPrice: 9.99,
            images: ['https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=300&fit=crop'],
            category: 'Books',
            brand: 'Penguin Classics',
            rating: 4.2,
            pricingTiers: [ProductPricingTier(id: 9, productId: 401, price: 12.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 402,
            name: 'Clean Code',
            price: 39.99,
            imageUrl: 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=300&h=300&fit=crop',
            categoryId: 4,
            sku: 'BOOK002',
            stock: 50,
            status: 'active',
            discountPrice: 34.99,
            images: ['https://images.unsplash.com/photo-1532012197267-da84d127e765?w=300&h=300&fit=crop'],
            category: 'Books',
            brand: 'Prentice Hall',
            rating: 4.8,
            pricingTiers: [ProductPricingTier(id: 10, productId: 402, price: 39.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
      case 'sports':
      case 'sports & outdoors':
        return [
          Product(
            id: 501,
            name: 'Wilson Tennis Racket',
            price: 89.99,
            imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=300&h=300&fit=crop',
            categoryId: 5,
            sku: 'WIL001',
            stock: 18,
            status: 'active',
            discountPrice: 79.99,
            images: ['https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=300&h=300&fit=crop'],
            category: 'Sports & Outdoors',
            brand: 'Wilson',
            rating: 4.4,
            pricingTiers: [ProductPricingTier(id: 11, productId: 501, price: 89.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 502,
            name: 'Yoga Mat Premium',
            price: 29.99,
            imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=300&fit=crop',
            categoryId: 5,
            sku: 'YOGA001',
            stock: 60,
            status: 'active',
            discountPrice: 24.99,
            images: ['https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=300&fit=crop'],
            category: 'Sports & Outdoors',
            brand: 'FitnessPro',
            rating: 4.5,
            pricingTiers: [ProductPricingTier(id: 12, productId: 502, price: 29.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
      default:
        // Return a mix of products for unknown categories
        return [
          Product(
            id: 999,
            name: 'Sample Product 1',
            price: 49.99,
            imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop',
            categoryId: 99,
            sku: 'SAMPLE001',
            stock: 10,
            status: 'active',
            discountPrice: 39.99,
            images: ['https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=300&fit=crop'],
            category: categoryName ?? 'General',
            brand: 'Generic',
            rating: 4.0,
            pricingTiers: [ProductPricingTier(id: 99, productId: 999, price: 49.99, minQuantity: 1, maxQuantity: null)],
          ),
          Product(
            id: 998,
            name: 'Sample Product 2',
            price: 79.99,
            imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
            categoryId: 99,
            sku: 'SAMPLE002',
            stock: 15,
            status: 'active',
            discountPrice: 69.99,
            images: ['https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop'],
            category: categoryName ?? 'General',
            brand: 'Generic',
            rating: 4.2,
            pricingTiers: [ProductPricingTier(id: 98, productId: 998, price: 79.99, minQuantity: 1, maxQuantity: null)],
          ),
        ];
    }
  }
}
