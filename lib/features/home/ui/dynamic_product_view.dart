import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/home/logic/home_carousel_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';

// Model class for promo items
class PromoItem {
  final String text;
  final String imageUrl;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  PromoItem({
    required this.text,
    required this.imageUrl,
    this.buttonText = 'Shop Now',
    this.onButtonPressed,
  });
}

class DynamicProductView extends StatelessWidget {
  const DynamicProductView({
    super.key, 
    required this.promoData,
  });
  final List<PromoItem> promoData;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarouselCubit(),
      child: Padding(
        padding: EdgeInsets.all(5.sp),
        child: Column(
          children: [
            // New custom container with specified dimensions
            SizedBox(
              width: 408,
              height: 188,
              child: Column(
                children: [
                  // Carousel for multiple promo items
                  SizedBox(
                    width: 408,
                    height: 150,
                    child: Builder(
                      builder: (builderContext) => CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          onPageChanged: (index, _) =>
                              builderContext.read<CarouselCubit>().updateIndex(index),
                        ),
                        items: promoData
                            .map((promoItem) => PromoCard(promoItem: promoItem))
                            .toList(),
                      ),
                    ),
                  ),
                  verticalspace(8),
                  BlocBuilder<CarouselCubit, int>(
                    builder: (context, state) {
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            promoData.length,
                            (i) => DynamicPproductCircular(
                              width: 10.w,
                              height: 5.h,
                              margin: const EdgeInsets.only(right: 10),
                              backgroundColor: state == i
                                  ? const Color.fromARGB(255, 65, 97, 161)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Promo Card Widget
class PromoCard extends StatelessWidget {
  final PromoItem promoItem;

  const PromoCard({super.key, required this.promoItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 408,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background row with two colors
          Row(
            children: [
              // Left container
              Expanded(
                flex: 4,
                child: Container(
                  height: 150,
                  color: ColorsManager.mainBlue,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text at the top
                      Text(
                        promoItem.text,
                        style: TextStyle(
                          color: ColorsManager.mainWhite,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Shop Now button at the bottom
                      ElevatedButton(
                        onPressed: promoItem.onButtonPressed ?? () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.mainOrange,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          promoItem.buttonText,
                          style: TextStyle(
                            color: ColorsManager.mainWhite,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right container
              Expanded(
                flex: 1,
                child: Container(
                  height: 150,
                  color: ColorsManager.mainOrange,
                ),
              ),
            ],
          ),
          // Image positioned at the border between colors
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              bool isArabicMode = languageState is LanguageLoaded && languageState.languageCode == 'ar';
              return Positioned(
                right: isArabicMode ? null : 43,
                left: isArabicMode ? 43 : null,
                top: 20,
            child: Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  promoItem.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 40,
                        color: Colors.grey[600]?.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
            },
          ),
        ],
      ),
    );
  }
}

class DynamicProductImage extends StatelessWidget {
  const DynamicProductImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = ColorsManager.lightBlue,
    this.fit,
    this.padding,
    this.isNetworking = true,
    this.onPressed,
    this.borderRadius = 15,
  });
  
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworking;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: applyImageRadius
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.zero,
            child: Image(
              image: isNetworking
                  ? NetworkImage(imageUrl)
                  : AssetImage(imageUrl) as ImageProvider,
              fit: fit,
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicPproductCircular extends StatelessWidget {
  const DynamicPproductCircular({
    super.key,
    this.width = 500,
    this.height = 500,
    this.padding = 0,
    this.child,
    this.backgroundColor = Colors.white,
    this.margin,
    this.radius = 10,
  });
  
  final double? width, height;
  final double padding;
  final Widget? child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}