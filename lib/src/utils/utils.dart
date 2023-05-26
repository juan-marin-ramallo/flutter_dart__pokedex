import 'package:flutter/material.dart';

bool isNumeric(String str){
  if(str.isEmpty) return false;

  final n = num.tryParse(str);

  return n == null ? false : true;
}

void showMyAlert(BuildContext context, String message){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert Message!'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
  );
}