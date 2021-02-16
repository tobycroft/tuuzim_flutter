import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/white/bot_white_list_add.dart';
import 'package:tuuzim_flutter/app/index1/robot_info/white/url_white.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class BotWhiteList extends StatefulWidget {
  String _title;
  var _pageparam;

  BotWhiteList(this._title, this._pageparam);

  _BotWhiteList createState() => _BotWhiteList(this._title, this._pageparam);
}

class _BotWhiteList extends State<BotWhiteList> {
  String _title;
  var _pageparam;

  _BotWhiteList(this._title, this._pageparam);

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

    String ret = await Net.Post(Config.Url, Url_white.white_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        _white_group = json["data"];
        setState(() {
          _white_group = json["data"];
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
              Windows.Open(context, Bot_white_list_add(this._title, this._pageparam));
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
            String groupname = "";
            var _data = _white_group[index];
            if (_data["group_info"] != null) {
              groupname = _data["group_info"]["group_name"].toString();
            } else {
              groupname = "暂时还未拉入这个群";
            }

            return new Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: null,
                title: Text(groupname),
                subtitle: Text(_data["gid"].toString()),
                trailing: null,
                onTap: () async {},
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete_forever,
                  onTap: () async {
                    bool ret = await delete_data(context, _data["bot"].toString(), _data["gid"].toString());
                    if (ret) {
                      setState(() {
                        _white_group.removeAt(index);
                      });
                    }
                  },
                )
              ],
            );
          },
          itemCount: _white_group.length,
        ),
        onRefresh: () async {
          get_data(context, this._pageparam["bot"].toString());
        },
      ),
    );
  }
}

Future<bool> delete_data(BuildContext context, String bot, gid) async {
  Map post = await AuthAction().LoginObject();
  post["bot"] = bot;
  post["gid"] = gid;

  String ret = await Net.Post(Config.Url, Url_white.white_delete, null, post, null);
  Map json = jsonDecode(ret);
  if (Auth.Return_login_check(context, json)) {
    if (Ret.Check_isok(context, json)) {
      Alert.Confirm(context, json["echo"], json["echo"], () {});
      return true;
    }
  }
  return false;
}

List _white_group = [];
