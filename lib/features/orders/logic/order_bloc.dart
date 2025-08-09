import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/core/repositories/order_repository.dart';
import 'package:flutter_shamstore/core/models/order_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';

// Events
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final Order order;

  CreateOrder({required this.order});

  @override
  List<Object?> get props => [order];
}

class LoadUserOrders extends OrderEvent {
  final int page;
  final int limit;
  final String? status;

  LoadUserOrders({this.page = 1, this.limit = 10, this.status});

  @override
  List<Object?> get props => [page, limit, status];
}

class LoadOrderById extends OrderEvent {
  final String orderId;

  LoadOrderById({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;
  final String? notes;

  UpdateOrderStatus({required this.orderId, required this.status, this.notes});

  @override
  List<Object?> get props => [orderId, status, notes];
}

class CancelOrder extends OrderEvent {
  final String orderId;
  final String reason;

  CancelOrder({required this.orderId, required this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}

class TrackOrder extends OrderEvent {
  final String orderId;

  TrackOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class SearchOrders extends OrderEvent {
  final String query;
  final int page;
  final int limit;

  SearchOrders({required this.query, this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [query, page, limit];
}

class LoadOrderStatistics extends OrderEvent {}

class LoadMyOrders extends OrderEvent {}

class PlaceOrder extends OrderEvent {
  final int shippingAddressId;
  final int paymentMethodId;
  final String? notes;
  final String? coupon;

  PlaceOrder({
    required this.shippingAddressId,
    required this.paymentMethodId,
    this.notes,
    this.coupon,
  });

  @override
  List<Object?> get props => [
    shippingAddressId,
    paymentMethodId,
    notes,
    coupon,
  ];
}

// States
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderCreated extends OrderState {
  final Order order;

  OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderPlaced extends OrderState {
  final Order order;
  final String message;

  OrderPlaced({required this.order, required this.message});

  @override
  List<Object?> get props => [order, message];
}

class OrdersLoaded extends OrderState {
  final List<Order> orders;
  final bool hasMore;
  final int currentPage;

  OrdersLoaded({
    required this.orders,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [orders, hasMore, currentPage];
}

class OrderLoaded extends OrderState {
  final Order order;

  OrderLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderStatusUpdated extends OrderState {
  final Order order;
  final String message;

  OrderStatusUpdated({required this.order, required this.message});

  @override
  List<Object?> get props => [order, message];
}

class OrderCancelled extends OrderState {
  final Order order;
  final String message;

  OrderCancelled({required this.order, required this.message});

  @override
  List<Object?> get props => [order, message];
}

class OrderTracked extends OrderState {
  final Map<String, dynamic> trackingInfo;

  OrderTracked({required this.trackingInfo});

  @override
  List<Object?> get props => [trackingInfo];
}

class OrderStatisticsLoaded extends OrderState {
  final Map<String, dynamic> statistics;

  OrderStatisticsLoaded({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class MyOrdersLoaded extends OrderState {
  final List<Order> orders;

  MyOrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderSuccess extends OrderState {
  final String message;

  OrderSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({OrderRepository? orderRepository})
    : _orderRepository = orderRepository ?? sl<OrderRepository>(),
      super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadUserOrders>(_onLoadUserOrders);
    on<LoadOrderById>(_onLoadOrderById);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
    on<TrackOrder>(_onTrackOrder);
    on<SearchOrders>(_onSearchOrders);
    on<LoadOrderStatistics>(_onLoadOrderStatistics);
    on<LoadMyOrders>(_onLoadMyOrders);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.createOrder(
        shippingAddressId: event.order.shippingAddress ?? '',
        paymentMethodId: event.order.paymentMethod ?? '',
      );
      if (response.isSuccess && response.data != null) {
        emit(OrderCreated(order: response.data!));
      } else {
        emit(OrderError(message: response.message ?? 'Order creation failed'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      print(
        'Placing order with shipping_address_id: ${event.shippingAddressId}, payment_method_id: ${event.paymentMethodId}',
      );

      final response = await _orderRepository.placeOrder(
        shippingAddressId: event.shippingAddressId,
        paymentMethodId: event.paymentMethodId,
        notes: event.notes,
        coupon: event.coupon,
      );

      if (response.isSuccess && response.data != null) {
        print('Order placed successfully: ${response.data!.id}');
        emit(
          OrderPlaced(
            order: response.data!,
            message: 'Your order has been placed successfully.',
          ),
        );
      } else {
        print('Order placement failed: ${response.message}');
        emit(OrderError(message: response.message ?? 'Order placement failed'));
      }
    } catch (e) {
      print('Order placement error: ${e.toString()}');
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.getUserOrders(
        page: event.page,
        limit: event.limit,
        status: event.status,
      );
      if (response.isSuccess && response.data != null) {
        final paginatedData = response.data!;
        emit(
          OrdersLoaded(
            orders: paginatedData.data,
            hasMore: paginatedData.data.length == event.limit,
            currentPage: event.page,
          ),
        );
      } else {
        emit(OrderError(message: response.message ?? 'Failed to load orders'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.getOrderById(event.orderId);
      if (response.isSuccess && response.data != null) {
        emit(OrderLoaded(order: response.data!));
      } else {
        emit(OrderError(message: response.message ?? 'Failed to load order'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.updateOrderStatus(
        orderId: event.orderId,
        status: event.status,
        notes: event.notes,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          OrderStatusUpdated(
            order: response.data!,
            message: 'Order status updated successfully',
          ),
        );
      } else {
        emit(
          OrderError(
            message: response.message ?? 'Failed to update order status',
          ),
        );
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.cancelOrder(
        orderId: event.orderId,
        reason: event.reason,
      );
      if (response.isSuccess && response.data != null) {
        emit(
          OrderCancelled(
            order: response.data!,
            message: 'Order cancelled successfully',
          ),
        );
      } else {
        emit(OrderError(message: response.message ?? 'Failed to cancel order'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.trackOrder(event.orderId);
      if (response.isSuccess && response.data != null) {
        emit(OrderTracked(trackingInfo: response.data!));
      } else {
        emit(OrderError(message: response.message ?? 'Failed to track order'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onSearchOrders(
    SearchOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.searchOrders(
        query: event.query,
        page: event.page,
        limit: event.limit,
      );
      if (response.isSuccess && response.data != null) {
        final paginatedData = response.data!;
        emit(
          OrdersLoaded(
            orders: paginatedData.data,
            hasMore: paginatedData.data.length == event.limit,
            currentPage: event.page,
          ),
        );
      } else {
        emit(
          OrderError(message: response.message ?? 'Failed to search orders'),
        );
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onLoadOrderStatistics(
    LoadOrderStatistics event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.getOrderStatistics();
      if (response.isSuccess && response.data != null) {
        emit(OrderStatisticsLoaded(statistics: response.data!));
      } else {
        emit(
          OrderError(
            message: response.message ?? 'Failed to load order statistics',
          ),
        );
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onLoadMyOrders(
    LoadMyOrders event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final response = await _orderRepository.getMyOrders();
      if (response.isSuccess && response.data != null) {
        emit(MyOrdersLoaded(orders: response.data!));
      } else {
        emit(
          OrderError(message: response.message ?? 'Failed to load my orders'),
        );
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
