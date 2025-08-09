import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/routing/app_router.dart';
import 'package:flutter_shamstore/core/routing/routes.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';

class ShamStore extends StatefulWidget{
  final AppRouter appRouter;
  const ShamStore({super.key, required this.appRouter});

  @override
  State<ShamStore> createState() => _ShamStoreState();
}

class _ShamStoreState extends State<ShamStore> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return ScreenUtilInit(
          designSize: const Size(375, 812), // حجم التصميم الأصلي (مثلاً iPhone X)
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            title: "Sham Super Store",
            theme: ThemeData(
              primaryColor: ColorsManager.mainBlue,
              scaffoldBackgroundColor: Colors.white
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.onboarding1,
            onGenerateRoute: widget.appRouter.generateRoute,
            // Add locale and text direction support
            locale: languageState is LanguageLoaded ? languageState.locale : const Locale('en'),
            builder: (context, child) {
              final textDirection = languageState is LanguageLoaded 
                  ? languageState.textDirection 
                  : TextDirection.ltr;
              return Directionality(
                textDirection: textDirection,
                child: child!,
              );
            },
          ),
        );
      },
    );
  } 
}