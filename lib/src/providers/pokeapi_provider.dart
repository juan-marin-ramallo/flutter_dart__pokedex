import 'package:dio/dio.dart';
import 'package:juan_marin_ramallo_flutter_01/src/model/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PokeApiProvider {
  //Using dio package
  Future<List<dynamic>> fetchPokemonList() async {
    List<dynamic> pokemonList = <dynamic>[];

    final prefs = await SharedPreferences.getInstance();

    try{
      final dio = Dio();
      final response = await dio.get("https://pokeapi.co/api/v2/pokemon/?limit=1281");

      if (response.statusCode == 200){
        pokemonList = response.data["results"] as List;

        prefs.setString('pokemonList', json.encode(response.data["results"]));
      }
      else{
        pokemonList = json.decode(prefs.getString('pokemonList') as String) as List ?? <dynamic>[];
      }
    }
    catch(exception){
      pokemonList = json.decode(prefs.getString('pokemonList') as String) as List ?? <dynamic>[];

      return pokemonList;
    }

    return pokemonList;
  }

  Future<PokemonModel> fetchPokemonInfo(String pokeApiUrl) async{
    PokemonModel pokemon = PokemonModel();

    try{
      final dio = Dio();
      final response = await dio.get(pokeApiUrl);

      if (response.statusCode == 200){
        pokemon = PokemonModel.fromJson(response.data);
      }
    }
    catch(exception){
      rethrow;
    }

    return pokemon;
  }
}