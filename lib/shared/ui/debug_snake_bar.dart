import 'package:flutter/material.dart';

void showSnakeBar(BuildContext context, String message , {
  Duration duration = const Duration(milliseconds: 300)
}){
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}