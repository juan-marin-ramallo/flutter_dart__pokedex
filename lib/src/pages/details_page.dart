import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:juan_marin_ramallo_flutter_01/src/model/pokemon_model.dart';
import 'package:juan_marin_ramallo_flutter_01/src/utils/utils.dart' as utils;
import 'package:juan_marin_ramallo_flutter_01/src/notifiers/pokemon_state_notifier.dart';


class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _detailsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder(
      stateNotifier: pokemonStateNotifier,
      builder: (BuildContext context, PokemonModel pokemon, Widget? child) {
        if (pokemon.name == "") {
          return const CircularProgressIndicator();
        }
        else {
          return Scaffold(
            appBar: AppBar(
                title: Text(pokemon.name.toUpperCase()),
                actions: <Widget> [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(pokemon.sprites?.frontDefault as String),
                      radius: 25.0,
                    ),
                  )
                ]
            ),
            body: OfflineBuilder(
              connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;

                if(connected){
                  return OrientationBuilder(builder: (context, orientation) {
                    return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _detailsFormKey,
                            child: orientation == Orientation.portrait
                                ? Column(
                                    children: _createDetails(pokemon, orientation),
                                  )
                                : Row(
                                    children: _createDetails(pokemon, orientation),
                                  )
                        )
                      );
                    }
                  );
                }
                else{
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        height: 24.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          color: connected ? Colors.green : Colors.red,
                          child: Center(
                            child: Text(connected ? 'ONLINE' : 'OFFLINE'),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'There is no information to show!. Please connect to internet',
                        ),
                      ),
                    ],
                  );
                }
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
            floatingActionButton: FloatingActionButton(
              onPressed: _submit,
              child: const Icon(Icons.save),
            ),
          );
        }
      }
    );
  }

  void _submit(){
    if(!_detailsFormKey.currentState!.validate()) return;

    _detailsFormKey.currentState?.save();

    const snackBar = SnackBar(
        content: Text("Save simulated after form validation!"),
        duration: Duration(milliseconds: 2500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<Widget> _createDetails(PokemonModel pokemon, Orientation orientation){
    return <Widget>[
      _createCardImage(pokemon, orientation),
      Expanded(
        child: GridView.count(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
              padding: const EdgeInsets.only(left: 10, right: 10),
              children: [
                _createIsDefault(pokemon),
                _createTextFormType(pokemon),
                _createTextFormHeight(pokemon),
                _createTextFormWeight(pokemon),
              ] + _createPokemonStats(pokemon),
          ),
      )
    ];
  }

  Widget _createCardImage(PokemonModel pokemon, Orientation orientation){
    final heightScreen = MediaQuery.of(context).size.height;

    return Card(
        child: FadeInImage(
          image: NetworkImage(pokemon.sprites?.other?.home?.frontDefault as String),
          placeholder: const AssetImage("assets/loading.gif"),
          fadeInDuration: const Duration(milliseconds: 300),
          height: orientation == Orientation.portrait
              ? heightScreen * 0.45
              : heightScreen * 0.85,
          fit: BoxFit.fill,
        )
    );
  }

  Widget _createIsDefault(PokemonModel pokemon){
    return SwitchListTile(
        key: UniqueKey(),
        value: pokemon.isDefault,
        title: const Text("Default?"),
        activeColor: Colors.blue,
        onChanged: (value) => setState(() {
          pokemon.isDefault = value;
        })
    );
  }

  Widget _createTextFormType(PokemonModel pokemon){
    return TextFormField(
        key: UniqueKey(),
        initialValue: pokemon.types[0].type.name,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
            labelText: 'Type'
        ),
        onSaved: (value) => pokemon.types[0].type.name = value as String,
        validator: (value) {
          if (value!.length < 3) {
            return "Type too short";
          }
        }
    );
  }

  Widget _createTextFormHeight(PokemonModel pokemon){
    return TextFormField(
        key: UniqueKey(),
        initialValue: pokemon.height.toString(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
            labelText: 'Height (feet)'
        ),
        onSaved: (value) => pokemon.height = int.parse(value.toString()),
        validator: (value) {
          if (utils.isNumeric(value.toString())) {
            return null;
          }
          else{
            return "Please enter number values";
          }
        }
    );
  }

  Widget _createTextFormWeight(PokemonModel pokemon){
    return TextFormField(
        key: UniqueKey(),
        initialValue: pokemon.weight.toString(),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
            labelText: 'Weight (Kgs)'
        ),
        onSaved: (value) => pokemon.weight = int.parse(value.toString()),
        validator: (value) {
          if (utils.isNumeric(value.toString())) {
            return null;
          }
          else{
            return "Please enter number values";
          }
        }
    );
  }

  List<Widget> _createPokemonStats(PokemonModel pokemon){
    List<TextFormField> listTextFormField = <TextFormField>[];

    for (var stat in pokemon.stats) {
        final textFormField = TextFormField(
          key: UniqueKey(),
          initialValue: stat.baseStat.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
              labelText: stat.stat.name.toString()
          ),
          onSaved: (value) => stat.baseStat = int.parse(value.toString()),
          validator: (value) {
            if (utils.isNumeric(value.toString())) {
              return null;
            }
            else{
              return "Please enter number values";
            }
          }
      );
      listTextFormField.add(textFormField);
    }

    return listTextFormField;
  }
}