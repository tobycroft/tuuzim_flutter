import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/auto_reply_upload.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/url_group_setting.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class AutoReplyList extends StatefulWidget {
  String _title;
  var _pageparam;

  AutoReplyList(this._title, this._pageparam);

  _AutoReplyList createState() => _AutoReplyList(this._title, this._pageparam);
}

class _AutoReplyList extends State<AutoReplyList> {
  String _title;
  var _pageparam;

  _AutoReplyList(this._title, this._pageparam);

  @override
  void initState() {
    setState(() {
      get_data(context, this._pageparam["gid"].toString());
    });
    super.initState();
  }

  Future<void> get_data(BuildContext context, String gid) async {
    Map post = await AuthAction().LoginObject();
    post["gid"] = gid;

    String ret = await Net.Post(Config.Url, Url_group_setting.Group_Autoreply_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        _data_list = json["data"];
        setState(() {
          _data_list = json["data"];
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
              Windows.Open(context, AutoReplyUpload("新增自动回复", this._pageparam));
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
            var _data = _data_list[index];

            return new Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: null,
                title: Text("关键词：" + _data["key"].toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("回复：" + _data["value"].toString()),
                    Text("设定人：" + _data["uid"].toString()),
                  ],
                ),
                trailing: Column(
                  children: [
                    Text("添加日期"),
                    Text(_data["date"].toString()),
                  ],
                ),
                onTap: () async {},
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete_forever,
                  onTap: () async {
                    bool ret = await delete_data(context, _data["id"].toString(), _data["gid"].toString());
                    if (ret) {
                      setState(() {
                        _data_list.removeAt(index);
                      });
                    }
                  },
                )
              ],
            );
          },
          itemCount: _data_list.length,
        ),
        onRefresh: () async {
          get_data(context, this._pageparam["gid"].toString());
        },
      ),
    );
  }
}

Future<bool> delete_data(BuildContext context, String id, gid) async {
  Map post = await AuthAction().LoginObject();
  post["id"] = id;
  post["gid"] = gid;

  String ret = await Net.Post(Config.Url, Url_group_setting.Group_Autoreply_delete, null, post, null);
  Map json = jsonDecode(ret);
  if (Auth.Return_login_check(context, json)) {
    if (Ret.Check_isok(context, json)) {
      Alert.Confirm(context, json["echo"], json["echo"], () {});
      return true;
    }
  }
  return false;
}

List _data_list = [];
