import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_shamstore/features/categories/data/product_repository.dart';
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
