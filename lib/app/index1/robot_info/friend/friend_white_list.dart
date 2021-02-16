import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/friend/friend_white_list_add.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/friend/url_friend.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class FriendWhiteList extends StatefulWidget {
  String _title;
  var _pageparam;

  FriendWhiteList(this._title, this._pageparam);

  _FriendWhiteList createState() => _FriendWhiteList(this._title, this._pageparam);
}

class _FriendWhiteList extends State<FriendWhiteList> {
  String _title;
  var _pageparam;

  _FriendWhiteList(this._title, this._pageparam);

  @override
  void initState() {
    get_data(context, this._pageparam["bot"].toString());
    super.initState();
  }

  Future<void> get_data(BuildContext context, String bot) async {
    Map post = await AuthAction().LoginObject();
    post["bot"] = bot;

    String ret = await Net.Post(Config.Url, Url_friend.white_list, null, post, null);
    Map json = jsonDecode(ret);

    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          if (json["data"] != null) {
            _white_list = json["data"];
          } else {
            _white_list = [];
          }
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
              Windows.Open(context, FriendWhiteListAdd(this._title, this._pageparam));
            },
            child: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (context, index) {
            String username = "";
            var _data = _white_list[index];
            if (_data["user_info"] != null) {
              username = _data["user_info"]["nickname"].toString();
            } else {
              username = "该好友暂时还未添加你的机器人";
            }

            return Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: null,
                title: Text(username),
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
                        _white_list.removeAt(index);
                      });
                    }
                  },
                )
              ],
            );
          },
          itemCount: _white_list.length,
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

  String ret = await Net.Post(Config.Url, Url_friend.white_delete, null, post, null);
  Map json = jsonDecode(ret);
  if (Auth.Return_login_check(context, json)) {
    if (Ret.Check_isok(context, json)) {
      Alert.Confirm(context, json["echo"], json["echo"], () {});
      return true;
    }
  }
  return false;
}

List _white_list = [];
