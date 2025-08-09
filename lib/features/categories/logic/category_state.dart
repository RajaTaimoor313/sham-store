part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  CategoryLoaded(this.categories);
}

class CategorySingleLoaded extends CategoryState {
  final Category category;
  CategorySingleLoaded(this.category);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
