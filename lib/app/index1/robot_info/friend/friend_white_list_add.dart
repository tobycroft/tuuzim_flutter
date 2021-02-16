import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/friend/url_friend.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_button.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class FriendWhiteListAdd extends StatefulWidget {
  String _title;
  var _pageparam;

  FriendWhiteListAdd(this._title, this._pageparam);

  _FriendWhiteListAdd createState() => _FriendWhiteListAdd(this._title, this._pageparam);
}

class _FriendWhiteListAdd extends State<FriendWhiteListAdd> {
  String _title;
  var _pageparam;

  _FriendWhiteListAdd(this._title, this._pageparam);

  String qq;
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
            child: Text("这里填写机器人可以被添加的好友"),
          ),
          Container(
            child: Text("如果不填写，机器人将无法拉入这个群"),
          ),
          Container(
            child: Text("机器人会定期退群，机器人将会自动退出未加入白名单的群"),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headline4,
            decoration: Config.Inputdecoration_default_input_box(Icons.account_circle, "输入可以被添加的QQ号码", this._qq, "请输入数字"),
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
            height: 50,
          ),
          UI_button.Button_submit(context, () async {
            Map post = await AuthAction().LoginObject();
            post["qq"] = this.qq.toString();
            post["bot"] = this._pageparam["bot"].toString();
            String ret = await Net.Post(Config.Url, Url_friend.white_add, null, post, null);
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
