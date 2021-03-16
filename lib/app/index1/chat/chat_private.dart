import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index1/chat/url_chat.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/model/PrivateChatModel.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/calc/sort.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

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

  TextEditingController _text = new TextEditingController();

  Widget _buildTextComposer() {
    return new Container(
        color: Colors.white10,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new IconButton(
              onPressed: null,
              icon: Icon(
                Icons.settings_voice,
                color: Colors.black,
              )),
          new Flexible(
            child: new TextField(
              controller: _text,
              onSubmitted: (data) async {},
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
                  send_chat(UrlChat.Private_Send_text, _text.text, null, "");
                  _text.clear();
                }),
          )
        ]));
  }

  Future<void> get_data() async {
    Map<String, String> post = {};
    _uid = await Storage.Get("__uid__");
    _fid = this._pageparam["fid"].toString();
    var history = await PrivateChatModel.Api_select_byChatId(this._pageparam["chat_id"]);
    setState(() {
      if (history != null) {
        Sort.sort(history, "msg_id");
        _data = history;
      }
    });
    post["uid"] = _uid;
    post["token"] = await Storage.Get("__token__");
    post["fid"] = _fid;
    var ret = await Net.Post(Config.Url, UrlChat.Private_Msg, null, post, null);
    var json = jsonDecode(ret);
    if (Auth.Return_login_check_and_Goto(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          _data = json["data"];
          _data.forEach((element) async {
            if (await PrivateChatModel.Api_find(element["id"]) != null) {
              await PrivateChatModel.Api_delete(element["id"]);
            }
            PrivateChatModel.Api_insert(
              element["id"],
              element["chat_id"],
              element["sender"],
              element["type"],
              element["message"],
              element["extra"],
              element["ident"],
              element["is_read"],
              element["date"],
            );
          });
        });
      }
    }
  }

  Future<void> send_chat(String UrlChat, dynamic msg, Map extra, dynamic ident) async {
    Map<String, String> post = {};
    _uid = await Storage.Get("__uid__");
    _fid = this._pageparam["fid"].toString();
    post["uid"] = _uid;
    post["token"] = await Storage.Get("__token__");
    post["fid"] = _fid;
    post["msg"] = msg.toString();
    post["extra"] = extra.toString();
    post["ident"] = ident.toString();
    _friend_info = await FriendInfo.friend_info(_fid);
    var ret = await Net.Post(Config.Url, UrlChat, null, post, null);

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
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_Style_default,
        ),
        leading: BackButton(
          onPressed: () async {
            eventhub.fire(EventType.Websocket_refresh_list);
            Windows.Close(context);
          },
        ),
      ),
      body: WillPopScope(
        child: new Column(
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
        onWillPop: () async {
          eventhub.fire(EventType.Websocket_refresh_list);
          Windows.Close(context);
        },
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
    if (this.message["sender"].toString() == _uid) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5), topRight: Radius.circular(0), topLeft: Radius.circular(5)),
                  color: Style.Chat_on_right(context),
                ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5), topRight: Radius.circular(0.0), topLeft: Radius.circular(5.0)),
                    color: Style.Chat_on_left(context),
                  ),
                  child: new Text(
                    message["message"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
