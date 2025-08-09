import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';
import 'package:flutter_shamstore/features/wishlist/logic/wishlist_bloc.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/core/helpers/storage_helper.dart';
import 'package:flutter_shamstore/core/repositories/auth_repository.dart';
import 'package:flutter_shamstore/core/api/api_service.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user is logged in and load wishlist
    _checkAuthAndLoadWishlist();
  }

  Future<void> _checkAuthAndLoadWishlist() async {
    final storageHelper = sl<StorageHelper>();
    final authRepository = sl<AuthRepository>();
    final apiService = sl<ApiService>();
    
    // Check authentication status
    final isLoggedIn = await authRepository.isLoggedIn();
    final authToken = await storageHelper.getAuthToken();
    
    print('🔍 FavouritesScreen: User logged in: $isLoggedIn');
    print('🔍 FavouritesScreen: Auth token exists: ${authToken != null}');
    
    if (authToken != null) {
      print('🔍 FavouritesScreen: Auth token (first 20 chars): ${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}...');
      // Ensure the API service has the auth token
      apiService.setAuthToken(authToken);
      print('🔍 FavouritesScreen: Auth token set in API service');
    }
    
    if (!isLoggedIn || authToken == null) {
      print('❌ FavouritesScreen: User not authenticated, showing error');
      // Show authentication error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to view your wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    // Load wishlist when screen is initialized
    print('🔍 FavouritesScreen: Dispatching LoadWishlist event');
    if (mounted) {
      context.read<WishlistBloc>().add(LoadWishlist());
    }
  }

  void _addToCart(BuildContext context, WishlistItem item) {
    final cartItem = CartItem(
      id: 0,
      cartId: 0,
      productId: item.productId,
      productName: item.productName,
      productImage: item.productImage,
      unitPrice: item.productPrice,
      quantity: 1,
      totalPrice: item.productPrice,
    );
    context.read<CartBloc>().add(AddItem(cartItem));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.productName} added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.tr('favourites')),
            centerTitle: true,
            backgroundColor: ColorsManager.mainWhite,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.sp),
            child: RefreshIndicator(
              onRefresh: () async {
                print('🔄 FavouritesScreen: Manual refresh triggered');
                context.read<WishlistBloc>().add(LoadWishlist());
              },
              child: BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  print('🔍 FavouritesScreen: Current state: ${state.runtimeType}');
                  if (state is WishlistLoading) {
                    print('🔍 FavouritesScreen: Showing loading indicator');
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is WishlistError) {
                    print('🔍 FavouritesScreen: Error state - ${state.message}');
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                              SizedBox(height: 16.h),
                              Text(
                                'Error loading wishlist',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                state.message,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<WishlistBloc>().add(LoadWishlist());
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  
                  if (state is WishlistLoaded) {
                    final wishlistItems = state.items;
                    print('🔍 FavouritesScreen: Wishlist loaded with ${wishlistItems.length} items');
                    
                    if (wishlistItems.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 64.sp, color: Colors.grey),
                                SizedBox(height: 16.h),
                                Text(
                                  'Your wishlist is empty',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Add items to your wishlist to see them here',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: wishlistItems.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                      final item = wishlistItems[index];
                      return Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: ColorsManager.mainWhite,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 88.w,
                                  maxHeight: 88.w,
                                ),
                                child: item.productImage != null
                                    ? Image.network(
                                        item.productImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40.sp,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.image,
                                          size: 40.sp,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsManager.mainBlack,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    if (item.productSku != null)
                                      Text(
                                        'SKU: ${item.productSku}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: ColorsManager.mainGrey,
                                        ),
                                      ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '\$${item.productPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: ColorsManager.mainBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context.read<WishlistBloc>().add(
                                      RemoveFromWishlist(productId: item.productId),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.shopping_cart,
                                    color: ColorsManager.mainBlue,
                                  ),
                                  onPressed: () => _addToCart(context, item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      },
                    );
                  }
                  
                  // Default state
                  return const Center(child: Text('Loading...'));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
