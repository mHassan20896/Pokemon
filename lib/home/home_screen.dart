import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/constants.dart';
import 'package:pokemon_app/home/bloc/home_bloc.dart';
import 'package:pokemon_app/home/favorites_screen.dart';
import 'package:pokemon_app/login/signin_screen.dart';
import 'package:pokemon_app/network/api_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon'),
        actions: [
          TextButton(
              onPressed: () {
                final state = context.read<HomeBloc>().state;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Favorites(favorites: state.favPokemons)));
              },
              child: const Text(
                "Favorites",
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () async {
                SharedPreferences.getInstance().then((pref) {
                  pref.remove(LOGIN_KEY);
                  pref.remove(FAV_KEY);
                });

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong. Please try again.")));
          }
        },
        builder: (context, state) {
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.initial) {
            BlocProvider.of<HomeBloc>(context).add(const GetPokemonsEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(state.pokemonApiState.response![index].name),
                  leading: const Icon(Icons.abc),
                  trailing: IconButton(
                    onPressed: () {
                      if (!state.isFav[index]) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Added to favorites")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Removed from favorites")));
                      }
                      BlocProvider.of<HomeBloc>(context).add(AddToFavoriteEvent(
                          state.pokemonApiState.response![index]));
                    },
                    icon: state.isFav[index]
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                  )
                  // leading: Image.network(state.pokemonApiState.response![index].url)
                  );
            },
            itemCount: state.pokemonApiState.response!.length,
          );
        },
      ),
    );
  }
}
