import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserProvider{
  final String _firebaseAPIKey = 'AIzaSyChq4sOmj4wGw2jTqEq4FsF-BGUXjoRPEA';

  Future<Map<String, dynamic>> loginSignup(String email, String password, bool isSignUp) async{
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseAPIKey');

    if(isSignUp){
      url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseAPIKey');
    }

    final resp = await http.post(
        url,
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      prefs.setString('idToken', decodedResp['idToken']);
      return {'ok' : true, 'token' : decodedResp['idToken']};
    }
    else{
      return {'ok' : false, 'message' : decodedResp['error']['message']};
    }
  }
}