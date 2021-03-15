import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/chat/url_chat.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';

class ChatPrivate extends StatefulWidget {
  String _title;
  var _pageparam;
  var _friend_info;
  var _user_info;

  ChatPrivate(this._title, this._pageparam, this._friend_info, this._user_info);

  @override
  _ChatPrivate createState() => _ChatPrivate(this._title, this._pageparam, this._friend_info, this._user_info);
}

var _data = [];
String _uid;
String _fid;

class _ChatPrivate extends State<ChatPrivate> {
  String _title;
  var _pageparam;
  var _friend_info;
  var _user_info;

  _ChatPrivate(this._title, this._pageparam, this._friend_info, this._user_info);

  Widget _buildTextComposer() {
    return new Container(
        color: Colors.white10,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: null,
              onSubmitted: null,
              decoration: new InputDecoration.collapsed(hintText: '发送消息'),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.send_rounded,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  send_chat("测试消息", null, "");
                }),
          )
        ]));
  }

  Future<void> get_data() async {
    Map<String, String> post = {};
    _uid = await Storage.Get("__uid__");
    _fid = this._pageparam["fid"].toString();
    post["uid"] = _uid;
    post["token"] = await Storage.Get("__token__");
    post["fid"] = _fid;
    var ret = await Net.Post(Config.Url, UrlChat.Private_Msg, null, post, null);
    var json = jsonDecode(ret);
    if (Auth.Return_login_check_and_Goto(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _data = json["data"];
          print(_data);
        });
      }
    }
  }

  Future<void> send_chat(String msg, Map extra, dynamic ident) async {
    Map<String, String> post = {};
    _uid = await Storage.Get("__uid__");
    _fid = this._pageparam["fid"].toString();
    post["uid"] = _uid;
    post["token"] = await Storage.Get("__token__");
    post["fid"] = _fid;
    post["msg"] = extra.toString();
    post["ident"] = ident.toString();
    _friend_info = await FriendInfo.friend_info(_fid);
    var ret = await Net.Post(Config.Url, UrlChat.Private_Msg, null, post, null);

    var json = jsonDecode(ret);
    if (Auth.Return_login_check_and_Goto(context, json)) {
      if (Ret.Check_isok(context, json)) {
        get_data();
      }
    }
  }

  @override
  void initState() {
    get_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget divider = Divider(
      color: Colors.transparent,
      height: 18.0,
      indent: 18,
    );

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_Style_default,
        ),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return divider;
              },
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (context, int index) => EntryItem(context, _uid, _data[index], this._friend_info, this._user_info),
              itemCount: _data.length,
            ),
          ),
          // new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}

class EntryItem extends StatelessWidget {
  var message;
  var uid;
  var context;
  var _friend_info;
  var _user_info;

  EntryItem(this.context, this.uid, this.message, this._friend_info, this._user_info);

  Widget row() {
    ///由自己发送，在右边显示
    print(this.message["sender"]);
    if (this.message["sender"].toString() == _uid) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  message["message"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Config.Text_Style_default,
                ),
              )
            ]),
          ),
          new Container(
            margin: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: CacheImage.network(this._user_info["face"], 40, 40),
          ),
        ],
      );
    } else {
      ///对方发送，左边显示
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: CacheImage.network(this._friend_info["face"], 40, 40),
          ),
          Flexible(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  message["message"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Config.Text_Style_default,
                ),
              )
            ]),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: row(),
    );
  }
}
