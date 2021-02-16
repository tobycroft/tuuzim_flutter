import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/bind_bot/url_bind_bot.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_button.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class BindBot extends StatefulWidget {
  String _title;
  var _pageparam;

  BindBot(this._title, this._pageparam);

  _BindBot createState() => _BindBot(this._title, this._pageparam);
}

class _BindBot extends State<BindBot> {
  String _title;
  var _pageparam;

  _BindBot(this._title, this._pageparam);

  String bot;
  bool _bot = false;
  String secret;

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
          Container(
            child: Text("这里填写机器人的Secret"),
          ),
          Container(
            child: Text("密钥一般来自机器人提交时填写的内容"),
          ),
          Container(
            child: Text("如果你是手动申请的机器人，请联系开发群：542749156，管理员获取"),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入机器人QQ", this._bot, "请输入数字"),
            onChanged: (String val) {
              setState(() {
                if (int.tryParse(val) == null) {
                  this._bot = true;
                } else {
                  this._bot = false;
                }
              });
              this.bot = val.toString();
            },
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入机器人的密钥", false, "请输入数字"),
            onChanged: (String val) {
              this.secret = val.toString();
            },
          ),
          SizedBox(
            height: 50,
          ),
          UI_button.Button_submit(context, () async {
            Map post = await AuthAction().LoginObject();
            post["bot"] = this.bot.toString();
            post["secret"] = this.secret.toString();
            String ret = await Net.Post(Config.Url, Url_bind_bot.bind_bot, null, post, null);
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
