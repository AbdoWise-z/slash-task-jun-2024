import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String name) async {
  return await rootBundle.loadString(name);
}