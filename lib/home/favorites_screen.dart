import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pokemon_app/home/repository/model/pokemon.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key, required this.favorites});

  final List<Pokemon> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
          return ListTile(
            title: Text(favorites[index].name),
            leading: const Icon(Icons.abc),
          );
        }));
  }
}
