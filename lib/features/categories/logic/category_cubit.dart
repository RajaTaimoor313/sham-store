import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/categories/data/category_repository.dart';
import 'package:flutter_shamstore/features/categories/data/models/category_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit({CategoryRepository? repository})
    : _repository = repository ?? sl<CategoryRepository>(),
      super(CategoryInitial());

  Future<void> loadCategories() async {
    print('🎯 CategoryCubit: loadCategories() called');
    print('🔄 CategoryCubit: Emitting CategoryLoading state');
    emit(CategoryLoading());
    
    try {
      print('📞 CategoryCubit: Calling repository.fetchCategories()');
      final categories = await _repository.fetchCategories();
      print('✅ CategoryCubit: Successfully fetched ${categories.length} categories');
      print('🎉 CategoryCubit: Emitting CategoryLoaded state');
      emit(CategoryLoaded(categories));
    } catch (e) {
      print('❌ CategoryCubit: Error occurred: $e');
      print('🚨 CategoryCubit: Emitting CategoryError state');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> loadCategoryById(int categoryId) async {
    print('🎯 CategoryCubit: loadCategoryById($categoryId) called');
    emit(CategoryLoading());
    
    try {
      final category = await _repository.fetchCategoryById(categoryId);
      if (category != null) {
        print('✅ CategoryCubit: Category found: ${category.name}');
        emit(CategorySingleLoaded(category));
      } else {
        print('❌ CategoryCubit: Category not found');
        emit(CategoryError('Category not found'));
      }
    } catch (e) {
      print('🚨 CategoryCubit: Error in loadCategoryById: $e');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> loadParentCategories() async {
    print('🎯 CategoryCubit: loadParentCategories() called');
    emit(CategoryLoading());
    
    try {
      final categories = await _repository.fetchParentCategories();
      print('✅ CategoryCubit: Fetched ${categories.length} parent categories');
      emit(CategoryLoaded(categories));
    } catch (e) {
      print('🚨 CategoryCubit: Error in loadParentCategories: $e');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> loadSubcategories(int parentId) async {
    emit(CategoryLoading());
    try {
      final subcategories = await _repository.fetchSubcategories(parentId);
      emit(CategoryLoaded(subcategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> searchCategories(String searchTerm) async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.searchCategories(searchTerm);
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> loadFeaturedCategories({int limit = 10}) async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.fetchCategories();
      final limitedCategories = categories.take(limit).toList();
      emit(CategoryLoaded(limitedCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
