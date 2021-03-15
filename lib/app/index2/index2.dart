import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index2/group/group_list.dart';
import 'package:tuuzim_flutter/app/index2/info/user_info.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/model/FriendModel.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index2 extends StatefulWidget {
  String _title;

  Index2(this._title);

  @override
  _Index2 createState() => _Index2(this._title);
}

class _Index2 extends State<Index2> {
  String _title;

  _Index2(this._title);

  @override
  void initState() {
    _load_database(context);
    eventhub.on("logined", (data) async {
      _load_database(context);
    });
    eventhub.on("logout", (data) async {
      _data = [];
    });
    // _friend_list(context);
    super.initState();
  }

  Future<void> _load_database(BuildContext context) async {
    List data = await FriendModel.Api_select();
    _data = data;
    _build_list();
    setState(() {});
  }

  Future<void> _friend_list(BuildContext context) async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.Friend_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        _data = [];
        setState(() {
          if (json["data"] != null) {
            _data = json["data"];
            _build_list();
            _data.forEach((element) async {
              if (await FriendModel.Api_find(element["fid"]) != null) {
                await FriendModel.Api_delete(element["fid"]);
              }
              await FriendModel.Api_insert(element["fid"], element["uname"], element["nickname"], element["face"], element["sex"], element["telephone"], element["remark"], element["mail"],
                  element["introduction"], element["destory"], element["destory_time"], element["can_pull"], element["can_notice"]);
            });
          }
        });
      }
    }
  }

  Future<void> _build_list() async {
    _widgets.clear();
    _data.forEach((element) {
      _widgets.add(_group_list_widget(this.context, element));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(this._title),
        backgroundColor: Colors.black,
        // If `TabController controller` is not provided, then a
        // DefaultTabController ancestor must be provided instead.
        // Another way is to use a self-defined controller, c.f. "Bottom tab
        // bar" example.
      ),
      body: EasyRefresh(
        child: ListView(
          children: <Widget>[
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 45,
                      height: 45,
                      color: Colors.orange,
                      child: Icon(
                        Icons.person_add,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
                  title: Text(
                    "新朋友",
                    style: Config.Text_Style_default.copyWith(color: Colors.white),
                  ),
                  onTap: () async {
                    Windows.Open(context, GroupList("群聊", null));
                  },
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 45,
                      height: 45,
                      color: Colors.green,
                      child: Icon(
                        Icons.group,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
                  title: Text(
                    "群聊",
                    style: Config.Text_Style_default.copyWith(color: Colors.white),
                  ),
                  onTap: () async {
                    Windows.Open(context, GroupList("群聊", null));
                  },
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                Divider(),
              ] +
              _widgets,
        ),
        onRefresh: () async {
          // _load_database(context);
          _friend_list(context);
        },
        firstRefresh: false,
      ),
    );
  }
}

List _data = [];
List<Widget> _widgets = [];

class _group_list_widget extends StatelessWidget {
  var _pageparam;
  BuildContext _context;

  _group_list_widget(this._context, this._pageparam);

  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          (ret["face"]),
          width: 45,
          height: 45,
          fit: BoxFit.cover,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
      title: Text(
        ret["uname"].toString(),
        style: Config.Text_Style_default.copyWith(color: Colors.white),
      ),
      onTap: () async {
        Windows.Open(this._context, UserInfo("", this._pageparam));
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}
