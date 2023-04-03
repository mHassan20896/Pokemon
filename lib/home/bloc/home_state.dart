part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState(
      {this.pokemonApiState = const ApiState(),
      this.favPokemons = const [],
      this.isFav = const []});

  final ApiState<List<Pokemon>> pokemonApiState;
  final List<Pokemon> favPokemons;
  final List<bool> isFav;

  @override
  List<Object> get props => [pokemonApiState, favPokemons, isFav];

  HomeState copyWith(
      {ApiState<List<Pokemon>>? pokemonApiState,
      List<Pokemon>? favPokemons,
      List<bool>? isFav}) {
    return HomeState(
      pokemonApiState: pokemonApiState ?? this.pokemonApiState,
      favPokemons: favPokemons ?? this.favPokemons,
      isFav: isFav ?? this.isFav,
    );
  }
}
