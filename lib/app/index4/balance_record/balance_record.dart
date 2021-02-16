import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index4/balance_record/url_balance_record.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';

class Balance_record extends StatefulWidget {
  String _title;

  Balance_record(this._title);

  @override
  _Balance_record createState() => _Balance_record(this._title);
}

class _Balance_record extends State<Balance_record> {
  String _title;

  _Balance_record(this._title);

  @override
  void initState() {
    get_balance_record();
    super.initState();
  }

  @override
  Future<void> get_balance_record() async {
    Map<String, String> post = await AuthAction().LoginObject();
    var ret = await Net.Post(Config.Url, Url_balance_record.User_balance_record, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (json["code"] == 0) {
        _balance_record = json["data"];
        setState(() {});
        print(_balance_record);
      } else {
        Alert.Error(context, json["data"], () {});
      }
    }
  }

  List _balance_record = [];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this._title),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: EasyRefresh(
          child: ListView.builder(
            itemBuilder: (BuildContext con, int index) => BotItem(this.context, _balance_record[index]),
            itemCount: _balance_record.length,
          ),
          firstRefresh: false,
          onRefresh: get_balance_record,
        ));
  }
}

class BotItem extends StatelessWidget {
  var item;
  var _context;

  BotItem(this._context, this.item);

  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.wallet_giftcard),
      ),
      title: FlatButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "资金变动：" + ret["amount"].toString(),
              style: Config.Text_Style_default,
            ),
            Text(
              ret["remark"].toString(),
              style: Config.Text_Style_default,
            )
          ],
        ),
        onPressed: () {
          //Todo：短按进入机器人信息
          // Windows.Open(this._context, Robot_info_index(this.item));
        },
        onLongPress: () {
          //Todo：长按弹出菜单
        },
      ),
      trailing: Text(
        ret["date"].toString(),
        style: Config.Text_Style_default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(item);
  }
}
