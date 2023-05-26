import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:juan_marin_ramallo_flutter_01/src/model/pokemon_model.dart';
import 'package:juan_marin_ramallo_flutter_01/src/notifiers/pokemon_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:juan_marin_ramallo_flutter_01/src/notifiers/pokemon_list_change_notifier.dart';

import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textFilterController = TextEditingController();
  //final _pokemonStateNotifier = PokemonStateNotifier();

  @override
  void initState(){
    super.initState();

    try {
      context.read<PokemonListChangeNotifier>().searchPokemon("");
    }
    catch(exception){
      showMyAlert(context,exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("PokeDex by Juan Marin Ramallo"),),
        body: OfflineBuilder(
          connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
            final bool connectedInternet = connectivity != ConnectivityResult.none;

            return Column(
                  children: <Widget> [
                    connectedInternet
                      ? Container()
                      : Container(
                          color: Colors.red,
                          child: const Center(
                            child: Text('OFFLINE'),
                          ),
                        ),
                    _createFilterPokeDex(),
                    _createListPokeDex(connectedInternet),
                ]
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'There are no buttons to push :)',
              ),
              Text(
                'Just turn off your internet.',
              ),
            ],
          ),
        ),
    );
  }

  Widget _createFilterPokeDex(){
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: TextField(
          controller: _textFilterController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Pokemon name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide:  const BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: context.read<PokemonListChangeNotifier>().searchPokemon,
        )
      );
  }

  Widget _createListPokeDex(bool connectedInternet){
    List<dynamic> pokemonListFilter = context.watch<PokemonListChangeNotifier>().pokemonListFilter;

    return Expanded(
        child: ListView.builder(
        itemCount: pokemonListFilter.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
              child: ListTile(
                title: Text(pokemonListFilter[index]['name'].toString().toUpperCase()),
                trailing: const Icon(Icons.arrow_right_outlined),
                onTap: () {
                  final urlPokemonApi = pokemonListFilter[index]['url'];
                  pokemonStateNotifier.getPokemonInfo(urlPokemonApi,connectedInternet);
                  Navigator.pushNamed(context, 'details');
                },
              )
          );
        }
        )
    );
  }
}