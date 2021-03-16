import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tuuzim_flutter/app/index4/login_record/url_login_record.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class LoginRecordList extends StatefulWidget {
  String _title;
  var _pageparam;

  LoginRecordList(this._title, this._pageparam);

  _LoginRecordList createState() => _LoginRecordList(this._title, this._pageparam);
}

class _LoginRecordList extends State<LoginRecordList> {
  String _title;
  var _pageparam;

  _LoginRecordList(this._title, this._pageparam);

  @override
  void initState() {
    setState(() {
      get_data(context);
    });
    super.initState();
  }

  Future<void> get_data(BuildContext context) async {
    Map post = await AuthAction.LoginObject();

    String ret = await Net.Post(Config.Url, Url_login_record.Login_record, null, post, null);
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
            var _data = _data_list[index];

            return new Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              child: ListTile(
                leading: null,
                title: Text("" + _data["token"].toString()),
                subtitle: Text("登录IP：" + _data["ip"].toString()),
                trailing: Column(
                  children: [
                    Text("登录日期"),
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
                    bool ret = await delete_data(context, _data["id"].toString());
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
          get_data(context);
        },
      ),
    );
  }
}

Future<bool> delete_data(BuildContext context, String id) async {
  Map post = await AuthAction.LoginObject();
  post["id"] = id;

  String ret = await Net.Post(Config.Url, Url_login_record.Login_delete, null, post, null);
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
