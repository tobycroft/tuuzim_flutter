import 'dart:convert';

import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/extend/websocket/ws_message.dart';
import 'package:tuuzim_flutter/main.dart';

class WsRouter {
  static Route(dynamic message) async {
    var json = jsonDecode(message);
    // print("ws_route:" + message);
    switch (json["type"].toString()) {
      case "connected":
        var login = await AuthAction.LoginObject();
        Map data = WsMessage.init(login["uid"], login["token"]);
        eventhub.fire(EventType.Websocket_Send, data);
        break;

      case "init":
        break;

      case "private_chat":
        eventhub.fire(EventType.Private_chat, json);
        break;

      case "request_count":
        eventhub.fire(EventType.FriendList_updated);
        break;

      case "refresh_list":
        eventhub.fire(EventType.Websocket_refresh_list);
        break;

      default:
        print("ws_undefined:" + message);
        break;
    }
  }
}
