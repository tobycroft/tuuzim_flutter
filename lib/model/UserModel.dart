import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/model/BaseModel.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class UserModel extends BaseModel {
  static final String _table = "user";

  static Future<int> Api_insert(dynamic uid, token, username, password) async {
    Database db = await TuuzDb().getDb();
    var dd=TuuzOrm(db).update(values)
    Map<String, dynamic> data = {
      "uid": uid,
      "token": token,
      "username": username,
      "password": password,
    };
    
    return await db.insert(_table, data);
  }

  static Future<Map> Api_find() async {
    Database db = await TuuzDb().getDb();

    List data = await TuuzOrm(db).table(_table).get();
    // var data = await db.query(
    //   _table,
    // );
    print(data);
  }
}
