import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/url_group_setting.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_button.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class AutoReplyUpload extends StatefulWidget {
  String _title;
  var _pageparam;

  AutoReplyUpload(this._title, this._pageparam);

  _AutoReplyUpload createState() => _AutoReplyUpload(this._title, this._pageparam);
}

class _AutoReplyUpload extends State<AutoReplyUpload> {
  String _title;
  var _pageparam;

  _AutoReplyUpload(this._title, this._pageparam);

  String key;
  String value;
  String type = "full";
  double percent = 50;
  int _radioVal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            maxLength: 64,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入触发词", false, "请输入数字"),
            onChanged: (String val) {
              this.key = val.toString();
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.headline4,
            maxLines: 3,
            maxLength: 500,
            decoration: Config.Inputdecoration_default_input_box(Icons.security, "输入触发后回复内容", false, "请输入数字"),
            onChanged: (String val) {
              this.value = val.toString();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "触发百分比:${percent.round()}%",
            style: Config.Text_style_main_page,
          ),
          SizedBox(
            height: 20,
          ),
          Slider(
            min: 1,
            max: 100,
            divisions: 99,
            label: '${percent.round()}个月',
            value: percent,
            onChanged: (double val) {
              setState(() {
                percent = val;
                // month = double.parse(val.round().toString());
                // print(month);
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "触发模式:",
            style: Config.Text_style_input_box,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("部分匹配模式"),
              Radio(
                value: "semi",
                groupValue: this.type,
                onChanged: (value) {
                  setState(() {
                    this.type = value;
                  });
                },
              ),
              SizedBox(width: 20),
              Text("完全匹配模式"),
              Radio(
                value: "full",
                groupValue: this.type,
                onChanged: (value) {
                  setState(() {
                    this.type = value;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          UI_button.Button_submit(context, () async {
            Map post = await AuthAction().LoginObject();
            post["gid"] = this._pageparam["gid"].toString();
            post["key"] = this.key.toString();
            post["value"] = this.value.toString();
            post["type"] = this.type.toString();
            post["percent"] = percent.round().toString();
            String ret = await Net.Post(Config.Url, Url_group_setting.Group_Autoreply_add, null, post, null);
            Map json = jsonDecode(ret);
            if (Auth.Return_login_check(context, json)) {
              if (Ret.Check_isok(context, json)) {
                Alert.Confirm(context, json["echo"], json["echo"], () {
                  Windows.Close(this.context);
                });
              }
            }
          }),
        ],
      ),
    );
  }
}
