import 'dart:async';
import 'dart:convert';

import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuuzim_flutter/app/index1/chat/url_chat.dart';
import 'package:tuuzim_flutter/app/index1/chat/widget_message.dart';
import 'package:tuuzim_flutter/app/index2/info/user_info.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/data/chat/private_chat_data.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/extend/chat_gen/chat_gen.dart';
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
  var _fid;
  var _friend_info;
  var _user_info;

  ChatPrivate(this._title, this._fid, this._friend_info, this._user_info);

  @override
  _ChatPrivate createState() => _ChatPrivate(this._title, this._fid, this._friend_info, this._user_info);
}

var _data = [];
String _uid;

class _ChatPrivate extends State<ChatPrivate> {
  String _title;
  var _fid;
  var _friend_info;
  var _user_info;
  StreamSubscription _eventhub;

  _ChatPrivate(this._title, this._fid, this._friend_info, this._user_info);

  var _send_button = false;
  var _voice_func = false;
  var _orign_button;
  double _buttom_plus = 0.0;

  TextEditingController _text = new TextEditingController();

  //底部输入框
  Widget _bottom_input() {
    return new Container(
        color: Colors.white10,
        // margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new IconButton(
              onPressed: () {
                setState(() {
                  this._voice_func = !this._voice_func;
                });
              },
              icon: Icon(
                this._orign_button,
                color: Style.Revert_color(context),
              )),
          input_area(),
          new IconButton(
              onPressed: () {
                setState(() {
                  this._voice_func = !this._voice_func;
                });
              },
              icon: Icon(
                Icons.face,
                color: Style.Revert_color(context),
              )),
          Offstage(
            offstage: !this._send_button,
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new FlatButton(
                minWidth: 0,
                onPressed: () async {
                  send_chat(UrlChat.Private_Send_text, _text.text, null, "");
                  setState(() {
                    _text.clear();
                    this._send_button = false;
                  });
                },
                color: Colors.green,
                child: Text("发送"),
              ),
            ),
          ),
          Offstage(
            offstage: this._send_button,
            child: new IconButton(
              onPressed: () {
                setState(() {
                  if (this._buttom_plus == 0) {
                    this._buttom_plus = 210;
                  } else {
                    this._buttom_plus = 0;
                  }
                });
              },
              icon: Icon(
                Icons.add_box_rounded,
                color: Style.Revert_color(context),
              ),
            ),
          ),
        ]));
  }

  Widget _bottom_plus() {
    return AnimatedContainer(
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(seconds: 1),
      height: this._buttom_plus,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        children: [
          GestureDetector(
            child: Column(
              children: [
                Icon(
                  Icons.image,
                  size: 64,
                ),
                Text("选择图片")
              ],
            ),
            onTap: () async {
            PickedFile pickfile=await ImagePicker().getImage(source: ImageSource.gallery);
            print(pickfile.path);
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 64,
                ),
                Text("选择相机")
              ],
            ),
            onTap: () async {
              ImagePicker().getImage(source: ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  Future<void> get_data() async {
    Map<String, String> post = {};
    _uid = await Storage.Get("__uid__");
    var history = await PrivateChatModel.Api_select_byChatId(ChatGen.ChatId(int.parse(_uid), int.parse(this._fid)));
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
            PrivateChatData.sync(element);
          });
        });
      }
    }
  }

  Widget input_area() {
    if (!this._voice_func) {
      setState(() {
        this._orign_button = Icons.settings_voice;
      });
      return new Flexible(
        child: new TextField(
          controller: _text,
          onSubmitted: (data) async {},
          onChanged: (String data) async {
            setState(() {
              if (data != "") {
                this._send_button = true;
              } else {
                this._send_button = false;
              }
            });
          },
          decoration: new InputDecoration(fillColor: Colors.green),
        ),
      );
    } else {
      setState(() {
        this._orign_button = Icons.keyboard;
      });
      return new Flexible(
        fit: FlexFit.tight,
        child: new ElevatedButton(onPressed: () {}, child: Text("发送语音")),
      );
    }
  }

  Future<void> send_chat(String UrlChat, dynamic msg, Map extra, dynamic ident) async {
    Map<String, String> post = {};
    post["uid"] = _uid;
    post["token"] = await Storage.Get("__token__");
    post["fid"] = this._fid;
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
    this._eventhub = eventhub.on(EventType.Private_chat, (dynamic message) {
      _data.add(message["data"]);
      var dat = _data;
      _data = Sort.sort(dat, "id");
      setState(() {});
      PrivateChatData.sync(message["data"]);
    });
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
            this._eventhub.cancel();
            Windows.Close(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                Windows.Open(context, UserInfo("", this._friend_info));
              })
        ],
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
              child: _bottom_input(),
            ),
            _bottom_plus(),
          ],
        ),
        onWillPop: () async {
          eventhub.fire(EventType.Websocket_refresh_list);
          this._eventhub.cancel();
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
                  maxLines: 999,
                  overflow: TextOverflow.ellipsis,
                  style: Config.Text_Style_default,
                ),
              )
            ]),
          ),
          new GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(left: 12.0, right: 12.0),
              alignment: Alignment.topCenter,
              child: CacheImage.network(this._user_info["face"], 40, 40),
            ),
            onTap: () {
              Windows.Open(context, UserInfo("", this._user_info));
            },
          ),
        ],
      );
    } else {
      ///对方发送，左边显示
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(left: 12.0, right: 12.0),
              alignment: Alignment.topCenter,
              child: CacheImage.network(this._friend_info["face"], 40, 40),
            ),
            onTap: () {
              Windows.Open(context, UserInfo("", this._friend_info));
            },
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
                  child: WidgetPrivateMessage(this.context, this.message, this.message["type"], this.message["message"], this.message["extra"], this.message["date"], this.message["ident"]),
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
