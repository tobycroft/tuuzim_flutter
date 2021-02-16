import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/friend/friend_white_list.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/list/bot_friend_list.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/list/bot_group_list.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/url_robot_info.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/white/bot_white_list.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/toasts/toast.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Robot_info_index extends StatefulWidget {
  var _page_param;

  Robot_info_index(this._page_param);

  @override
  State<StatefulWidget> createState() => _robot_info_index(this._page_param);
}

Map _robot_info = {"end_time": 0};

class _robot_info_index extends State<Robot_info_index> {
  var _page_param;

  _robot_info_index(this._page_param);

  @override
  void initState() {
    get_robot_info();
    super.initState();
  }

  Future<void> get_robot_info() async {
    Map post = await AuthAction().LoginObject();
    post["bot"] = this._page_param["bot"].toString();
    String ret = await Net.Post(Config.Url, Url_robot_info.Robot_info, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _robot_info = json["data"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("机器人设定"),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.zero,
            height: 150,
            // color: Colors.black,
            child: Stack(
              children: [
                Container(
                  color: Colors.green,
                  height: 100,
                ),
                Center(
                  child: ClipOval(
                    //圆形头像
                    child: Image.network(
                      this._page_param["img"].toString(),
                      width: 100,
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text(
                //       "123",
                //       style: TextStyle(color: Colors.white, fontSize: Config.Font_Size),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
          ListTile(
            leading: ClipOval(
              //圆形头像
              child: Image.network(
                _robot_info["img"].toString(),
                width: 40,
              ),
            ),
            title: Text("机器人账号"),
            subtitle: Text(
              _robot_info["bot"].toString(),
              style: Config.Text_style_notimportant_auto,
            ),
            onLongPress: () async {
              Toasts.Show("已经将账号复制到剪贴板");
              Clipboard.setData(
                ClipboardData(
                  text: _robot_info["bot"].toString(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.timer_off,
              size: 40,
            ),
            title: Text("机器人到期时间"),
            subtitle: Text(
              DateTime.fromMillisecondsSinceEpoch(double.parse((_robot_info["end_time"] * 1000).toString()).round()).toString(),
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Alert.Confirm(context, "title", "content", () {});
            },
          ),
          ListTile(
            leading: Icon(
              Icons.drive_file_rename_outline,
              size: 40,
            ),
            title: Text("修改机器人名称"),
            subtitle: Text(
              _robot_info["cname"].toString(),
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Alert.Confirm(context, "title", "content", () {});
            },
          ),
          ListTile(
            leading: Icon(
              Icons.format_list_bulleted,
              size: 40,
            ),
            title: Text(
              "机器人已经加入的群",
            ),
            subtitle: Text(
              "你可以在这里加群或者退群",
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Windows.Open(context, BotGroupList("已加入的群", this._page_param));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.playlist_add_check,
              size: 40,
            ),
            title: Text(
              "设定机器人白名单群",
            ),
            subtitle: Text(
              "机器人只能被邀请进入白名单中的群",
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Windows.Open(context, BotWhiteList("可加入的群", this._page_param));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
            ),
            title: Text(
              "机器人好友设定",
            ),
            subtitle: Text(
              "你可以在这里让机器人删除某个好友",
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Windows.Open(context, BotFriendList("机器人好友列表", this._page_param));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin,
              size: 40,
            ),
            title: Text(
              "好友白名单",
            ),
            subtitle: Text(
              "允许添加机器人的账号",
              style: Config.Text_style_notimportant_auto,
            ),
            trailing: Icon(Icons.chevron_right),
            // trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Windows.Open(context, FriendWhiteList("可被添加的白名单", this._page_param));
            },
          ),
        ],
      ),
    );
  }
}
