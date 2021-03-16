import 'dart:ui';

import 'package:flutter/material.dart';

class Style {
  static Color LightGrey = Color.fromRGBO(238, 238, 238, 1);
  static Color Lightwhite = Color.fromRGBO(255, 255, 255, 0.05);

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color Listtile_color(BuildContext context) {
    if (isDarkMode(context)) {
      return Lightwhite;
    } else {
      return Colors.white;
    }
  }

  static Color Chat_on_left(BuildContext context) {
    if (isDarkMode(context)) {
      return Lightwhite;
    } else {
      return Colors.white;
    }
  }

  static Color Chat_on_right(BuildContext context) {
    if (isDarkMode(context)) {
      return Lightwhite;
    } else {
      return Colors.lightGreenAccent;
    }
  }
}
