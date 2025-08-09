import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/features/onboarding/ui/build_page_indicator.dart';
import 'package:flutter_shamstore/features/sign_up/sign_up_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              verticalspace(50.h),

              SvgPicture.asset(
                'assets/svgs/Onboarding 1 Illustration.svg',
                height: 250,
                width: 250,
              ),

              verticalspace(55.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Shop All ', style: TextStyle(color: ColorsManager.mainBlue)),
                    TextSpan(text: 'You Need', style: TextStyle(color: ColorsManager.mainOrange)),
                  ],
                ),
              ),

              verticalspace(20.h),

              Text(
                'Browse groceries, essentials, and more — all in\n one place.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorsManager.mainBlack, fontSize: 16, height: 1.5),
              ),

              const Spacer(flex: 3),

              Row(
                children: [
                  const Spacer(),
                  buildPageIndicator(0),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OnBoarding2()),
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              verticalspace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              verticalspace(55.h),

              SvgPicture.asset(
                'assets/svgs/Onboarding 2 Illustration.svg',
                height: 250,
                width: 250,
              ),

              verticalspace(60.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Big Deals, ', style: TextStyle(color: ColorsManager.mainBlue)),
                    TextSpan(text: 'Small Prices', style: TextStyle(color: ColorsManager.mainOrange)),
                  ],
                ),
              ),

              verticalspace(20.h),

              Text(
                'Save more every day with exclusive discounts\n and bundles.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorsManager.mainBlack, fontSize: 16, height: 1.5),
              ),

              const Spacer(flex: 3),

              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OnBoarding1()),
                      );
                    },
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        color: ColorsManager.mainBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  buildPageIndicator(1),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OnBoarding3()),
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              verticalspace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              SvgPicture.asset(
                'assets/svgs/Onboarding 3 Illustration.svg',
                height: 250,
                width: 250,
              ),

              const SizedBox(height: 40),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Fast & Easy ', style: TextStyle(color: ColorsManager.mainBlue)),
                    TextSpan(text: 'Delivery', style: TextStyle(color: ColorsManager.mainOrange)),
                  ],
                ),
              ),

              verticalspace(16.h),

              Text(
                'Your orders delivered quickly, safely, and on\n time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorsManager.mainBlack, fontSize: 16, height: 1.5),
              ),

              const Spacer(flex: 3),

              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OnBoarding2()),
                      );
                    },
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        color: ColorsManager.mainBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  buildPageIndicator(2),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: ColorsManager.mainBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              verticalspace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
