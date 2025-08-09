import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_shamstore/features/categories/logic/product_state.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailApiExample extends StatefulWidget {
  const ProductDetailApiExample({super.key});

  @override
  State<ProductDetailApiExample> createState() =>
      _ProductDetailApiExampleState();
}

class _ProductDetailApiExampleState extends State<ProductDetailApiExample> {
  final TextEditingController _slugController = TextEditingController();
  late ProductCubit _productCubit;

  @override
  void initState() {
    super.initState();
    _productCubit = sl<ProductCubit>();
  }

  @override
  void dispose() {
    _slugController.dispose();
    super.dispose();
  }

  void _fetchProductDetail() {
    final slug = _slugController.text.trim();
    if (slug.isNotEmpty) {
      // Use the new getProductDetail method that calls the specific endpoint
      _productCubit.getProductDetail(slug);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail API Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (_) => _productCubit,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Product Detail API Test',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter a product slug to fetch product details using GET /api/products/{slug}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addToCartExample');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test Add to Cart API'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/viewCartExample');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Test View Cart API'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _slugController,
                decoration: const InputDecoration(
                  labelText: 'Product Slug',
                  hintText: 'e.g., iphone-15-pro',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchProductBySlug,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Fetch Product Details'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Loading product details...'),
                          ],
                        ),
                      );
                    } else if (state is ProductLoaded &&
                        state.result.data.isNotEmpty) {
                      final product = state.result.data.first;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow('ID', product.id.toString()),
                              _buildDetailRow('Name', product.name),
                              _buildDetailRow('Price', '\$${product.price}'),
                              _buildDetailRow(
                                'Description',
                                product.description ?? 'N/A',
                              ),
                              _buildDetailRow(
                                'Stock Quantity',
                                product.stockQuantity?.toString() ?? 'N/A',
                              ),
                              _buildDetailRow(
                                'Category',
                                product.category?.name ?? 'N/A',
                              ),
                              const SizedBox(height: 16),
                              if (product.displayImage.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Product Image:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product.displayImage,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                height: 200,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    size: 50,
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ProductError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchProductDetail,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Enter a product slug and tap "Fetch Product Details" to test the API',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
