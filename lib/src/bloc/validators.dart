import 'dart:async';

class Validators{
  final validatePassword = StreamTransformer<String,String>.fromHandlers(
      handleData: (password,sink){
        if(password != ""){
          if(password.length>=6) {
            sink.add(password);
          } else {
            sink.addError('Enter more than 6 characters');
          }
        }
      }
  );

  final validateEmail = StreamTransformer<String,String>.fromHandlers(
      handleData: (user,sink){
        String pattern = r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = RegExp(pattern);

        if  (regExp.hasMatch(user)) {
          sink.add(user);
        } else {
          sink.addError('User should be used with email format');
        }
      }
  );
}