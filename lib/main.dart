import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:juan_marin_ramallo_flutter_01/src/bloc/login_bloc.dart';
import 'package:juan_marin_ramallo_flutter_01/src/model/pokemon_model.dart';
import 'package:juan_marin_ramallo_flutter_01/src/pages/login_page.dart';
import 'package:juan_marin_ramallo_flutter_01/src/pages/home_page.dart';
import 'package:juan_marin_ramallo_flutter_01/src/pages/details_page.dart';
import 'package:juan_marin_ramallo_flutter_01/src/notifiers/pokemon_list_change_notifier.dart';
import 'package:juan_marin_ramallo_flutter_01/src/notifiers/pokemon_state_notifier.dart';
import 'package:juan_marin_ramallo_flutter_01/src/pages/register_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          Provider<LoginBloc>(
              create: (_) => LoginBloc(),
          ),
          StateNotifierProvider<PokemonStateNotifier, PokemonModel>(
            create: (_) => PokemonStateNotifier(),
          ),
          ChangeNotifierProvider<PokemonListChangeNotifier>(
            create: (_) => PokemonListChangeNotifier(),
          )
        ],
        child: const PokeDex(),
      ),
    );
}

class PokeDex extends StatelessWidget {
  const PokeDex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PokeDex App',
        initialRoute: 'login',
        routes: <String, WidgetBuilder>{
          'login'   :   (BuildContext context) => LoginPage(),
          'home'    :   (BuildContext context) => const HomePage(),
          'details' :   (BuildContext context) => const DetailsPage(),
          'register':   (BuildContext context) => RegisterPage(),
        },
    );
  }
}

