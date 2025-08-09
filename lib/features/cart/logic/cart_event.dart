import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

// Legacy events for backward compatibility
class AddItem extends CartEvent {
  final CartItem item;

  AddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final CartItem item;

  RemoveItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateQuantity extends CartEvent {
  final CartItem item;
  final int quantity;

  UpdateQuantity(this.item, this.quantity);

  @override
  List<Object?> get props => [item, quantity];
}

// New API-integrated events
class AddToCart extends CartEvent {
  final int productId;
  final int quantity;
  final double unitPrice;
  final int? sellerId;
  final String? unit;
  final Map<String, dynamic>? productAttributes;

  AddToCart({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.sellerId,
    this.unit,
    this.productAttributes,
  });

  @override
  List<Object?> get props => [
    productId,
    quantity,
    unitPrice,
    sellerId,
    unit,
    productAttributes,
  ];
}

class RemoveFromCart extends CartEvent {
  final String cartItemId;

  RemoveFromCart({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class RemoveCartItem extends CartEvent {
  final int id;

  RemoveCartItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;

  UpdateCartItemQuantity({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class ClearCart extends CartEvent {}

class SyncCart extends CartEvent {}

// Get cart items from API
class GetCartItems extends CartEvent {}
