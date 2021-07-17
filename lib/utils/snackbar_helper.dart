import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content,
    {String label = "Ok", int duration = 5}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(
    SnackBar(
      content: Text(content),
      duration: Duration(seconds: duration),
      action:
      SnackBarAction(label: label, onPressed: messenger.hideCurrentSnackBar),
    ),
  );
}
