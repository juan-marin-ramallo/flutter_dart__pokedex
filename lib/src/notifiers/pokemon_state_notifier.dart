import 'package:dio/dio.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:juan_marin_ramallo_flutter_01/src/model/pokemon_model.dart';
import 'package:juan_marin_ramallo_flutter_01/src/providers/pokeapi_provider.dart';
import 'package:state_notifier/state_notifier.dart';

class PokemonStateNotifier extends StateNotifier<PokemonModel> {
  PokemonStateNotifier() : super(PokemonModel());

  final _pokeApiProvider = PokeApiProvider();

  //Using flutter_state_notifier package
  void getPokemonInfo(String pokeApiUrl, bool connectedInternet) async{
    PokemonModel pokemon;

    if(connectedInternet){
      pokemon = await _pokeApiProvider.fetchPokemonInfo(pokeApiUrl);
    }
    else{
      pokemon = PokemonModel();
      pokemon.name = "No connection to internet";
    }

    state = pokemon;
  }
}

final PokemonStateNotifier pokemonStateNotifier = PokemonStateNotifier();