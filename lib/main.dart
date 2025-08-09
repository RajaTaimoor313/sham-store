import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/core/routing/app_router.dart';
import 'package:flutter_shamstore/features/cart/logic/cart_bloc.dart';
import 'package:flutter_shamstore/core/localization/language_bloc.dart';
import 'package:flutter_shamstore/features/auth/logic/auth_bloc.dart';
import 'package:flutter_shamstore/features/wishlist/logic/wishlist_bloc.dart';
import 'package:flutter_shamstore/features/orders/logic/order_bloc.dart';
import 'package:flutter_shamstore/features/payment/logic/payment_bloc.dart';
import 'package:flutter_shamstore/features/categories/logic/category_cubit.dart';
import 'package:flutter_shamstore/features/categories/logic/product_cubit.dart';
import 'package:flutter_shamstore/features/notifications/logic/notification_bloc.dart';
import 'package:flutter_shamstore/core/repositories/notification_repository.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';
import 'package:flutter_shamstore/sham_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator and dependencies
  await ServiceLocator.init();

  runApp(
    MultiBlocProvider(
      providers: [
        // Core BLoCs
        BlocProvider(create: (_) => LanguageBloc()),
        BlocProvider(create: (_) => AuthBloc()),

        // Feature BLoCs
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(create: (_) => WishlistBloc()),
        BlocProvider(create: (_) => OrderBloc()),
        BlocProvider(create: (_) => PaymentBloc()),
        BlocProvider(create: (_) => CategoryCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(
          create: (_) => NotificationBloc(
            notificationRepository: NotificationRepository(),
          ),
        ),
      ],
      child: ShamStore(appRouter: AppRouter()),
    ),
  );
}
