part of 'product_cubit.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final PaginatedResponse<Product> result;
  ProductLoaded(this.result);
}

class ProductLoadingMore extends ProductState {
  final PaginatedResponse<Product> currentResult;
  ProductLoadingMore(this.currentResult);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
