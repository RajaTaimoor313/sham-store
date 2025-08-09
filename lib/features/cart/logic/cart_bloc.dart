import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';
import '../../../core/repositories/cart_repository.dart';
import '../../../core/di/service_locator.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository = sl<CartRepository>();

  CartBloc() : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
    on<SyncCart>(_onSyncCart);
    on<GetCartItems>(_onGetCartItems);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    print('🛒 CartBloc: _onLoadCart called - emitting CartLoading');
    emit(CartLoading());

    try {
      print('🛒 CartBloc: Calling _cartRepository.getCart()');
      final response = await _cartRepository.getCart();

      if (response.isSuccess && response.data != null) {
        final cart = response.data!;
        print('🛒 CartBloc: Cart loaded successfully');
        print('🛒 CartBloc: Cart items count: ${cart.items.length}');
        print(
          '🛒 CartBloc: Cart items: ${cart.items.map((item) => '${item.productName} (qty: ${item.quantity})').toList()}',
        );
        print('🛒 CartBloc: Emitting CartLoaded state');
        emit(CartLoaded(cart: cart));
      } else {
        print('🛒 CartBloc: Failed to load cart - ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to load cart'));
      }
    } catch (e) {
      print('🛒 CartBloc: Exception in _onLoadCart: $e');
      emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    print(
      '🛒 CartBloc: _onAddToCart called with productId: ${event.productId}, quantity: ${event.quantity}',
    );

    // Emit loading state for add to cart operation
    emit(CartAddingItem());

    try {
      final response = await _cartRepository.addToCart(
        productId: event.productId,
        quantity: event.quantity,
        unitPrice: event.unitPrice,
        sellerId: event.sellerId,
        unit: event.unit,
        attributes: event.productAttributes,
      );

      if (response.isSuccess) {
        print('✅ CartBloc: Successfully added item to cart');
        // Emit success state with message
        emit(CartItemAdded(message: 'Added to cart successfully'));
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        print('❌ CartBloc: Failed to add item to cart - ${response.message}');
        emit(CartError(message: response.message ?? 'Failed to add to cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Failed to add to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final response = await _cartRepository.removeFromCart(event.cartItemId);

      if (response.isSuccess) {
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(
          CartError(message: response.message ?? 'Failed to remove from cart'),
        );
      }
    } catch (e) {
      emit(CartError(message: 'Failed to remove from cart: ${e.toString()}'));
    }
  }

  // Handle RemoveCartItem event - DELETE /api/cart/remove/{id}
  Future<void> _onRemoveCartItem(
    RemoveCartItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      print(
        '🛒 CartBloc: _onRemoveCartItem called - removing item with ID: ${event.id}',
      );

      final response = await _cartRepository.removeCartItem(event.id);

      if (response.isSuccess) {
        print('🛒 CartBloc: Item removed successfully: ${response.data}');
        // Show success message
        emit(
          CartSuccess(
            message: response.data ?? 'Item removed from cart successfully.',
          ),
        );
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        print('🛒 CartBloc: Failed to remove item: ${response.message}');
        emit(
          CartError(
            message: response.message ?? 'Failed to remove item from cart',
          ),
        );
      }
    } catch (e) {
      print('🛒 CartBloc: Exception in _onRemoveCartItem: $e');
      emit(
        CartError(message: 'Failed to remove item from cart: ${e.toString()}'),
      );
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final response = await _cartRepository.updateCartItem(
        event.cartItemId,
        quantity: event.quantity,
      );

      if (response.isSuccess) {
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(
          CartError(message: response.message ?? 'Failed to update quantity'),
        );
      }
    } catch (e) {
      emit(CartError(message: 'Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      final response = await _cartRepository.clearCart();

      if (response.isSuccess) {
        // Reload cart to get updated data
        add(LoadCart());
      } else {
        emit(CartError(message: response.message ?? 'Failed to clear cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onSyncCart(SyncCart event, Emitter<CartState> emit) async {
    try {
      final response = await _cartRepository.syncCart();

      if (response.isSuccess) {
        // Reload cart after sync
        add(LoadCart());
      } else {
        emit(CartError(message: response.message ?? 'Failed to sync cart'));
      }
    } catch (e) {
      emit(CartError(message: 'Failed to sync cart: ${e.toString()}'));
    }
  }

  // Handle GetCartItems event - View Cart API
  Future<void> _onGetCartItems(
    GetCartItems event,
    Emitter<CartState> emit,
  ) async {
    print('🛒 CartBloc: _onGetCartItems called - fetching cart from API');

    emit(CartLoading());

    try {
      final response = await _cartRepository.getCartItems();

      if (response.isSuccess && response.data != null) {
        final cart = response.data!;
        print(
          '🛒 CartBloc: Successfully fetched cart with ${cart.items.length} items',
        );
        emit(CartLoaded(cart: cart));
      } else {
        print('🛒 CartBloc: Failed to fetch cart items: ${response.message}');
        emit(
          CartError(message: response.message ?? 'Failed to fetch cart items'),
        );
      }
    } catch (e) {
      print('🛒 CartBloc: Exception in _onGetCartItems: $e');
      emit(CartError(message: 'Failed to fetch cart items: ${e.toString()}'));
    }
  }
}
