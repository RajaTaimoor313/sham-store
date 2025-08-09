import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  final List<CartItem> items; // For backward compatibility

  CartLoaded({required this.cart, this.items = const []});

  @override
  List<Object?> get props => [cart, items];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartSuccess extends CartState {
  final String message;

  CartSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartAddingItem extends CartState {}

class CartItemAdded extends CartState {
  final String message;

  CartItemAdded({required this.message});

  @override
  List<Object?> get props => [message];
}

// Legacy state for backward compatibility
class CartLegacyState extends CartState {
  final List<CartItem> items;

  CartLegacyState({this.items = const []});

  CartLegacyState copyWith({List<CartItem>? items}) {
    return CartLegacyState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
