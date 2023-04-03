import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemon_app/constants.dart';
import 'package:pokemon_app/home/repository/model/pokemon.dart';
import 'package:pokemon_app/home/repository/pokemon_repository.dart';
import 'package:pokemon_app/network/api_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.pokemonRepository) : super(const HomeState()) {
    on<GetPokemonsEvent>(_getPokemons);
    on<AddToFavoriteEvent>(_addToFavorite);
  }

  final PokemonRepository pokemonRepository;

  Future<void> _getPokemons(
      GetPokemonsEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(
        pokemonApiState: const ApiState<List<Pokemon>>(
            apiResponseState: ApiResponseState.loading),
      ));

      final prefs = await SharedPreferences.getInstance();
      final favPokemons = prefs.getString(FAV_KEY);

      final pokemons = await pokemonRepository.getPokemons();

      List<Pokemon>? favPokemonsList;
      if (favPokemons != null) {
        favPokemonsList = jsonDecode(favPokemons)[FAV_KEY]
            .map<Pokemon>((pokemonJson) => Pokemon.fromJson(pokemonJson))
            .toList();
      }

      if (favPokemonsList != null) {
        emit(
          state.copyWith(
            isFav: pokemons.map((e) => favPokemonsList!.contains(e)).toList(),
            favPokemons: favPokemonsList,
            pokemonApiState: ApiState<List<Pokemon>>(
                response: pokemons, apiResponseState: ApiResponseState.success),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isFav: pokemons.map((e) => false).toList(),
          pokemonApiState: ApiState<List<Pokemon>>(
              response: pokemons, apiResponseState: ApiResponseState.success),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          pokemonApiState: const ApiState<List<Pokemon>>(
              apiResponseState: ApiResponseState.error),
        ),
      );
    }
  }

  Future<void> _addToFavorite(
      AddToFavoriteEvent event, Emitter<HomeState> emit) async {
    final pokemon = event.pokemon;

    var favPokemons = [...state.favPokemons];

    if (state.favPokemons.contains(pokemon)) {
      favPokemons.remove(pokemon);
    } else {
      favPokemons.add(pokemon);
    }

    final idx = state.pokemonApiState.response!.indexOf(pokemon);
    state.isFav[idx] = !state.isFav[idx];

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(FAV_KEY, jsonEncode({FAV_KEY: favPokemons}));

    emit(
      state.copyWith(
        isFav: state.isFav,
        favPokemons: favPokemons,
        pokemonApiState: ApiState<List<Pokemon>>(
          response: state.pokemonApiState.response,
          apiResponseState: state.pokemonApiState.apiResponseState,
        ),
      ),
    );
  }
}
