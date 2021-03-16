import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class GroupMemberModel {
  static String _table = "group_member";

  static Future<bool> Api_insert(int uid, int gid, String uname, face, role, card) async {
    Database db = await TuuzDb().getDb();
    Map<String, dynamic> data = {
      "uid": uid,
      "gid": gid,
      "uname": uname,
      "face": face,
      "role": role,
      "card": card,
    };
    return await TuuzOrm(db).table(_table).insert(data);
  }

  static Future<dynamic> Api_find(int uid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("uid", uid).first();
  }

  static Future<dynamic> Api_delete(int uid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("uid", uid).delete();
  }

  static Future<List> Api_select() async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).orderBy("id").get();
  }
}
