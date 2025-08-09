import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/head_text.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/features/categories/ui/my_all_categories.dart';
import 'package:flutter_shamstore/features/categories/ui/product_page.dart';
import 'package:flutter_shamstore/features/home/ui/dynamic_product_view.dart';
import 'package:flutter_shamstore/features/home/ui/home_categor.dart';
import 'package:flutter_shamstore/features/home/ui/home_image_name_notif.dart';
import 'package:flutter_shamstore/features/home/ui/home_text_field_button.dart';
import 'package:flutter_shamstore/features/home/ui/product_details_page.dart';
import 'package:flutter_shamstore/features/home/ui/show_product.dart';
import 'package:flutter_shamstore/features/home/ui/widgets/promo_section.dart';
import 'package:flutter_shamstore/features/home/ui/widgets/promo_section_white.dart';
import 'package:flutter_shamstore/features/home/ui/widgets/sale_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_shamstore/core/localization/localization_helper.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/wishlist/logic/wishlist_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToProducts(String categoryName, int categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(categoryName: categoryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
                child: Column(
                  children: [
                    ImageNameNotif(),
                    verticalspace(26.h),
                    TextFieldSButton(),
                    verticalspace(15.h),

                    DynamicProductView(
                      promoData: [
                        PromoItem(
                          text: context.tr('fashion_discount_promo'),
                          imageUrl:
                              'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=600&fit=crop',
                          buttonText: context.tr('shop_now'),
                          onButtonPressed: () {},
                        ),
                        PromoItem(
                          text: context.tr('summer_sale_promo'),
                          imageUrl:
                              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=600&fit=crop',
                          buttonText: context.tr('buy_now'),
                          onButtonPressed: () {},
                        ),
                        PromoItem(
                          text: context.tr('new_arrivals_promo'),
                          imageUrl:
                              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=600&fit=crop',
                          buttonText: context.tr('explore'),
                          onButtonPressed: () {},
                        ),
                      ],
                    ),
                    verticalspace(20.h),

                    verticalspace(20.h),

                    HeadText(
                      title: context.tr('shop_by_categories'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyAllCategories(),
                          ),
                        );
                      },
                    ),
                    verticalspace(10.h),
                    HomeCategories(
                      icons: [
                        Icons.computer,
                        Icons.home,
                        Icons.headphones,
                        Icons.watch,
                        MdiIcons.sofa,
                        MdiIcons.tshirtCrew,
                        MdiIcons.electricSwitch,
                        MdiIcons.shoeSneaker,
                        Icons.sports_esports,
                        Icons.camera_alt,
                        Icons.book,
                        Icons.toys,
                      ],
                      categoryNames: [
                        context.tr('computers'),
                        context.tr('home_garden'),
                        context.tr('audio'),
                        context.tr('watches'),
                        context.tr('furniture'),
                        context.tr('fashion'),
                        context.tr('electronics'),
                        context.tr('footwear'),
                        context.tr('gaming'),
                        context.tr('photography'),
                        context.tr('books'),
                        context.tr('toys'),
                      ],
                      onCategoryTap: (categoryName, index) {
                        _navigateToProducts(categoryName, index + 1);
                      },
                    ),
                    verticalspace(25.h),

                    verticalspace(20.h),

                    // Top Rated Products
                    HeadText(
                      title: context.tr('top_rated_products'),
                      showActionButton: false,
                    ),
                    verticalspace(10.h),
                    ShowProduct(
                      products: [
                        ProductItem(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productId: 1,
                                  productName: 'iPhone 15 Pro Max',
                                  price: 1200.0,
                                  mainImageUrl:
                                      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
                                  productImages: [
                                    'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=150&h=150&fit=crop',
                                    'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=150&h=150&fit=crop',
                                    'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=150&h=150&fit=crop',
                                    'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=150&h=150&fit=crop',
                                  ],
                                  availableSizes: ['40', '41', '42'],
                                  availableColors: [
                                    Colors.black,
                                    Colors.red,
                                    Colors.white,
                                  ],
                                ),
                              ),
                            );
                          },
                          imageUrl:
                              'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
                          title: 'iPhone 15 Pro Max',
                          price: '\$1200',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 1),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
                          title: 'Nike Air Jordan',
                          price: '\$150',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 2),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
                          title: 'Apple Watch Series 9',
                          price: '\$399',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 3),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
                          title: 'Sony WH-1000XM5',
                          price: '\$350',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 4),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
                          title: 'MacBook Pro M3',
                          price: '\$1999',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 5),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=500',
                          title: 'Premium Coffee Maker',
                          price: '\$179',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 6),
                            );
                          },
                        ),
                      ],
                    ),
                    verticalspace(25.h),

                    // New Arrivals Section
                    HeadText(
                      title: context.tr('new_arrivals'),
                      showActionButton: true,
                    ),
                    verticalspace(10.h),
                    ShowProduct(
                      products: [
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500',
                          title: 'Gaming Laptop MSI',
                          price: '\$1599',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 7),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=500',
                          title: 'Vintage Leather Bag',
                          price: '\$89',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 8),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=500',
                          title: 'Wireless Earbuds',
                          price: '\$129',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 9),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500',
                          title: 'Modern Office Chair',
                          price: '\$299',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 10),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=500',
                          title: 'Wireless Gaming Mouse',
                          price: '\$79',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 11),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500',
                          title: 'Smart Fitness Watch',
                          price: '\$249',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 12),
                            );
                          },
                        ),
                      ],
                    ),
                    verticalspace(25.h),
                    SalePage(
                      imageUrl1:
                          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&h=400&fit=crop',
                      title1: context.tr('up_to_50_off'),
                      subtitle1: context.tr('items_on_sale'),
                      onTap1: () {},
                      imageUrl2:
                          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=600&h=400&fit=crop',
                      title2: context.tr('exclusive_deals'),
                      subtitle2: context.tr('limited_time_offer'),
                      onTap2: () {},
                    ),

                    verticalspace(25.h),
                    PromoSection(
                      image1:
                          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=300&h=300&fit=crop',
                      image2:
                          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=300&h=300&fit=crop',
                      image3:
                          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=300&h=300&fit=crop',

                      title1: context.tr('electronics_sale'),
                      title2: context.tr('new_arrival_bags'),
                      title3: context.tr('kids_toys_offer'),
                      text1: context.tr('save_up_to_40'),
                      text2: context.tr('trendy_stylish'),
                      text3: context.tr('fun_for_all_ages'),
                    ),

                    verticalspace(30.h),
                    HeadText(
                      title: context.tr('best_sellers'),
                      showActionButton: true,
                    ),
                    verticalspace(10.h),
                    ShowProduct(
                      products: [
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500',
                          title: 'Gaming Laptop MSI',
                          price: '\$1599',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 13),
                            );
                          },
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=500',
                          title: 'Vintage Leather Bag',
                          price: '\$89',
                          cartIcon: Icons.shopping_cart,
                          onCartPressed: () {},
                          onFavoritePressed: () {
                            context.read<WishlistBloc>().add(
                              AddToWishlist(productId: 14),
                            );
                          },
                        ),
                      ],
                    ),
                    verticalspace(30.h),
                    PromoSectionWhite(
                      image1:
                          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=300&h=300&fit=crop',
                      image2:
                          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=300&h=300&fit=crop',
                      image3:
                          'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=300&h=300&fit=crop',

                      title1: context.tr('electronics_sale'),
                      title2: context.tr('new_arrival_bags'),
                      title3: context.tr('kids_toys_offer'),
                      text1: context.tr('save_up_to_40'),
                      text2: context.tr('trendy_stylish'),
                      text3: context.tr('fun_for_all_ages'),
                    ),
                    verticalspace(36.h),
                    SalePage(
                      imageUrl1:
                          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&h=400&fit=crop',
                      title1: context.tr('up_to_50_off'),
                      subtitle1: context.tr('items_on_sale'),
                      onTap1: () {},
                      imageUrl2:
                          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=600&h=400&fit=crop',
                      title2: context.tr('exclusive_deals'),
                      subtitle2: context.tr('limited_time_offer'),
                      onTap2: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // // Quick Action Cards Widget
}
