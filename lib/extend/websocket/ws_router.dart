import 'dart:convert';

import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/extend/websocket/ws_message.dart';
import 'package:tuuzim_flutter/main.dart';

class WsRouter {
  static Route(dynamic message) async {
    var json = jsonDecode(message);
    print("ws_route:" + message);
    switch (json["type"].toString()) {
      case "connected":
        var login = await AuthAction().LoginObject();
        WsMessage.init(login["uid"], login["token"]);
        break;

      default:
        print("ws_undefined:" + message);
        break;
    }
  }
}
