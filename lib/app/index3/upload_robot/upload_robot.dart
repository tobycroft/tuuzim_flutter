import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index3/upload_robot/upload_list.dart';
import 'package:tuuzim_flutter/app/index3/upload_robot/url_upload_robot.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_button.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Upload_robot extends StatefulWidget {
  String _title;

  Upload_robot(this._title);

  _Upload_robot createState() => _Upload_robot(this._title);
}

class _Upload_robot extends State<Upload_robot> {
  String _title;

  _Upload_robot(this._title);

  String qq;
  bool _qq = false;
  String password;
  String secret;
  double month = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
        actions: [
          FlatButton(
              onPressed: () async {
                Windows.Open(context, Upload_list("机器人提交记录"));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "提交记录",
                    style: Config.Text_style_title.copyWith(
                      fontSize: 17,
                    ),
                  ),
                  Icon(
                    Icons.format_list_bulleted,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              )),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        children: [
          Container(
            child: Text("可以自助提交机器人，提交后请在开发群542749156中联系管理告知"),
          ),
          Container(
            child: Text("每个用于允许一次性提交3个机器人，如果需要更大量，请联系管理"),
          ),
          Container(
            child: Text("如果需要清除提交记录，请联系管理员"),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入机器人的QQ号码", this._qq, "请输入数字"),
            onChanged: (String val) {
              setState(() {
                if (int.tryParse(val) == null) {
                  this._qq = true;
                } else {
                  this._qq = false;
                }
              });
              this.qq = val.toString();
            },
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.security, "输入机器人QQ密码", false, "请输入数字"),
            onChanged: (String val) {
              this.password = val.toString();
            },
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            child: Text("你可以设定一个密钥，用于后期使用acfur绑定功能"),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.security_outlined, "设定绑定密钥", false, ""),
            onChanged: (String val) {
              this.secret = val.toString();
            },
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "预定时长:${month.round()}个月",
            style: Config.Text_style_main_page,
          ),
          SizedBox(
            height: 40,
          ),
          Slider(
            min: 1,
            max: 12,
            divisions: 11,
            label: '${month.round()}个月',
            value: month,
            onChanged: (double val) {
              setState(() {
                month = val;
                // month = double.parse(val.round().toString());
                // print(month);
              });
            },
          ),
          SizedBox(
            height: 80,
          ),
          UI_button.Button_submit(context, () async {
            Map post = await AuthAction().LoginObject();
            post["bot"] = this.qq.toString();
            post["password"] = this.password.toString();
            post["secret"] = this.secret.toString();
            post["month"] = month.round().toString();
            String ret = await Net.Post(Config.Url, Url_upload_robot.Upload_robot, null, post, null);
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
