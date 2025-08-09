import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/head_text.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/themina/font_weight_help.dart';
import 'package:flutter_shamstore/core/widgets/text_button.dart';
import 'package:flutter_shamstore/features/cart/ui/my_cart_screen.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_event.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_state.dart';
import 'package:flutter_shamstore/features/categories/ui/product_page.dart';
import 'package:flutter_shamstore/features/home/ui/widgets/review_rating_page.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/favourites.dart';
import 'package:flutter_shamstore/features/wishlist/logic/wishlist_bloc.dart';
import 'package:flutter_shamstore/features/reviews/logic/review_bloc.dart';
import 'package:flutter_shamstore/features/reviews/logic/review_event.dart';
import 'package:flutter_shamstore/features/reviews/ui/widgets/review_summary_widget.dart';
import 'package:flutter_shamstore/core/repositories/review_repository.dart';
import 'package:flutter_shamstore/core/api/api_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final String productName;
  final double price;
  final String mainImageUrl;
  final List<String> productImages;
  final List<String> availableSizes;
  final List<Color> availableColors;
  final String description;
  final double rating;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.mainImageUrl,
    required this.productImages,
    required this.availableSizes,
    required this.availableColors,
    this.description =
        'Step into all-day comfort and iconic style with Nike Air\nMax. Designed with a cushioned sole and breathable\nmaterials, these sneakers deliver the perfect blend of\nperformance and street-ready look',
    this.rating = 4.0,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedSize = '';
  String selectedColor = '';
  late int rating;
  late ReviewBloc _reviewBloc;

  @override
  void initState() {
    super.initState();
    _reviewBloc = ReviewBloc(ReviewRepository(ApiService()));
    rating = widget.rating.toInt();

    // Load reviews for this product
    final productIdInt = int.tryParse(widget.productId.toString()) ?? 0;
    _reviewBloc.add(LoadProductReviews(productId: productIdInt));
    _reviewBloc.add(LoadReviewStatistics(productIdInt));

    print('🔍 ProductDetailsPage: Initialized with:');
    print('   - Product Name: ${widget.productName}');
    print('   - Main Image URL: ${widget.mainImageUrl}');
    print('   - Product Images Count: ${widget.productImages.length}');
    print('   - Price: ${widget.price}');
  }

  @override
  void dispose() {
    _reviewBloc.close();
    super.dispose();
  }

  void _addToCart() {
    print('🛒 Adding to cart: Product ID: ${widget.productId}, Quantity: 1, Price: ${widget.price}');
    BlocProvider.of<CartBloc>(context).add(AddToCart(
      productId: widget.productId, 
      quantity: 1,
      unitPrice: widget.price,
    ));
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: ColorsManager.mainBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _reviewBloc),
      ],
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartItemAdded) {
            _showToast('Item added to cart');
          } else if (state is CartError) {
            _showToast('Failed to add item to cart');
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الجزء العلوي
                  Container(
                    width: double.infinity,
                    height: 450.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.mainBlue,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<WishlistBloc>().add(
                                      AddToWishlist(
                                        productId: widget.productId,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Added to wishlist!'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // الصورة الرئيسية
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.mainImageUrl,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                print(
                                  '✅ ProductDetailsPage: Image loaded successfully: ${widget.mainImageUrl}',
                                );
                                return child;
                              }
                              print(
                                '⏳ ProductDetailsPage: Loading image: ${widget.mainImageUrl}',
                              );
                              return Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                '❌ ProductDetailsPage: Failed to load image: ${widget.mainImageUrl}',
                              );
                              print('❌ ProductDetailsPage: Error: $error');
                              return Container(
                                width: 200,
                                height: 200,
                                color: Colors.grey[200],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // الصور الصغيرة
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.productImages.map((imageUrl) {
                              return _buildSmallImage(imageUrl);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // باقي المحتوى
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المنتج والسعر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.productName,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsManager.mainBlue,
                                ),
                              ),
                            ),
                            Text(
                              '\$${widget.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.mainOrange,
                              ),
                            ),
                          ],
                        ),

                        verticalspace(12.h),

                        // تقييم المنتج
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: index < rating
                                    ? Colors.amber
                                    : Colors.grey[400],
                                size: 20,
                              );
                            }),
                            horizontalspace(8.w),
                            Text(
                              '(${widget.rating.toStringAsFixed(1)})',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),

                        verticalspace(20.h),

                        // وصف المنتج
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        verticalspace(30.h),

                        // الأحجام
                        if (widget.availableSizes.isNotEmpty) ...[
                          Text(
                            'Size:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalspace(12.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.availableSizes.map((size) {
                                bool isSelected = selectedSize == size;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSize = size;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 12.w),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorsManager.mainBlue
                                          : ColorsManager.lightBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          verticalspace(20.h),
                        ],

                        // الألوان
                        if (widget.availableColors.isNotEmpty) ...[
                          Text(
                            'Colour:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          verticalspace(12.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.availableColors
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    int index = entry.key;
                                    Color color = entry.value;
                                    bool isSelected =
                                        selectedColor == index.toString();

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = index.toString();
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 12.w),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? ColorsManager.mainBlue
                                                : ColorsManager.lightBlue,
                                            width: 3,
                                          ),
                                        ),
                                        child: Container(
                                          width: 30.w,
                                          height: 30.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: color == Colors.white
                                                ? Border.all(
                                                    color: Colors.grey[300]!,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                          verticalspace(16.h),
                          ReviewSummaryWidget(
                            productId: widget.productId.toString(),
                            productName: widget.productName,
                          ),

                          verticalspace(35.h),
                        ],

                        Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<CartBloc, CartState>(
                                builder: (context, state) {
                                  return AppTextButton(
                                    onPressed: state is CartAddingItem
                                        ? null
                                        : _addToCart,
                                    buttonText: state is CartAddingItem
                                        ? 'Adding...'
                                        : 'Add to Cart',
                                    textStyle: TextStyle(
                                      fontWeight: FontWeightHelper.medium,
                                      color: ColorsManager.mainWhite,
                                      fontSize: 16.sp,
                                    ),
                                  );
                                },
                              ),
                            ),
                            horizontalspace(5.w),
                            Expanded(
                              child: AppTextButton(
                                backgroundColor: ColorsManager.lightBlue,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyCartScreen(),
                                    ),
                                  );
                                },
                                buttonText: 'Buy Now',
                                textStyle: TextStyle(
                                  fontWeight: FontWeightHelper.medium,
                                  color: ColorsManager.mainBlue,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        verticalspace(16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
