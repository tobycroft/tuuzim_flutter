import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/app/index4/balance_record/balance_record.dart';
import 'package:tuuzim_flutter/app/index4/my_info/my_info.dart';
import 'package:tuuzim_flutter/app/index4/setting/app_setting.dart';
import 'package:tuuzim_flutter/app/index4/url_index4.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/extend/websocket/ws_message.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index4 extends StatefulWidget {
  String _title;

  Index4(this._title);

  @override
  _Index4 createState() => _Index4(this._title);
}

class _Index4 extends State<Index4> {
  String _title;

  _Index4(this._title);

  @override
  void initState() {
    get_user_info();
    eventhub.on(EventType.Login, (data) async {
      get_user_info();
    });
    eventhub.on(EventType.Logout, (data) async {
      _user_info = {
        "uname": "请先登录",
        "qq": "",
      };
    });
    super.initState();
  }

  @override
  Future<void> get_user_info() async {
    Map<String, String> post = await AuthAction.LoginObject();
    var ret = await Net.Post(Config.Url, Url_Index4.User_info, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (json["code"] == 0) {
        setState(() {
          _user_info = json["data"];
        });
      } else {
        Alert.Error(context, json["data"], () {});
      }
    } else {
      setState(() {
        _user_info = {
          "uname": "请先登录",
        };
      });
    }
  }

  Map _user_info = {
    "uname": "请先登录",
    "qq": "",
  };

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        shadowColor: Colors.black87,
        toolbarHeight: 0,
      ),
      body: ListView(
        children: [
          Container(
            height: 40,
          ),
          FlatButton(
            height: 140,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 80,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CacheImage.network(_user_info["face"], 70, 70),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user_info["uname"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "您的ID：" + _user_info["uid"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 50),
                  child: FlatButton(
                    minWidth: 1,
                    onPressed: () async {
                      print("123");
                    },
                    onLongPress: () async {
                      print("123");
                    },
                    child: Icon(
                      Icons.qr_code_outlined,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(left: 0, right: 0),
                  child: FlatButton(
                    // color: Colors.red,
                    minWidth: 1,
                    onPressed: () async {
                      print("2222");
                    },
                    onLongPress: () async {
                      Storage.Delete("__token__");
                      Alert.Confirm(context, "成功退出", "", () {});
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () async {
              Windows.Open(context, MyInfo("个人信息", this._user_info));
            },
          ),
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                ),
                title: Text(
                  "支付",
                ),
                onTap: () {
                  Windows.Open(context, Balance_record("积分记录"));
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.move_to_inbox,
                  color: Colors.red,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                ),
                title: Text(
                  "收藏",
                ),
                onTap: () {
                  Windows.Open(context, Balance_record("积分记录"));
                },
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.image,
                  color: Colors.blue,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                ),
                title: Text(
                  "我的设置",
                ),
                onTap: () {
                  Windows.Open(context, Balance_record("积分记录"));
                },
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.face,
                  color: Colors.yellow,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                ),
                title: Text(
                  "贴纸",
                ),
                onTap: () {
                  Windows.Open(context, Balance_record("积分记录"));
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                ),
                title: Text(
                  "设置",
                ),
                onTap: () {
                  Windows.Open(context, AppSetting("设置"));
                },
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.settings,
                  color: Colors.red,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.red,
                ),
                title: Text(
                  "Debug销毁数据库",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Database db = await TuuzDb().getDb();
                  deleteDatabase("tuuzim.db");
                  // var data = await FriendModel.Api_select();
                  // print(data);
                },
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.settings,
                  color: Colors.red,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.red,
                ),
                title: Text(
                  "数据库语句测试",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Database db = await TuuzDb().getDb();
                  var data = await db.rawQuery("SELECT * FROM groups");
                  // var data = await FriendModel.Api_select();
                  print(data);
                },
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.settings,
                  color: Colors.red,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.red,
                ),
                title: Text(
                  "ws连接",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  var login = await AuthAction.LoginObject();
                  var data = WsMessage.init(login["uid"], login["token"]);
                  eventhub.fire(EventType.Websocket_Send, data);
                },
              ),
              ListTile(
                tileColor: Style.Listtile_color(this.context),
                leading: Icon(
                  Icons.settings,
                  color: Colors.red,
                  size: 32,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.red,
                ),
                title: Text(
                  "升级测试",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  int id = await RUpgrade.upgrade(
                    'http://pandorabox.tuuz.cc:8000/app/tuuzim/app-release.apk',
                    fileName: 'app-release.apk',
                    isAutoRequestInstall: true,
                    notificationStyle: NotificationStyle.speechAndPlanTime,
                  );
                },
              ),
            ],
          ),
          Container(
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
