import 'package:flutter/material.dart';
import 'package:juan_marin_ramallo_flutter_01/src/bloc/login_bloc.dart';
import 'package:juan_marin_ramallo_flutter_01/src/providers/user_provider.dart';
import 'package:juan_marin_ramallo_flutter_01/src/utils/utils.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class RegisterPage extends StatelessWidget {
  final userProvider = UserProvider();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Register Page')
      ),
      body: Stack(
        children: <Widget> [
          createBackground(context),
          registerForm(context)
        ],
      ),
    );
  }

  Widget createBackground(BuildContext context){
    final size = MediaQuery.of(context).size;
    final background = Container(
      height: size.height * 0.4,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: <Color> [
                Color.fromRGBO(30, 120, 160, 1.0),
                Color.fromRGBO(50, 70, 150, 1.0),
              ]
          )
      ),
    );
    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white
      ),
    );
    return Stack(
      children: [
        background,
        Positioned(top: 90.0, left: 30, child: circle),
        Positioned(top: -40.0, right: -30, child: circle),
        Positioned(bottom: -50.0, right: -10, child: circle),
        Positioned(bottom: -120.0, left: 20, child: circle),
        Positioned(bottom: -50.0, left: -20, child: circle),
        Container(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            children: const <Widget> [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('PokeDex', style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }

  Widget registerForm(BuildContext context){
    final bloc = Provider.of<LoginBloc>(context);
    bloc.passwordController.sink.add("");
    final sizeScreen = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 190.0,)),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 30.0),
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              width: sizeScreen.width * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const <BoxShadow> [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 3.0
                    )
                  ]
              ),
              child: Column(
                children: [
                  const Text('Enter your information to signup please'),
                  const SizedBox(height: 10),
                  createEmail(bloc),
                  const SizedBox(height: 10),
                  createPassword(bloc),
                  const SizedBox(height: 15),
                  createRegisterButton(bloc),
                ],
              )
          ),
          ElevatedButton(
            child: const Text('Do you have an account?'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget createEmail(LoginBloc bloc){
    return StreamBuilder(
        stream: bloc.streamUser,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: const Icon(Icons.email, color: Colors.blue),
                    labelText: 'email',
                    hintText: 'example@mail.com',
                    counterText: "",
                    errorText: snapshot.hasError ? snapshot.error.toString() : null
                ),
                onChanged: bloc.sinkUser,
              )
          );
        }
    );
  }

  Widget createPassword(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.streamPassword,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Colors.blue),
                  labelText: 'Password',
                  counterText: snapshot.data,
                  errorText: snapshot.hasError ? snapshot.error.toString() : null
              ),
              onChanged: bloc.sinkPassword,
            )
        );
      },
    );
  }

  Widget createRegisterButton(LoginBloc bloc){
    return StreamBuilder(
        stream: bloc.combineStream,
        builder: (BuildContext context, AsyncSnapshot data){
          return ElevatedButton(
            onPressed: data.hasData ? () => register(context, bloc) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: const Text("Sign Up"),
            ),
          );
        }
    );
  }

  void register(BuildContext context, LoginBloc bloc) async {
    final Map infoRegister = await userProvider.loginSignup(bloc.user, bloc.password, true);

    if (context.mounted) {
      if(infoRegister['ok']){
        Navigator.pushReplacementNamed(context, 'home');
      }
      else{
        showMyAlert(context,infoRegister['message']);
      }
    }
  }
}