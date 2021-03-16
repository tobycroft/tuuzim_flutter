import 'package:tuuzim_flutter/model/PrivateChatModel.dart';

class PrivateChatData {
  static Future<void> sync(element) async {
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
  }
}
