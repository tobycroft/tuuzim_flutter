import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui.dart';

class UI_button extends UI {
  static RaisedButton Button_submit(BuildContext context, VoidCallback func) {
    return RaisedButton(
      padding: EdgeInsets.all(10),
      color: Colors.lightGreen,
      child: Text(
        "提交",
        style: Config.Text_button_default,
      ),
      onPressed: func,
      shape: Config.Shape_button_default,
    );
  }

  static RaisedButton Button_raised(BuildContext context, String text, VoidCallback func) {
    return RaisedButton(
      padding: EdgeInsets.all(10),
      color: Colors.lightGreen,
      child: Text(
        text,
        style: Config.Text_button_default,
      ),
      onPressed: func,
      shape: Config.Shape_button_default,
    );
  }
}
