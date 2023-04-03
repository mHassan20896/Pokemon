part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetPokemonsEvent extends HomeEvent {
  const GetPokemonsEvent();

  @override
  List<Object> get props => [];
}

class AddToFavoriteEvent extends HomeEvent {
  const AddToFavoriteEvent(this.pokemon);

  final Pokemon pokemon;

  @override
  List<Object> get props => [pokemon];
}
