import '../api/api_service.dart';
import '../api/api_constants.dart';
import '../api/api_response.dart';
import '../models/cart_model.dart';
import 'auth_repository.dart';
import '../di/service_locator.dart';

class CartRepository {
  final ApiService _apiService = ApiService();

  // Get cart items from API
  Future<ApiResponse<Cart>> getCart() async {
    try {
      print('🛒 CartRepository: getCart called - fetching from API');

      // Get current user ID using service locator
      final currentUser = await sl<AuthRepository>().getStoredUser();
      final currentUserId = currentUser?.id;
      print(
        '🛒 CartRepository: Current user: ${currentUser?.name ?? 'Not logged in'}',
      );
      print(
        '🛒 CartRepository: Current user ID for filtering: ${currentUserId ?? 'null (no user)'}',
      );

      // Get cart from API only
      final response = await _apiService.get(
        ApiConstants.cart,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: API response successful');
        print('🛒 CartRepository: Raw response data: ${response.data}');
        print(
          '🛒 CartRepository: Response data type: ${response.data.runtimeType}',
        );

        try {
          final cart = Cart.fromJson(response.data!);
          print('🛒 CartRepository: Cart parsed successfully');
          print(
            '🛒 CartRepository: Total cart items before filtering: ${cart.items.length}',
          );

          // Filter cart items by current user ID (customer_id)
          if (currentUserId != null) {
            // Filter cart items to only include items that belong to the current user
            final userCartItems = cart.items.where((item) => item.customerId == currentUserId).toList();
            
            print(
              '🛒 CartRepository: Filtered cart items for user $currentUserId: ${userCartItems.length}/${cart.items.length} items',
            );
            
            if (userCartItems.isNotEmpty) {
              print(
                '🛒 CartRepository: ✅ Found ${userCartItems.length} items for current user',
              );
              print(
                '🛒 CartRepository: User cart items: ${userCartItems.map((item) => '${item.productName} (qty: ${item.quantity}, customer: ${item.customerId})').join(', ')}',
              );
              
              // Create a new cart with filtered items and correct user ID
              final filteredCart = Cart(
                id: cart.id,
                userId: currentUserId,
                items: userCartItems,
                subtotal: userCartItems.fold(0.0, (sum, item) => sum + item.totalPrice),
                tax: cart.tax,
                shipping: cart.shipping,
                total: userCartItems.fold(0.0, (sum, item) => sum + item.totalPrice) + cart.tax + cart.shipping,
                createdAt: cart.createdAt,
                updatedAt: cart.updatedAt,
              );
              
              return ApiResponse.success(filteredCart);
            } else {
              print(
                '🛒 CartRepository: ❌ No cart items found for current user (ID: $currentUserId)',
              );
              final emptyCart = Cart.empty(currentUserId);
              return ApiResponse.success(emptyCart);
            }
          } else {
            print(
              '🛒 CartRepository: ⚠️ No authenticated user found, returning empty cart',
            );
            final emptyCart = Cart.empty(0);
            return ApiResponse.success(emptyCart);
          }
        } catch (parseError) {
          print('🛒 CartRepository: Error parsing cart data: $parseError');
          return ApiResponse.error(
            'Failed to parse cart data: ${parseError.toString()}',
          );
        }
      } else {
        print('🛒 CartRepository: API response failed');
        print('🛒 CartRepository: Success: ${response.isSuccess}');
        print('🛒 CartRepository: Message: ${response.message}');
        print('🛒 CartRepository: Error: ${response.error}');
        print('🛒 CartRepository: Data: ${response.data}');
        return ApiResponse.error(
          response.error ?? 'Failed to fetch cart from server',
        );
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in getCart: $e');
      return ApiResponse.error('Failed to fetch cart: ${e.toString()}');
    }
  }

  // Get cart items - dedicated method for View Cart API
  // GET /api/cart with authentication
  Future<ApiResponse<Cart>> getCartItems() async {
    try {
      print('🛒 CartRepository: getCartItems called - GET /api/cart');

      // Get current user ID using service locator
      final currentUser = await sl<AuthRepository>().getStoredUser();
      final currentUserId = currentUser?.id;
      print(
        '🛒 CartRepository: getCartItems Current user: ${currentUser?.name ?? 'Not logged in'}',
      );
      print(
        '🛒 CartRepository: getCartItems Current user ID for filtering: ${currentUserId ?? 'null (no user)'}',
      );

      final response = await _apiService.get(
        ApiConstants.cart,
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: getCartItems API response successful');
        print(
          '🛒 CartRepository: getCartItems Raw response data: ${response.data}',
        );
        print(
          '🛒 CartRepository: getCartItems Response data type: ${response.data.runtimeType}',
        );

        try {
          final cart = Cart.fromJson(response.data!);
          print('🛒 CartRepository: getCartItems Cart parsed successfully');
          print(
            '🛒 CartRepository: getCartItems Total cart items before filtering: ${cart.items.length}',
          );

          // Filter cart by current user ID
          List<CartItem> filteredItems = cart.items;
          if (currentUserId != null) {
            // Filter items where cart.userId matches current user ID
            if (cart.userId == currentUserId) {
              filteredItems = cart.items;
              print(
                '🛒 CartRepository: getCartItems ✅ Cart belongs to current user (ID: ${cart.userId}), keeping all ${filteredItems.length} items',
              );
              print(
                '🛒 CartRepository: getCartItems Customer ID used for filtering: $currentUserId',
              );
            } else {
              filteredItems = [];
              print(
                '🛒 CartRepository: getCartItems ❌ Cart belongs to different user (Cart User ID: ${cart.userId}, Current User ID: $currentUserId), filtering out all items',
              );
              print(
                '🛒 CartRepository: getCartItems Customer ID used for filtering: $currentUserId',
              );
            }
          } else {
            print(
              '🛒 CartRepository: getCartItems ⚠️ No authenticated user found, returning empty cart',
            );
            print(
              '🛒 CartRepository: getCartItems Customer ID used for filtering: null (no user authenticated)',
            );
            filteredItems = [];
          }

          // Create filtered cart
          final filteredCart = Cart(
            id: cart.id,
            userId: cart.userId,
            items: filteredItems,
            subtotal: cart.subtotal,
            tax: cart.tax,
            shipping: cart.shipping,
            total: cart.total,
            createdAt: cart.createdAt,
            updatedAt: cart.updatedAt,
          );

          print(
            '🛒 CartRepository: getCartItems Filtered cart items count: ${filteredCart.items.length}',
          );
          print(
            '🛒 CartRepository: getCartItems Filtered cart items: ${filteredCart.items.map((item) => '${item.productName} (qty: ${item.quantity})').toList()}',
          );
          return ApiResponse.success(filteredCart);
        } catch (parseError) {
          print(
            '🛒 CartRepository: getCartItems Error parsing cart data: $parseError',
          );
          return ApiResponse.error(
            'Failed to parse cart data: ${parseError.toString()}',
          );
        }
      } else {
        print('🛒 CartRepository: getCartItems API response failed');
        print('🛒 CartRepository: Success: ${response.isSuccess}');
        print('🛒 CartRepository: Message: ${response.message}');
        print('🛒 CartRepository: Error: ${response.error}');
        print('🛒 CartRepository: Data: ${response.data}');
        return ApiResponse.error(
          response.error ?? 'Failed to fetch cart items from server',
        );
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in getCartItems: $e');
      return ApiResponse.error('Failed to fetch cart items: ${e.toString()}');
    }
  }

  // Add item to cart
  // POST /api/carts with required headers and authentication
  Future<ApiResponse<Cart>> addToCart({
    required int productId,
    required int quantity,
    required double unitPrice,
    String? variantId,
    Map<String, dynamic>? attributes,
    int? sellerId,
    String? unit,
  }) async {
    try {
      print(
        '🛒 CartRepository: addToCart called - POST ${ApiConstants.addToCart}',
      );
      print('🛒 CartRepository: Product ID: $productId, Quantity: $quantity');

      final requestBody = {
        'seller_id': sellerId ?? 1, // Default seller_id if not provided
        'product_id': productId, // API expects product_id as integer
        'quantity': quantity.toString(), // API expects quantity as string
        'unit': unit ?? 'piece', // Default unit if not provided
        'unit_price': unitPrice.toString(), // API expects unit_price as string
        if (variantId != null) 'variant_id': variantId,
        if (attributes != null) 'attributes': attributes,
      };

      print('🛒 CartRepository: Request body: $requestBody');

      final response = await _apiService.post(
        ApiConstants.addToCart,
        body: requestBody,
        requireAuth: true, // Requires Bearer token authentication
      );

      print('🛒 CartRepository: Add to cart response received');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: Add to cart successful');
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        print('🛒 CartRepository: Add to cart failed: ${response.error}');
        // Check for authentication errors
        if (response.message?.contains('token') == true ||
            response.message?.contains('unauthorized') == true ||
            response.message?.contains('Unauthenticated') == true) {
          return ApiResponse.error(
            'Authentication failed. Please login again.',
          );
        }
        return ApiResponse.error(
          response.error ?? 'Failed to add item to cart',
        );
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in addToCart: $e');
      // Check if it's a network/auth error
      if (e.toString().contains('401') ||
          e.toString().contains('unauthorized')) {
        return ApiResponse.error('Authentication failed. Please login again.');
      }
      return ApiResponse.error('Failed to add item to cart: ${e.toString()}');
    }
  }

  // Remove item from cart
  Future<ApiResponse<Cart>> removeFromCart(String itemId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.removeFromCart}/$itemId',
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to remove item from cart',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to remove item from cart: ${e.toString()}',
      );
    }
  }

  // Remove cart item by ID - DELETE /api/cart/remove/{id}
  Future<ApiResponse<String>> removeCartItem(int id) async {
    try {
      print(
        '🛒 CartRepository: removeCartItem called - DELETE /api/cart/remove/$id',
      );

      final response = await _apiService.delete(
        '/api/cart/remove/$id',
        requireAuth: true,
      );

      if (response.isSuccess) {
        print('🛒 CartRepository: removeCartItem API response successful');
        return ApiResponse.success('Item removed from cart successfully.');
      } else {
        print('🛒 CartRepository: removeCartItem API response failed');
        print('🛒 CartRepository: Error: ${response.error}');
        return ApiResponse.error(
          response.error ?? 'Failed to remove item from cart',
        );
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in removeCartItem: $e');
      return ApiResponse.error(
        'Failed to remove item from cart: ${e.toString()}',
      );
    }
  }

  // Update cart item
  // PUT /api/cart/update/{itemId} with required headers and authentication
  Future<ApiResponse<Cart>> updateCartItem(
    String itemId, {
    int? quantity,
    Map<String, dynamic>? attributes,
  }) async {
    try {
      print(
        '🛒 CartRepository: updateCartItem called - PUT ${ApiConstants.updateCartItem}/$itemId',
      );
      print('🛒 CartRepository: Item ID: $itemId, Quantity: $quantity');

      final requestBody = <String, dynamic>{};
      if (quantity != null) requestBody['quantity'] = quantity;
      if (attributes != null) requestBody['attributes'] = attributes;

      print('🛒 CartRepository: Request body: $requestBody');

      final response = await _apiService.put(
        '${ApiConstants.updateCartItem}/$itemId',
        body: requestBody,
        requireAuth: true, // Requires Bearer token authentication
      );

      print('🛒 CartRepository: Update cart item response received');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: Update cart item successful');
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        print(
          '❌ CartRepository: Update cart item failed - ${response.message}',
        );
        return ApiResponse.error(
          response.message ?? 'Failed to update cart item',
        );
      }
    } catch (e) {
      print('❌ CartRepository: Update cart item error - $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  // Update cart item quantity (legacy method for backward compatibility)
  // PUT /api/cart/update/{itemId} with required headers and authentication
  Future<ApiResponse<Cart>> updateCartItemQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.updateCartItem}/$itemId',
        body: {'quantity': quantity},
        requireAuth: true,
      );

      if (response.isSuccess && response.data != null) {
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        return ApiResponse.error(
          response.error ?? 'Failed to update cart item',
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to update cart item: ${e.toString()}');
    }
  }

  // Get wishlist
  // GET /api/wishlist with required headers and authentication
  Future<ApiResponse<List<WishlistItem>>> getWishlist() async {
    try {
      print(
        '❤️ CartRepository: getWishlist called - GET ${ApiConstants.allWishlists}',
      );

      final response = await _apiService.get(
        ApiConstants.allWishlists,
        requireAuth: true, // Requires Bearer token authentication
      );

      print('❤️ CartRepository: Get wishlist response received');

      if (response.isSuccess && response.data != null) {
        print('❤️ CartRepository: Get wishlist successful');
        final wishlistItems = (response.data as List<dynamic>)
            .map((item) => WishlistItem.fromJson(item))
            .toList();
        // Wishlist data from API only
        return ApiResponse.success(wishlistItems);
      } else {
        print('❌ CartRepository: Get wishlist failed - ${response.message}');
        // Return empty list if API fails
        return ApiResponse.success(<WishlistItem>[]);
      }
    } catch (e) {
      print('❌ CartRepository: Get wishlist error - $e');
      // Return empty list if network error
      return ApiResponse.success(<WishlistItem>[]);
    }
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(int productId) async {
    try {
      final wishlistResponse = await getWishlist();
      if (wishlistResponse.isSuccess && wishlistResponse.data != null) {
        final wishlistItems = wishlistResponse.data!;
        return wishlistItems.any((item) => item.productId == productId);
      }
      return false;
    } catch (e) {
      print('❌ CartRepository: isInWishlist error - $e');
      return false;
    }
  }

  // Remove from wishlist by product ID (finds the wishlist item first)
  Future<ApiResponse<String>> removeFromWishlistByProductId(
    int productId,
  ) async {
    try {
      print('❤️ CartRepository: Removing product $productId from wishlist');

      // First get the wishlist to find the item ID
      final wishlistResponse = await getWishlist();
      if (wishlistResponse.isSuccess && wishlistResponse.data != null) {
        final wishlistItems = wishlistResponse.data!;
        final wishlistItem = wishlistItems.firstWhere(
          (item) => item.productId == productId,
          orElse: () => throw Exception('Product not found in wishlist'),
        );

        // Now remove using the wishlist item ID
        return await removeFromWishlist(wishlistItem.id);
      } else {
        return ApiResponse.error('Failed to get wishlist');
      }
    } catch (e) {
      print('❌ CartRepository: Remove from wishlist by product ID error - $e');
      return ApiResponse.error(
        'Failed to remove from wishlist: ${e.toString()}',
      );
    }
  }

  // Clear cart
  Future<ApiResponse<Cart>> clearCart() async {
    try {
      print(
        '🛒 CartRepository: clearCart called - DELETE ${ApiConstants.clearCart}',
      );

      // Get current user ID for creating empty cart
      final currentUser = await sl<AuthRepository>().getStoredUser();
      final currentUserId = currentUser?.id ?? 0;
      print(
        '🛒 CartRepository: clearCart Customer ID for empty cart: $currentUserId',
      );

      final response = await _apiService.delete(
        ApiConstants.clearCart,
        requireAuth: true,
      );

      if (response.isSuccess) {
        print('🛒 CartRepository: clearCart API response successful');
        final emptyCart = Cart.empty(currentUserId);
        print(
          '🛒 CartRepository: clearCart Created empty cart for user ID: $currentUserId',
        );
        return ApiResponse.success(emptyCart);
      } else {
        print(
          '🛒 CartRepository: clearCart API response failed: ${response.error}',
        );
        return ApiResponse.error(response.error ?? 'Failed to clear cart');
      }
    } catch (e) {
      print('🛒 CartRepository: clearCart Exception: $e');
      return ApiResponse.error('Failed to clear cart: ${e.toString()}');
    }
  }

  // Sync cart with server
  Future<ApiResponse<Cart>> syncCart() async {
    try {
      // Simply fetch the latest cart from server
      return await getCart();
    } catch (e) {
      return ApiResponse.error('Failed to sync cart: ${e.toString()}');
    }
  }

  // NEW CART API METHODS based on Postman collection

  // POST /api/carts - Create new cart
  Future<ApiResponse<Cart>> createCart({
    required String name,
    required String email,
    required int sellerId,
    required int productId,
    required String quantity,
    required String unit,
    required String unitPrice,
  }) async {
    try {
      print(
        '🛒 CartRepository: createCart called - POST ${ApiConstants.carts}',
      );
      print('🛒 CartRepository: Creating cart for: $name ($email)');
      print(
        '🛒 CartRepository: Product: $productId, Quantity: $quantity, Unit Price: $unitPrice',
      );

      final requestBody = {
        'name': name,
        'email': email,
        'seller_id': sellerId,
        'product_id': productId,
        'quantity': quantity,
        'unit': unit,
        'unit_price': unitPrice,
      };

      print('🛒 CartRepository: Request body: $requestBody');

      final response = await _apiService.post(
        ApiConstants.carts,
        body: requestBody,
        requireAuth: true,
      );

      print('🛒 CartRepository: Create cart response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ Cart created successfully');
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        print('🛒 CartRepository: ❌ Failed to create cart: ${response.error}');
        return ApiResponse.error(response.error ?? 'Failed to create cart');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in createCart: $e');
      return ApiResponse.error('Failed to create cart: ${e.toString()}');
    }
  }

  // GET /api/carts - Get user's carts
  Future<ApiResponse<List<Cart>>> getUserCarts() async {
    try {
      print(
        '🛒 CartRepository: getUserCarts called - GET ${ApiConstants.carts}',
      );

      final response = await _apiService.get(
        ApiConstants.carts,
        requireAuth: true,
      );

      print('🛒 CartRepository: Get user carts response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ User carts fetched successfully');
        final cartsList = (response.data as List<dynamic>)
            .map((cartData) => Cart.fromJson(cartData))
            .toList();
        print('🛒 CartRepository: Found ${cartsList.length} carts');
        return ApiResponse.success(cartsList);
      } else {
        print(
          '🛒 CartRepository: ❌ Failed to fetch user carts: ${response.error}',
        );
        return ApiResponse.error(
          response.error ?? 'Failed to fetch user carts',
        );
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in getUserCarts: $e');
      return ApiResponse.error('Failed to fetch user carts: ${e.toString()}');
    }
  }

  // GET /api/carts/all - Get all carts (admin/seller view)
  Future<ApiResponse<List<Cart>>> getAllCarts() async {
    try {
      print(
        '🛒 CartRepository: getAllCarts called - GET ${ApiConstants.allCarts}',
      );

      final response = await _apiService.get(
        ApiConstants.allCarts,
        requireAuth: true,
      );

      print('🛒 CartRepository: Get all carts response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ All carts fetched successfully');
        final cartsList = (response.data as List<dynamic>)
            .map((cartData) => Cart.fromJson(cartData))
            .toList();
        print('🛒 CartRepository: Found ${cartsList.length} total carts');
        return ApiResponse.success(cartsList);
      } else {
        print(
          '🛒 CartRepository: ❌ Failed to fetch all carts: ${response.error}',
        );
        return ApiResponse.error(response.error ?? 'Failed to fetch all carts');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in getAllCarts: $e');
      return ApiResponse.error('Failed to fetch all carts: ${e.toString()}');
    }
  }

  // GET /api/carts/{id} - Get cart by ID
  Future<ApiResponse<Cart>> getCartById(int cartId) async {
    try {
      print(
        '🛒 CartRepository: getCartById called - GET ${ApiConstants.cartById}/$cartId',
      );

      final response = await _apiService.get(
        '${ApiConstants.cartById}/$cartId',
        requireAuth: true,
      );

      print('🛒 CartRepository: Get cart by ID response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ Cart fetched successfully by ID: $cartId');
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        print(
          '🛒 CartRepository: ❌ Failed to fetch cart by ID: ${response.error}',
        );
        return ApiResponse.error(response.error ?? 'Failed to fetch cart');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in getCartById: $e');
      return ApiResponse.error('Failed to fetch cart: ${e.toString()}');
    }
  }

  // PUT /api/carts/{id} - Update cart by ID
  Future<ApiResponse<Cart>> updateCartById(
    int cartId, {
    required int sellerId,
    required int productId,
    required String quantity,
    required String unit,
    required String unitPrice,
  }) async {
    try {
      print(
        '🛒 CartRepository: updateCartById called - PUT ${ApiConstants.updateCart}/$cartId',
      );
      print('🛒 CartRepository: Updating cart ID: $cartId');
      print(
        '🛒 CartRepository: Product: $productId, Quantity: $quantity, Unit Price: $unitPrice',
      );

      final requestBody = {
        'seller_id': sellerId,
        'product_id': productId,
        'quantity': quantity,
        'unit': unit,
        'unit_price': unitPrice,
      };

      print('🛒 CartRepository: Request body: $requestBody');

      final response = await _apiService.put(
        '${ApiConstants.updateCart}/$cartId',
        body: requestBody,
        requireAuth: true,
      );

      print('🛒 CartRepository: Update cart response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ Cart updated successfully: $cartId');
        final cart = Cart.fromJson(response.data!);
        return ApiResponse.success(cart);
      } else {
        print('🛒 CartRepository: ❌ Failed to update cart: ${response.error}');
        return ApiResponse.error(response.error ?? 'Failed to update cart');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in updateCartById: $e');
      return ApiResponse.error('Failed to update cart: ${e.toString()}');
    }
  }

  // DELETE /api/carts/{id} - Delete cart by ID
  Future<ApiResponse<String>> deleteCartById(int cartId) async {
    try {
      print(
        '🛒 CartRepository: deleteCartById called - DELETE ${ApiConstants.deleteCart}/$cartId',
      );

      final response = await _apiService.delete(
        '${ApiConstants.deleteCart}/$cartId',
        requireAuth: true,
      );

      print('🛒 CartRepository: Delete cart response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Message: ${response.message}');

      if (response.isSuccess) {
        print('🛒 CartRepository: ✅ Cart deleted successfully: $cartId');
        return ApiResponse.success('Cart deleted successfully');
      } else {
        print('🛒 CartRepository: ❌ Failed to delete cart: ${response.error}');
        return ApiResponse.error(response.error ?? 'Failed to delete cart');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in deleteCartById: $e');
      return ApiResponse.error('Failed to delete cart: ${e.toString()}');
    }
  }

  // GET /api/carts/search/{query} - Search carts
  Future<ApiResponse<List<Cart>>> searchCarts(String query) async {
    try {
      print(
        '🛒 CartRepository: searchCarts called - GET ${ApiConstants.searchCarts}/$query',
      );
      print('🛒 CartRepository: Search query: $query');

      final response = await _apiService.get(
        '${ApiConstants.searchCarts}/$query',
        requireAuth: true,
      );

      print('🛒 CartRepository: Search carts response received');
      print('🛒 CartRepository: Success: ${response.isSuccess}');
      print('🛒 CartRepository: Data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        print('🛒 CartRepository: ✅ Cart search completed successfully');
        final cartsList = (response.data as List<dynamic>)
            .map((cartData) => Cart.fromJson(cartData))
            .toList();
        print(
          '🛒 CartRepository: Found ${cartsList.length} carts matching "$query"',
        );
        return ApiResponse.success(cartsList);
      } else {
        print('🛒 CartRepository: ❌ Failed to search carts: ${response.error}');
        return ApiResponse.error(response.error ?? 'Failed to search carts');
      }
    } catch (e) {
      print('🛒 CartRepository: Exception in searchCarts: $e');
      return ApiResponse.error('Failed to search carts: ${e.toString()}');
    }
  }

  // Private helper methods removed - using API only

  // Wishlist methods
  Future<ApiResponse<String>> addToWishlist(int productId) async {
    try {
      print('❤️ CartRepository: Adding product $productId to wishlist');

      final response = await _apiService.post(
        ApiConstants.addToWishlist,
        body: {'product_id': productId},
        requireAuth: true,
      );

      if (response.isSuccess) {
        print('❤️ CartRepository: Successfully added to wishlist');
        // Wishlist updated on server only
        return ApiResponse.success('Product added to wishlist successfully');
      } else {
        print(
          '❌ CartRepository: Failed to add to wishlist - ${response.message}',
        );
        return ApiResponse.error(response.error ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      print('❌ CartRepository: Add to wishlist error - $e');
      return ApiResponse.error('Failed to add to wishlist: ${e.toString()}');
    }
  }

  Future<ApiResponse<String>> removeFromWishlist(int wishlistItemId) async {
    try {
      print('❤️ CartRepository: Removing wishlist item $wishlistItemId');

      final response = await _apiService.delete(
        '${ApiConstants.removeFromWishlist}/$wishlistItemId',
        requireAuth: true,
      );

      if (response.isSuccess) {
        print('❤️ CartRepository: Successfully removed from wishlist');
        // Refresh wishlist to get updated data
        await getWishlist();
        return ApiResponse.success(
          'Product removed from wishlist successfully',
        );
      } else {
        print(
          '❌ CartRepository: Failed to remove from wishlist - ${response.message}',
        );
        return ApiResponse.error(
          response.error ?? 'Failed to remove from wishlist',
        );
      }
    } catch (e) {
      print('❌ CartRepository: Remove from wishlist error - $e');
      return ApiResponse.error(
        'Failed to remove from wishlist: ${e.toString()}',
      );
    }
  }

  // Local wishlist methods removed - using API only
}
