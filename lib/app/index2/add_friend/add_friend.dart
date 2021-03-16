import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/ui/ui_input.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class AddFriend extends StatefulWidget {
  var _fid;
  var _pageparam;

  AddFriend(this._fid, this._pageparam);

  _AddFriend createState() => _AddFriend(this._fid, this._pageparam);
}

class _AddFriend extends State<AddFriend> {
  var _pageparam;
  var _fid;
  var _comment;

  _AddFriend(this._fid, this._pageparam);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          FlatButton(
            minWidth: 50,
            color: Colors.green,
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              var post = await AuthAction.LoginObject();
              post["fid"] = this._fid.toString();
              post["comment"] = this._comment.toString();
              String ret = await Net.Post(Config.Url, Url_Index2.Add_friend, null, post, null);
              var json = jsonDecode(ret);
              if (Auth.Return_login_check_and_Goto(context, json)) {
                if (Ret.Check_isok(context, json)) {
                  Alert.Confirm(context, json["echo"].toString(), json["echo"].toString(), () {
                    Windows.Close(context);
                  });
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Text(
              "发送好友申请",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headline4,
              maxLines: 3,
              minLines: 3,
              decoration: Config.Inputdecoration_default_input_box(Icons.mail_outline, "输入好友申请内容", false, "请输入数字"),
              onChanged: (String val) {
                this._comment = val.toString();
              },
            ),
          ),
        ],
      ),
    );
  }
}
