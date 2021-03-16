import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Config {
  static double Font_Size = 24;
  static double Font_size_text = 16;

  static TextStyle Text_Style_default = TextStyle(
    fontSize: 16,
  );

  static TextStyle Text_style_notimportant_auto = TextStyle(
      // fontSize: 16,
      );

  static TextStyle Text_style_Name = TextStyle(
    fontSize: 16,
  );

  static TextStyle Text_style_title = TextStyle(
    fontSize: 20,
  );

  static TextStyle Text_style_main_page = TextStyle(
    fontSize: 24,
  );

  static TextStyle Text_style_input_box = TextStyle(
    fontSize: 22,
  );

  static TextStyle Text_button_default = TextStyle(
    fontSize: 24,
  );

  static ShapeBorder Shape_button_default = const RoundedRectangleBorder(
    side: BorderSide.none,
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
  );

  static InputDecoration Inputdecoration_default_input_box(IconData icon, String labelText, bool error, String errorText) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      prefixIcon: Icon(
        icon,
        size: 32,
      ),
      labelText: labelText,
      labelStyle: Text_style_input_box,
      errorText: error ? errorText : null,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );
  }

  static String ProxyURL = "http://10.0.0.100:9000";

  static bool Proxy_debug = true;

  // static String Url = "127.0.0.1";
  //
  // static bool Proxy_debug = false;
  static String Url = "chat.tuuz.cc:20000";

  static String WS = "ws://chat.tuuz.cc:20001";
}
