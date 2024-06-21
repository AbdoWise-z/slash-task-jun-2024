import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

/// a utility function to read an asset file as text
Future<String> loadAsset(String name) async {
  return await rootBundle.loadString(name);
}