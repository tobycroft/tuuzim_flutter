import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/list/url_list.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_button.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class BotFriendListAdd extends StatefulWidget {
  String _title;
  var _pageparam;

  BotFriendListAdd(this._title, this._pageparam);

  _BotFriendListAdd createState() => _BotFriendListAdd(this._title, this._pageparam);
}

class _BotFriendListAdd extends State<BotFriendListAdd> {
  String _title;
  var _pageparam;

  _BotFriendListAdd(this._title, this._pageparam);

  String qq;
  String text;
  bool _qq = false;

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
            child: Text("这里填写机器人将要添加的QQ号码"),
          ),
          Container(
            child: Text("请不要过于频繁的使用本功能，否则有可能被TXBan号"),
          ),
          Container(
            child: Text("如果被Ban号，你将会被TX当成垃圾用户，后续将被限制添加好友"),
          ),
          Container(
            child: Text("请尽量使用白名单功能，并让对方添加机器人而不是让机器人主动加人，建议每天只添加1-2人"),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入可以添加机器人的QQ号", this._qq, "请输入数字"),
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
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "添加好友的验证问题", false, "请输入数字"),
            onChanged: (String val) {
              this.text = val.toString();
            },
          ),
          SizedBox(
            height: 50,
          ),
          UI_button.Button_submit(context, () async {
            Map post = await AuthAction().LoginObject();
            post["qq"] = this.qq.toString();
            post["text"] = this.text.toString();
            post["bot"] = this._pageparam["bot"].toString();
            String ret = await Net.Post(Config.Url, Url_List.friend_add, null, post, null);
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
