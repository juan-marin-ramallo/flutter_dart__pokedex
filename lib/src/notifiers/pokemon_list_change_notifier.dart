import 'package:flutter/material.dart';
import 'package:juan_marin_ramallo_flutter_01/src/providers/pokeapi_provider.dart';

class PokemonListChangeNotifier with ChangeNotifier{
  final _pokeApiProvider = PokeApiProvider();
  List<dynamic> _pokemonListFilter = <dynamic>[];

  //Using provider package
  List<dynamic> get pokemonListFilter => _pokemonListFilter;

  void searchPokemon(String nameFilter) async{
    List<dynamic> pokemonListComplete = await _pokeApiProvider.fetchPokemonList();

    final suggestionsPokemon = pokemonListComplete.where((pokemon) {
      final name = pokemon['name'].toString().toLowerCase();

      return name.contains(nameFilter.toLowerCase());
    }).toList();

    _pokemonListFilter  = suggestionsPokemon;

    notifyListeners();
  }
}