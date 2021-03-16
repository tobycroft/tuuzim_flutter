import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:websocket_manager/websocket_manager.dart';

final socket = WebsocketManager(Config.WS);

void init_websocket() async {
  socket.onClose((dynamic message) {
    print(EventType.Websocket_onclose);
    eventhub.fire(EventType.Websocket_onclose, message);
    sleep(Duration(seconds: 5));
    socket.connect();
  });

  socket.onMessage((dynamic message) {
    // print('websocket_recv: $message');
    eventhub.fire(EventType.Websocket_OnMessage, message);
  });

  eventhub.on(EventType.Websocket_Send, (dynamic message) {
    print(EventType.Websocket_Send + ":" + message.toString());
    socket.send(jsonEncode(message));
  });

  eventhub.on(EventType.Websocket_close, (_) {
    socket.close();
  });

  eventhub.on(EventType.Websocket_close, (_) {
    socket.connect();
  });

  socket.connect();
}
