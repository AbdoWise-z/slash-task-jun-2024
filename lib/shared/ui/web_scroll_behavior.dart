
import 'dart:ui';
import 'package:flutter/material.dart';

/// a [MaterialScrollBehavior] to enable mouse scrolling for flutter wep
class WebScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}