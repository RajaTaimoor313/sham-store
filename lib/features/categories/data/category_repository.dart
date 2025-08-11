import 'package:flutter_shamstore/core/api/api_service.dart';
import 'package:flutter_shamstore/core/api/api_constants.dart';
import 'package:flutter_shamstore/features/categories/data/models/category_model.dart';

class CategoryRepository {
  final ApiService _apiService = ApiService();

  /// Fetch all categories from the API
  Future<List<Category>> fetchCategories({
    int? parentId,
    bool includeSubcategories = false,
  }) async {
    print('🔍 CategoryRepository: Starting fetchCategories...');
    print('📋 CategoryRepository: parentId=$parentId, includeSubcategories=$includeSubcategories');
    
    try {
      final Map<String, String> queryParams = {};

      if (parentId != null) {
        queryParams['parent_id'] = parentId.toString();
      }

      if (includeSubcategories) {
        queryParams['include_subcategories'] = 'true';
      }

      print('🌐 CategoryRepository: Making API call to ${ApiConstants.productCategory}');
      print('📝 CategoryRepository: Query params: $queryParams');
      
      final response = await _apiService.get(
        ApiConstants.productCategory,
        queryParams: queryParams,
      );

      print('📡 CategoryRepository: API response received');
      print('✅ CategoryRepository: Response success: ${response.isSuccess}');
      print('📊 CategoryRepository: Response data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson =
            response.data['data'] ?? response.data;
        print('📦 CategoryRepository: Found ${categoriesJson.length} categories in response');
        
        final categories = categoriesJson
            .map((json) => Category.fromJson(json))
            .where((category) => category.isActive)
            .toList();
            
        print('✨ CategoryRepository: Returning ${categories.length} active categories');
        for (var category in categories) {
          print('   - ${category.name} (ID: ${category.id})');
        }
        
        return categories;
      } else {
        print('❌ CategoryRepository: API call failed: ${response.message}');
        throw Exception(response.message ?? 'Failed to fetch categories');
      }
    } catch (e) {
      print('🚨 CategoryRepository: Exception caught: $e');
      print('🔄 CategoryRepository: Falling back to mock data');
      // Return fallback mock data if API fails
      return _getMockCategories();
    }
  }

  /// Fetch a single category by ID
  Future<Category?> fetchCategoryById(int id) async {
    print('🔍 CategoryRepository: Fetching category by ID: $id');
    
    try {
      final response = await _apiService.get(
        '${ApiConstants.productCategory}/$id',
      );
      
      print('📡 CategoryRepository: fetchCategoryById response: ${response.isSuccess}');

      if (response.isSuccess && response.data != null) {
        return Category.fromJson(response.data);
      } else {
        throw Exception(response.message ?? 'Failed to fetch category');
      }
    } catch (e) {
      return null;
    }
  }

  /// Search categories by name
  Future<List<Category>> searchCategories(String searchTerm) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.productCategory}/search',
        queryParams: {'search': searchTerm},
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson =
            response.data['data'] ?? response.data;
        return categoriesJson
            .map((json) => Category.fromJson(json))
            .where((category) => category.isActive)
            .toList();
      } else {
        throw Exception(response.message ?? 'Failed to search categories');
      }
    } catch (e) {
      return [];
    }
  }

  /// Fetch parent categories only
  Future<List<Category>> fetchParentCategories() async {
    return fetchCategories(parentId: null);
  }

  /// Fetch subcategories for a parent category
  Future<List<Category>> fetchSubcategories(int parentId) async {
    return fetchCategories(parentId: parentId);
  }

  /// Get categories with product counts
  Future<List<Category>> fetchCategoriesWithProductCount() async {
    try {
      final response = await _apiService.get(
        ApiConstants.productCategory,
        queryParams: {'include_product_count': 'true'},
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> categoriesJson =
            response.data['data'] ?? response.data;
        return categoriesJson
            .map((json) => Category.fromJson(json))
            .where((category) => category.isActive)
            .toList();
      } else {
        throw Exception(response.message ?? 'Failed to fetch categories');
      }
    } catch (e) {
      return _getMockCategories();
    }
  }

  /// Fallback mock data for offline/error scenarios
  List<Category> _getMockCategories() {
    return [
      Category(
        id: 1,
        name: 'Electronics',
        icon: 'electronics',
        colorHex: '#2196F3',
        sortOrder: 1,
        isActive: true,
        productCount: 150,
      ),
      Category(
        id: 2,
        name: 'Fashion',
        icon: 'fashion',
        colorHex: '#E91E63',
        sortOrder: 2,
        isActive: true,
        productCount: 200,
      ),
      Category(
        id: 3,
        name: 'Home & Garden',
        icon: 'home',
        colorHex: '#4CAF50',
        sortOrder: 3,
        isActive: true,
        productCount: 80,
      ),
      Category(
        id: 4,
        name: 'Sports',
        icon: 'sports',
        colorHex: '#FF9800',
        sortOrder: 4,
        isActive: true,
        productCount: 120,
      ),
      Category(
        id: 5,
        name: 'Books',
        icon: 'books',
        colorHex: '#9C27B0',
        sortOrder: 5,
        isActive: true,
        productCount: 90,
      ),
      Category(
        id: 6,
        name: 'Beauty',
        icon: 'beauty',
        colorHex: '#F44336',
        sortOrder: 6,
        isActive: true,
        productCount: 110,
      ),
      Category(
        id: 7,
        name: 'Food & Drink',
        icon: 'food',
        colorHex: '#795548',
        sortOrder: 7,
        isActive: true,
        productCount: 60,
      ),
      Category(
        id: 8,
        name: 'Toys',
        icon: 'toys',
        colorHex: '#607D8B',
        sortOrder: 8,
        isActive: true,
        productCount: 75,
      ),
    ];
  }
}
