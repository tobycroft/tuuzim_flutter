import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class PrivateChatModel {
  static String _table = "private_chat";

  static Future<bool> Api_insert(int msg_id, String chat_id, sender, type, message, extra, ident, is_read, date) async {
    Database db = await TuuzDb().getDb();
    Map<String, dynamic> data = {
      "msg_id": msg_id,
      "chat_id": chat_id,
      "sender": sender,
      "type": type,
      "message": message,
      "extra": extra,
      "ident": ident,
      "is_read": is_read,
      "date": date,
    };
    return await TuuzOrm(db).table(_table).insert(data);
  }

  static Future<dynamic> Api_find(int msg_id) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("msg_id", msg_id).first();
  }

  static Future<dynamic> Api_delete(int msg_id) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("msg_id", msg_id).delete();
  }

  static Future<dynamic> Api_select_byChatId(dynamic chat_id) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("chat_id", chat_id).orderByDesc("msg_id").get();
  }

  static Future<List> Api_select() async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).orderBy("id").get();
  }
}
