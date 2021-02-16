import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tuuz_Popup {
  static MenuItem(IconData icon, String text, String value) {
    return new PopupMenuItem<String>(
      value: value,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Icon(icon, color: Colors.blue),
          new Text(text),
        ],
      ),
    );
  }
}
