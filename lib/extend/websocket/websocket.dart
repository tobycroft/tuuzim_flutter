import 'dart:io';
import 'dart:isolate';

import 'package:tuuzim_flutter/config/config.dart';
import 'package:websocket_manager/websocket_manager.dart';

final socket = WebsocketManager(Config.WS);

void websocket(SendPort port1) async {
  ReceivePort receivePort = new ReceivePort();
  SendPort port2 = receivePort.sendPort;

  port1.send([1, "isolate_1 任务完成"]);
  print("isolate_1 stop");

  // socket.onClose((dynamic message) {
  //   print('close');
  // });

  socket.onMessage((dynamic message) {
    print('websocket_recv: $message');
    port1.send([message, "isolate_1 任务完成"]);
  });

  receivePort.listen((message) {
    print("isolate_1 message: $message");
    socket.send(message);
  });

// Connect to server
  socket.connect();
}
