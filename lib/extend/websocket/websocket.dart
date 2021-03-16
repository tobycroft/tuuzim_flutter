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
  });

  socket.onMessage((dynamic message) {
    // print('websocket_recv: $message');
    eventhub.fire(EventType.Websocket_OnMessage, message);
  });

  eventhub.on(EventType.Websocket_Send, (dynamic message) {
    socket.send(message.toString());
  });

  eventhub.on(EventType.Websocket_close, (_) {
    socket.close();
  });

  eventhub.on(EventType.Websocket_close, (_) {
    socket.connect();
  });

  socket.connect();
}
