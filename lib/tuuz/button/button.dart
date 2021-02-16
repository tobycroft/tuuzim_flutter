import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Tuuz_Button {
  @override
  static Closebutton() {
    return CloseButton();
  }

  static BackButton() {
    return BackButton();
  }

  static BackWithWord(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(right: 40),
      child: Text(
        "⇦ 返回",
        style: TextStyle(color: Colors.white, fontSize: 19),
        textAlign: TextAlign.start,
      ),
      onPressed: () {
        Windows.Close(context);
      },
    );
  }

  static CloseWithWord(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(right: 40),
      child: Text(
        "×关闭",
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
      onPressed: () {
        Windows.Close(context);
      },
    );
  }
}
