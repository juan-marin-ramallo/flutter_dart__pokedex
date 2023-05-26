import 'dart:async';
import 'package:juan_marin_ramallo_flutter_01/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final userController = BehaviorSubject<String>();
  final passwordController = BehaviorSubject<String>();

  //Objects to insert data to StreamController
  Function(String) get sinkUser => userController.sink.add;
  Function(String) get sinkPassword => passwordController.sink.add;

  //Objects to retrieve data to StreamController
  Stream<String> get streamUser => userController.stream.transform(validateEmail);
  Stream<String> get streamPassword => passwordController.stream.transform(validatePassword);

  Stream<bool> get combineStream => Rx.combineLatest2(streamUser, streamPassword, (a, b) => true);

  //Get values from the Stream
  String get user => userController.value;
  String get password => passwordController.value;

  dispose(){
    userController?.close();
    passwordController?.close();
  }
}