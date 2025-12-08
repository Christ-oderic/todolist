import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class AppPadding {
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets card = EdgeInsets.all(12.0);
  static const EdgeInsets section = EdgeInsets.symmetric(vertical: 20.0);
}

class Gaps {
  static const Widget xs = SizedBox(height: 4, width: 4);
  static const Widget sm = SizedBox(height: 8, width: 8);
  static const Widget md = SizedBox(height: 16, width: 16);
  static const Widget lg = SizedBox(height: 24, width: 24);
  static const Widget xl = SizedBox(height: 32, width: 32);
}
