import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/list/bot_friend_list_add.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/list/url_list.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class BotFriendList extends StatefulWidget {
  String _title;
  var _pageparam;

  BotFriendList(this._title, this._pageparam);

  _BotFriendList createState() => _BotFriendList(this._title, this._pageparam);
}

class _BotFriendList extends State<BotFriendList> {
  String _title;
  var _pageparam;

  _BotFriendList(this._title, this._pageparam);

  @override
  void initState() {
    setState(() {
      get_data(context, this._pageparam["bot"].toString());
    });
    super.initState();
  }

  Future<void> get_data(BuildContext context, String bot) async {
    Map post = await AuthAction().LoginObject();
    post["bot"] = bot;

    String ret = await Net.Post(Config.Url, Url_List.friend_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _white_friend = json["data"];
        });
      }
    }
  }

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
              Windows.Open(context, BotFriendListAdd(this._title, this._pageparam));
            },
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (context, index) {
            var _data = _white_friend[index];

            return new Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: null,
                title: Text(_data["nickname"].toString()),
                subtitle: Text(_data["uid"].toString()),
                trailing: null,
                onTap: () async {},
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete_forever,
                  onTap: () async {
                    bool ret = await delete_data(context, _data["bot"].toString(), _data["uid"].toString());
                    if (ret) {
                      setState(() {
                        _white_friend.removeAt(index);
                      });
                    }
                  },
                )
              ],
            );
          },
          itemCount: _white_friend.length,
        ),
        onRefresh: () async {
          get_data(context, this._pageparam["bot"].toString());
        },
      ),
    );
  }
}

Future<bool> delete_data(BuildContext context, String bot, qq) async {
  Map post = await AuthAction().LoginObject();
  post["bot"] = bot;
  post["qq"] = qq;

  String ret = await Net.Post(Config.Url, Url_List.friend_delete, null, post, null);
  Map json = jsonDecode(ret);
  if (Auth.Return_login_check(context, json)) {
    if (Ret.Check_isok(context, json)) {
      Alert.Confirm(context, json["echo"], json["echo"], () {});
      return true;
    }
  }
  return false;
}

List _white_friend = [];
