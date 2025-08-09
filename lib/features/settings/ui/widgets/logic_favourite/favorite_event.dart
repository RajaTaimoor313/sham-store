import 'package:equatable/equatable.dart';
import 'package:flutter_shamstore/features/settings/ui/widgets/favourites.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class AddToFavorites extends FavoriteEvent {
  final FavouritesItem item;

  const AddToFavorites(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromFavorites extends FavoriteEvent {
  final FavouritesItem item;

  const RemoveFromFavorites(this.item);

  @override
  List<Object?> get props => [item];
}
