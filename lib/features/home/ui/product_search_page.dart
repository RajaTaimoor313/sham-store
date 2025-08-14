import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_shamstore/features/home/ui/product_details_page.dart';

class ProductSearchPage extends StatelessWidget {
  final String query;

  const ProductSearchPage({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return Text(
              'Search: "$query"',
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
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }
          if (state is ProductLoaded) {
            final products = state.result.data;
            if (products.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text('No products found for "$query"'),
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
                  return GestureDetector(
                    onTap: () {
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
                            availableSizes: const ['S', 'M', 'L', 'XL'],
                            availableColors: const [
                              Colors.blue,
                              Colors.red,
                              Colors.green,
                            ],
                            description:
                                product.description ??
                                'No description available',
                            rating: 4.0,
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
