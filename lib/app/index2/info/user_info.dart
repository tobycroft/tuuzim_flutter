import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/chat/chat_private.dart';
import 'package:tuuzim_flutter/app/index2/add_friend/add_friend.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class UserInfo extends StatefulWidget {
  String _title;
  var _pageparam;

  UserInfo(this._title, this._pageparam);

  _UserInfo createState() => _UserInfo(this._title, this._pageparam);
}

var _data = {};
bool _is_friend = false;

class _UserInfo extends State<UserInfo> {
  String _title;
  var _pageparam;
  var _fid;

  _UserInfo(this._title, this._pageparam);

  Future<void> get_data() async {
    Map post = await AuthAction.LoginObject();
    post["fid"] = this._fid;
    String ret = await Net.Post(Config.Url, Url_Index2.Friend_info, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _data = json["data"];
        });
      }
    }
  }

  Future<void> get_data2() async {
    Map post = await AuthAction.LoginObject();
    post["fid"] = this._fid;
    String ret = await Net.Post(Config.Url, Url_Index2.is_friend, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _is_friend = json["data"];
        });
      }
    }
  }

  @override
  void initState() {
    this._fid = (this._pageparam["fid"] != null ? this._pageparam["fid"].toString() : this._pageparam["uid"].toString());
    get_data();
    get_data2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            height: 150,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                    // color: Colors.white10,
                    ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 80,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CacheImage.network(this._pageparam["face"], 70, 70),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this._pageparam["uname"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        "昵称：" + (this._pageparam["nickname"] != null ? this._pageparam["nickname"] : this._pageparam["uname"]).toString(),
                        style: Config.Text_style_Name.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "TuIM ID：" + (this._pageparam["fid"] != null ? this._pageparam["fid"].toString() : this._pageparam["uid"].toString()),
                        style: Config.Text_style_Name.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            tileColor: Style.Listtile_color(context),
            leading: Text(
              "朋友圈",
              style: Config.Text_style_Name.copyWith(),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
            ),
            title: null,
            onTap: () {},
          ),
          SizedBox(
            height: 10,
          ),
          Offstage(
            offstage: !_is_friend,
            child: FlatButton(
              color: Style.Listtile_color(context),
              height: 60,
              onPressed: () async {
                var friend_info = await FriendInfo.friend_info(this._fid.toString());
                var user_info = await FriendInfo.friend_info(await Storage.Get("__uid__"));
                Windows.Open(context, ChatPrivate((friend_info["nickname"] != null ? friend_info["nickname"] : friend_info["uname"]).toString(), this._fid, friend_info, user_info));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.question_answer,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "发送消息",
                    style: Config.Text_style_Name.copyWith(),
                  )
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !_is_friend,
            child: FlatButton(
              color: Style.Listtile_color(context),
              height: 60,
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_call,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "实时语音",
                    style: Config.Text_style_Name.copyWith(),
                  )
                ],
              ),
            ),
          ),
          Offstage(
            offstage: _is_friend,
            child: FlatButton(
              color: Style.Listtile_color(context),
              height: 60,
              onPressed: () async {
                Windows.Open(context, AddFriend(this._fid, _data));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.plus_one,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "加好友",
                    style: Config.Text_style_Name.copyWith(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
