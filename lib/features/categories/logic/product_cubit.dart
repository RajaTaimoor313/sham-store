import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/categories/data/product_repository.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/api/api_response.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit({ProductRepository? repository})
    : _repository = repository ?? sl<ProductRepository>(),
      super(ProductInitial());

  Future<void> loadProducts({
    String? categoryName,
    int? categoryId,
    String? search,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) async {
    print('🎯 ProductCubit: loadProducts called with categoryName: $categoryName, search: $search, page: $page');
    emit(ProductLoading());
    print('📡 ProductCubit: Emitted ProductLoading state');
    try {
      final result = await _repository.fetchProducts(
        categoryName: categoryName,
        categoryId: categoryId,
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStock: inStock,
      );
      print('✅ ProductCubit: Successfully fetched ${result.data.length} products');
      emit(ProductLoaded(result));
      print('📊 ProductCubit: Emitted ProductLoaded state with ${result.data.length} products');
    } catch (e) {
      print('❌ ProductCubit: Error loading products - $e');
      emit(ProductError(e.toString()));
      print('🚨 ProductCubit: Emitted ProductError state');
    }
  }

  Future<void> loadProductsByCategory(String categoryName) async {
    print('🏷️ ProductCubit: loadProductsByCategory called for: $categoryName');
    await loadProducts(categoryName: categoryName);
  }

  Future<void> searchProducts(String searchTerm, {int page = 1}) async {
    print('🔍 ProductCubit: searchProducts called with term: $searchTerm, page: $page');
    await loadProducts(search: searchTerm, page: page);
  }

  Future<void> loadFeaturedProducts({int limit = 10}) async {
    emit(ProductLoading());
    try {
      final products = await _repository.fetchFeaturedProducts(limit: limit);
      final result = PaginatedResponse<Product>(
        data: products,
        currentPage: 1,
        lastPage: 1,
        total: products.length,
        perPage: products.length,
      );
      emit(ProductLoaded(result));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> loadProductById(int productId) async {
    emit(ProductLoading());
    try {
      final product = await _repository.fetchProductById(productId);
      final result = PaginatedResponse<Product>(
        data: product != null ? [product] : [],
        currentPage: 1,
        lastPage: 1,
        total: 1,
        perPage: 1,
      );
      emit(ProductLoaded(result));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> loadProductBySlug(String slug) async {
    print('🏷️ ProductCubit: loadProductBySlug called for slug: $slug');
    emit(ProductLoading());
    print('📡 ProductCubit: Emitted ProductLoading state');
    try {
      final response = await _repository.fetchProductBySlug(slug);
      
      if (response.isSuccess && response.data != null) {
        print('✅ ProductCubit: Successfully fetched product by slug');
        final result = PaginatedResponse<Product>(
          data: [response.data!],
          currentPage: 1,
          lastPage: 1,
          total: 1,
          perPage: 1,
        );
        emit(ProductLoaded(result));
        print('📊 ProductCubit: Emitted ProductLoaded state with product: ${response.data!.name}');
      } else {
        print('❌ ProductCubit: Failed to fetch product by slug - ${response.message}');
        emit(ProductError(response.message ?? 'Failed to fetch product'));
        print('🚨 ProductCubit: Emitted ProductError state');
      }
    } catch (e) {
      print('❌ ProductCubit: Error loading product by slug - $e');
      emit(ProductError(e.toString()));
      print('🚨 ProductCubit: Emitted ProductError state');
    }
  }

  /// Get product detail by slug using the public API endpoint
  /// Makes GET request to http://ecom.addisanalytics.com/api/products/{slug}
  Future<void> getProductDetail(String slug) async {
    print('🔍 ProductCubit: getProductDetail called for slug: $slug');
    emit(ProductLoading());
    print('📡 ProductCubit: Emitted ProductLoading state');
    try {
      final response = await _repository.getProductDetail(slug);
      
      if (response.isSuccess && response.data != null) {
        print('✅ ProductCubit: Successfully fetched product detail');
        final result = PaginatedResponse<Product>(
          data: [response.data!],
          currentPage: 1,
          lastPage: 1,
          total: 1,
          perPage: 1,
        );
        emit(ProductLoaded(result));
        print('📊 ProductCubit: Emitted ProductLoaded state with product detail: ${response.data!.name}');
      } else {
        print('❌ ProductCubit: Failed to fetch product detail - ${response.message}');
        emit(ProductError(response.message ?? 'Failed to fetch product detail'));
        print('🚨 ProductCubit: Emitted ProductError state');
      }
    } catch (e) {
      print('❌ ProductCubit: Error getting product detail - $e');
      emit(ProductError(e.toString()));
      print('🚨 ProductCubit: Emitted ProductError state');
    }
  }

  Future<void> loadMoreProducts() async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (currentState.result.hasNextPage) {
        emit(ProductLoadingMore(currentState.result));
        try {
          final result = await _repository.fetchProducts(
            page: currentState.result.currentPage + 1,
          );

          final updatedResult = PaginatedResponse<Product>(
            data: [...currentState.result.data, ...result.data],
            currentPage: result.currentPage,
            lastPage: result.lastPage,
            total: result.total,
            perPage: result.perPage,
            nextPageUrl: result.nextPageUrl,
            prevPageUrl: result.prevPageUrl,
          );

          emit(ProductLoaded(updatedResult));
        } catch (e) {
          emit(ProductError(e.toString()));
        }
      }
    }
  }
}
