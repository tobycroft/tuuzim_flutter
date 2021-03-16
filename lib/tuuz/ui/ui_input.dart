import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui.dart';

class Ui_input extends UI {
  TextField InputBox(context) {
    return TextField(
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headline4,
      decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入机器人QQ", false, "请输入数字"),
      onChanged: (String val) {},
    );
  }
}
