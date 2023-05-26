import 'package:flutter/material.dart';

import 'package:juan_marin_ramallo_flutter_01/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{
  final _loginBloc  = LoginBloc();

  static Provider? _instanceProvider;

  factory Provider({required Key password, required Widget widget}){
    _instanceProvider ??= Provider._internal(password: password, widget: widget);

    return _instanceProvider!;
  }

  Provider._internal({Key? password, Widget? widget}) : super(key: password, child: widget!);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc? of (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<Provider>())?._loginBloc;
  }

}