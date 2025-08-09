import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/favourites.dart';

class FavoriteState extends Equatable {
  final List<FavouritesItem> favorites;

  const FavoriteState({this.favorites = const []});

  FavoriteState copyWith({List<FavouritesItem>? favorites}) {
    return FavoriteState(favorites: favorites ?? this.favorites);
  }

  @override
  List<Object?> get props => [favorites];
}
