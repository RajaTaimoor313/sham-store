import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/core/repositories/cart_repository.dart';
import 'package:flutter_shamstore/core/models/cart_model.dart';
import 'package:flutter_shamstore/core/di/service_locator.dart';

// Events
abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final int productId;

  AddToWishlist({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class RemoveFromWishlist extends WishlistEvent {
  final int productId;

  RemoveFromWishlist({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class CheckWishlistStatus extends WishlistEvent {
  final int productId;

  CheckWishlistStatus({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// States
abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;

  WishlistLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WishlistSuccess extends WishlistState {
  final String message;

  WishlistSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class WishlistStatusChecked extends WishlistState {
  final bool isInWishlist;
  final int productId;

  WishlistStatusChecked({required this.isInWishlist, required this.productId});

  @override
  List<Object?> get props => [isInWishlist, productId];
}

// BLoC
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final CartRepository _cartRepository;

  WishlistBloc({CartRepository? cartRepository})
    : _cartRepository = cartRepository ?? sl<CartRepository>(),
      super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<CheckWishlistStatus>(_onCheckWishlistStatus);
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    print('🔍 WishlistBloc: LoadWishlist event received');
    try {
      emit(WishlistLoading());
      print('🔍 WishlistBloc: Calling cartRepository.getWishlist()');
      final response = await _cartRepository.getWishlist();
      print(
        '🔍 WishlistBloc: getWishlist response - success: ${response.isSuccess}, data: ${response.data?.length} items',
      );
      if (response.isSuccess) {
        print(
          '🔍 WishlistBloc: Emitting WishlistLoaded with ${response.data!.length} items',
        );
        emit(WishlistLoaded(items: response.data!));
      } else {
        print(
          '🔍 WishlistBloc: Emitting WishlistError - ${response.getErrorMessage()}',
        );
        emit(WishlistError(message: response.getErrorMessage()));
      }
    } catch (e) {
      print('🔍 WishlistBloc: Exception caught - $e');
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());
      final addResponse = await _cartRepository.addToWishlist(event.productId);

      if (addResponse.isSuccess) {
        emit(
          WishlistSuccess(
            message: addResponse.data ?? 'Product added to wishlist',
          ),
        );

        // Reload wishlist
        final response = await _cartRepository.getWishlist();
        if (response.isSuccess) {
          emit(WishlistLoaded(items: response.data!));
        } else {
          emit(WishlistError(message: response.getErrorMessage()));
        }
      } else {
        emit(WishlistError(message: addResponse.getErrorMessage()));
      }
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());
      final removeResponse = await _cartRepository
          .removeFromWishlistByProductId(event.productId);

      if (removeResponse.isSuccess) {
        emit(
          WishlistSuccess(
            message: removeResponse.data ?? 'Product removed from wishlist',
          ),
        );

        // Reload wishlist
        final response = await _cartRepository.getWishlist();
        if (response.isSuccess) {
          emit(WishlistLoaded(items: response.data!));
        } else {
          emit(WishlistError(message: response.getErrorMessage()));
        }
      } else {
        emit(WishlistError(message: removeResponse.getErrorMessage()));
      }
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onCheckWishlistStatus(
    CheckWishlistStatus event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final isInWishlist = await _cartRepository.isInWishlist(event.productId);
      emit(
        WishlistStatusChecked(
          isInWishlist: isInWishlist,
          productId: event.productId,
        ),
      );
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }
}
