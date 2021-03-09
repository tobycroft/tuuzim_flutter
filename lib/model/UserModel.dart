import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/model/BaseModel.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class UserModel extends BaseModel {
  static final String _table = "user";

  static Future<bool> Api_insert(dynamic uid, token, username, password) async {
    Database db = await TuuzDb().getDb();
    Map<String, dynamic> data = {
      "uid": uid,
      "token": token,
      "username": username,
      "password": password,
    };
    return await TuuzOrm(db).table(_table).insert(data);
  }

  static Future<Map> Api_find() async {
    Database db = await TuuzDb().getDb();
    Map data = await TuuzOrm(db).table(_table).orderByDesc("id").first();
    return data;
  }

  static Future<Map> Api_find_by_username(String username) async {
    Database db = await TuuzDb().getDb();
    Map data = await TuuzOrm(db).table(_table).where("username", username).first();
    return data;
  }

  static Future<bool> Api_update_by_username(String username, password, uid, token) async {
    Database db = await TuuzDb().getDb();
    Map<String, dynamic> datas = {
      "password": password,
      "uid": uid,
      "token": token,
    };
    bool data = await TuuzOrm(db).table(_table).where("username", username).update(datas);
    return data;
  }

  static Future<bool> Api_tuncate() async {
    Database db = await TuuzDb().getDb();
    bool data = await TuuzOrm(db).table(_table).truncate();
    return data;
  }
}
