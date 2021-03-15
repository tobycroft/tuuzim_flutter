import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index1/bind_bot/bind_bot.dart';
import 'package:tuuzim_flutter/app/index1/help/help.dart';
import 'package:tuuzim_flutter/app/index1/url_index1.dart';
import 'package:tuuzim_flutter/app/login/login.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
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
    eventhub.on("logined", (data) async {
      get_data();
    });
    eventhub.on("logout", (data) async {
      _data = [];
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
        setState(() {
          _data = json["data"];
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(this._title),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () async {},
              minWidth: 1,
              child: Icon(
                Icons.search_sharp,
                color: Colors.white,
              )),
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
        child: ListView.builder(
          itemBuilder: (BuildContext con, int index) => BotItem(this.context, _data[index]),
          itemCount: _data.length,
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
    return ListTile(
      // leading: CircleAvatar(
      //   child: Image(image: NetworkImage(ret["face"])),
      // ),
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(
        ret["fid"].toString(),
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
      onTap: () async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this.item);
  }
}
