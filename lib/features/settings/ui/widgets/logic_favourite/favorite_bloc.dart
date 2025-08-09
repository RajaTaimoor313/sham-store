import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/favourites.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(const FavoriteState(favorites: [])) {
    on<AddToFavorites>((event, emit) {
      if (!state.favorites.contains(event.item)) {
        final updated = List<FavouritesItem>.from(state.favorites)
          ..add(event.item);
        emit(state.copyWith(favorites: updated));
      }
    });

    on<RemoveFromFavorites>((event, emit) {
      final updated = List<FavouritesItem>.from(state.favorites)
        ..removeWhere((item) => item == event.item);
      emit(state.copyWith(favorites: updated));
    });
  }
}
