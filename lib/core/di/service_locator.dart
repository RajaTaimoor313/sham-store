import 'package:get_it/get_it.dart';
import '../api/api_service.dart';
import '../helpers/storage_helper.dart';
import '../repositories/auth_repository.dart';
import '../repositories/cart_repository.dart';
import '../repositories/order_repository.dart';
import '../repositories/payment_repository.dart';
import '../../features/categories/data/category_repository.dart';
import '../../features/categories/data/product_repository.dart';
import '../../features/auth/logic/auth_bloc.dart';
import '../../features/orders/logic/order_bloc.dart';

final GetIt sl = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Initialize storage helper first
    await StorageHelper.init();

    // Core services
    sl.registerLazySingleton<ApiService>(() => ApiService());
    sl.registerLazySingleton<StorageHelper>(() => StorageHelper.instance);

    // Repositories
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
    sl.registerLazySingleton<CartRepository>(() => CartRepository());
    sl.registerLazySingleton<OrderRepository>(() => OrderRepository());
    sl.registerLazySingleton<PaymentRepository>(() => PaymentRepository());
    sl.registerLazySingleton<CategoryRepository>(() => CategoryRepository());
    sl.registerLazySingleton<ProductRepository>(() => ProductRepository());

    // BLoCs
    sl.registerFactory<AuthBloc>(() => AuthBloc());
    sl.registerFactory<OrderBloc>(
      () => OrderBloc(orderRepository: sl<OrderRepository>()),
    );

    // Initialize auth state
    final authRepository = sl<AuthRepository>();
    await authRepository.initializeAuth();
  }

  static void reset() {
    sl.reset();
  }
}
