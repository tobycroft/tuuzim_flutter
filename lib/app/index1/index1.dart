import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/app/index1/bind_bot/bind_bot.dart';
import 'package:tuuzim_flutter/app/index1/chat/chat_private.dart';
import 'package:tuuzim_flutter/app/index1/help/help.dart';
import 'package:tuuzim_flutter/app/index1/url_index1.dart';
import 'package:tuuzim_flutter/app/index2/search/search_friend.dart';
import 'package:tuuzim_flutter/app/login/login.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/data/group/group_info.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/model/UserModel.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/calc/sort.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/popup/popupmenu.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index1 extends StatefulWidget {
  String _title;

  Index1(this._title);

  @override
  _Index1 createState() => _Index1(this._title);
}

List _data = [];

class _Index1 extends State<Index1> {
  String _title;

  _Index1(this._title);

  @override
  void initState() {
    get_data();
    eventhub.on(EventType.Websocket_refresh_list, (data) async {
      get_data();
    });
    eventhub.on(EventType.Login, (data) async {
      get_data();
    });
    eventhub.on(EventType.Logout, (data) async {
      _data = [];
      Database db = await TuuzDb().getDb();
      deleteDatabase("tuuzim.db");
    });
    super.initState();
  }

  @override
  Future<void> get_data() async {
    Map<String, String> post = {};
    post["uid"] = await Storage.Get("__uid__");
    post["token"] = await Storage.Get("__token__");
    var ret = await Net.Post(Config.Url, Url_Index1.Message_list, null, post, null);
    var json = jsonDecode(ret);
    if (Auth.Return_login_check_and_Goto(context, json)) {
      if (Ret.Check_isok(context, json)) {
        var _dat = json["data"];
        // print(_data);
        List _d1 = [];
        List _d2 = [];
        for (var i = 0; i < _dat.length; i++) {
          switch (_dat[i]["chat_type"].toString()) {
            case "private":
              _dat[i]["info"] = await FriendInfo.friend_info(_dat[i]["fid"]);
              if (_dat[i]["is_top"] == 1) {
                _d1.add(_dat[i]);
              } else {
                _d2.add(_dat[i]);
              }
              break;

            case "group":
              _dat[i]["info"] = await GroupInfo.get_info(_dat[i]["gid"]);
              if (_dat[i]["is_top"] == 1) {
                _d1.add(_dat[i]);
              } else {
                _d2.add(_dat[i]);
              }
              break;

            default:
              break;
          }
        }
        _d1 = Sort.sort(_d1, "date");
        _d2 = Sort.sort(_d2, "date");
        // _d1.sort((left, right) => right["date"].compareTo(left["date"]));
        // _d2.sort((left, right) => right["date"].compareTo(left["date"]));
        _data.clear();

        setState(() {
          _data = _d1;
          _data += _d2;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              Windows.Open(context, SearchFriend("搜索好友", null));
            },
            minWidth: 1,
            child: Icon(
              Icons.search_sharp,
              // color: Colors.white,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.add_circle_outline),
            offset: Offset(100, 100),
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              // Tuuz_Popup.MenuItem(Icons.login, "登录", "login"),
              Tuuz_Popup.MenuItem(Icons.add_box, "绑定机器人", "bind_bot"),
              Tuuz_Popup.MenuItem(Icons.help_center, "首页帮助", "index_help"),
              // Tuuz_Popup.MenuItem(Icons.qr_code, "扫码", "scanner"),
            ],
            onSelected: (String value) {
              print(value);
              switch (value) {
                case "login":
                  {
                    Windows.Open(context, Login());
                    break;
                  }
                case "logout":
                  {
                    Alert.Simple(context, "是否退出？", "点击确认后退出", () {
                      // Storage.Delete("__uid__");
                      Storage.Delete("__token__");
                    });
                    break;
                  }
                case "index_help":
                  {
                    Windows.Open(context, Index_Help());
                    break;
                  }

                case "bind_bot":
                  {
                    Windows.Open(context, BindBot("绑定一个机器人", null));
                    break;
                  }

                default:
                  {
                    Alert.Simple(context, "SS", value, () {});
                    break;
                  }
              }
            },
          ),
        ],
      ),
      body: EasyRefresh(
        scrollController: null,
        child: ListView.separated(
          itemBuilder: (BuildContext con, int index) => BotItem(this.context, _data[index]),
          itemCount: _data.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
        firstRefresh: false,
        onRefresh: get_data,
      ),
      //   Center(
      //     //     child: ListView.builder(
      //     //       itemBuilder: (BuildContext context, int index) => BotItem(bot_datas[index]),
      //     //       itemCount: bot_datas.length,
      //     //     ),
      //     //   ),
    );
  }
}

class BotItem extends StatelessWidget {
  var item;
  var _context;

  BotItem(this._context, this.item);

  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    var head_img;
    if (ret["info"] != null) {
      if (ret["info"]["face"] == null) {
        head_img = CacheImage.network(ret["info"]["img"], 60, 60);
      } else {
        head_img = CacheImage.network(ret["info"]["face"], 60, 60);
      }
    } else {
      head_img = CacheImage.network(null, 60, 60);
    }
    String uname = "";
    if (ret["info"] != null) {
      if (ret["info"]["uname"] != null) {
        uname = ret["info"]["uname"].toString();
      } else {
        uname = ret["info"]["group_name"].toString();
      }
    }
    return ListTile(
      tileColor: Style.Listtile_color(this._context),
      leading: CircleAvatar(
        child: head_img,
      ),
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        uname,
        style: Config.Text_Style_default,
      ),
      subtitle: Text(
        ret["message"].toString(),
        style: Config.Text_Style_default,
      ),
      trailing: Text(
        ret["date"].toString(),
        style: Config.Text_Style_default,
      ),
      onTap: () async {
        // print(ret);
        switch (ret["chat_type"]) {
          case "group":
            // Windows.Open(this._context, ChatPrivate(ret["uname"], ret));
            break;

          case "private":
            var friend_info = await FriendInfo.friend_info(ret["fid"].toString());
            var user_info = await FriendInfo.friend_info(await Storage.Get("__uid__"));
            Windows.Open(this._context, ChatPrivate((friend_info["nickname"] != null ? friend_info["nickname"] : friend_info["uname"]).toString(), ret["fid"].toString(), friend_info, user_info));
            break;

          default:
            {}
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(this.item);
    return _buildTiles(this.item);
  }
}
