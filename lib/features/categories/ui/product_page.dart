import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/features/home/ui/show_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_shamstore/features/categories/data/product_repository.dart';
import 'package:flutter_shamstore/features/categories/data/models/product_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/features/home/ui/product_details_page.dart';

class ProductsPage extends StatelessWidget {
  final String categoryName;

  const ProductsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    print('🏪 ProductsPage: Building page for category: $categoryName');
    return BlocProvider(
      create: (context) {
        print(
          '🎯 ProductsPage: Creating ProductCubit for category: $categoryName',
        );
        return ProductCubit(repository: sl<ProductRepository>())
          ..loadProductsByCategory(categoryName);
      },
      child: ProductsPageContent(categoryName: categoryName),
    );
  }
}

class ProductsPageContent extends StatelessWidget {
  final String categoryName;

  const ProductsPageContent({super.key, required this.categoryName});

  // منتجات وهمية لكل فئة
  List<ProductItem> _getProductsForCategory() {
    switch (categoryName.toLowerCase()) {
      case 'computers':
        return [
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
            title: 'MacBook Pro',
            price: '\$1999',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1587831990711-23ca6441447b?w=500',
            title: 'Gaming PC',
            price: '\$1500',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
        ];
      case 'home':
        return [
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=500',
            title: 'Modern Lamp',
            price: '\$120',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500',
            title: 'Home Decor',
            price: '\$80',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
        ];
      case 'headphones':
        return [
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
            title: 'Wireless Headphones',
            price: '\$80',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500',
            title: 'Gaming Headset',
            price: '\$150',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
        ];
      case 'shoes':
        return [
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
            title: 'Nike Air Max',
            price: '\$90',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
            title: 'Adidas Sneakers',
            price: '\$110',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
        ];
      default:
        return [
          ProductItem(
            imageUrl:
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
            title: 'Sample Product',
            price: '\$50',
            cartIcon: Icons.shopping_cart,
            onCartPressed: () {},
            onFavoritePressed: () {},
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 ProductsPageContent: Building UI for category: $categoryName');

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Text(
              categoryName,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          print(
            '🔄 ProductsPageContent: BlocBuilder rebuilding with state: ${state.runtimeType}',
          );

          if (state is ProductLoading) {
            print('⏳ ProductsPageContent: Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            print('❌ ProductsPageContent: Showing error: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'خطأ في تحميل المنتجات',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      print('🔄 ProductsPageContent: Retry button pressed');
                      context.read<ProductCubit>().loadProductsByCategory(
                        categoryName,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is ProductLoaded) {
            final products = state.result.data;
            print(
              '✅ ProductsPageContent: Displaying ${products.length} products',
            );

            if (products.isEmpty) {
              print(
                '📭 ProductsPageContent: No products found for category: $categoryName',
              );
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64.w,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'لا توجد منتجات في هذه الفئة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  print(
                    '🛍️ ProductsPageContent: Building product item ${index + 1}/${products.length} - ${product.name}',
                  );

                  return GestureDetector(
                    onTap: () {
                      print(
                        '👆 ProductsPageContent: Product tapped: ${product.name}',
                      );
                      print(
                        '🔗 ProductsPageContent: Navigating to product details with image: ${product.displayImage}',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            productId: product.id,
                            productName: product.name,
                            price:
                                double.tryParse(product.price.toString()) ??
                                0.0,
                            mainImageUrl: product.displayImage,
                            productImages: product.gallery?.isNotEmpty == true
                                ? product.gallery!
                                      .map((g) => g.imageUrl)
                                      .toList()
                                : [product.displayImage],
                            availableSizes: [
                              'S',
                              'M',
                              'L',
                              'XL',
                            ], // Default sizes
                            availableColors: [
                              Colors.blue,
                              Colors.red,
                              Colors.green,
                            ], // Default colors
                            description:
                                product.description ??
                                'No description available',
                            rating: 4.0, // Default rating since not in model
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.r),
                              ),
                              child: Image.network(
                                product.displayImage,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 40.w,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    product.displayPrice,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          print(
            '🤔 ProductsPageContent: Unknown state, showing empty container',
          );
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
// ui/products_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_shamstore/features/categories/data/product_repository.dart';
// import '../../categories/logic/product_cubit.dart';

// class ProductsPage extends StatelessWidget {
//   final String categoryName;

//   const ProductsPage({super.key, required this.categoryName});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ProductCubit(ProductRepository())..loadProducts(categoryName),
//       child: Scaffold(
//         appBar: AppBar(title: Text(categoryName)),
//         body: BlocBuilder<ProductCubit, ProductState>(
//           builder: (context, state) {
//             if (state is ProductLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ProductLoaded) {
//               return ListView.builder(
//                 itemCount: state.products.length,
//                 itemBuilder: (context, index) {
//                   final product = state.products[index];
//                   return ListTile(
//                     leading: Image.network(product.imageUrl, width: 60),
//                     title: Text(product.title),
//                     subtitle: Text('\$${product.price}'),
//                   );
//                 },
//               );
//             } else if (state is ProductError) {
//               return Center(child: Text(state.message));
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }
