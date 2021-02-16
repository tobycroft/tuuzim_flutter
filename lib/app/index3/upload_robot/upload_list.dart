import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index3/upload_robot/url_upload_robot.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';

class Upload_list extends StatefulWidget {
  String _title;

  Upload_list(this._title);

  _Upload_list createState() => _Upload_list(this._title);
}

class _Upload_list extends State<Upload_list> {
  String _title;

  _Upload_list(this._title);

  @override
  void initState() {
    get_bot_request();
    super.initState();
  }

  Future<void> get_bot_request() async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_upload_robot.Upload_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _bot_request = json["data"];
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
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (context, index) => _bot_request_widget(context, _bot_request[index]),
          itemCount: _bot_request.length,
        ),
        onRefresh: get_bot_request,
      ),
    );
  }
}

List _bot_request = [];

class _bot_request_widget extends StatelessWidget {
  BuildContext context;
  var item;

  _bot_request_widget(this.context, this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("机器人QQ:   " + item["bot"].toString()),
      subtitle: Text("QQ登录密码:" + item["password"].toString()),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("提交时间:"),
          Text(item["date"].toString()),
        ],
      ),
    );
  }
}
