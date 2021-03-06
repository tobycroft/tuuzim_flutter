import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/model/BaseModel.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class FriendModel extends BaseModel {
  static String _table = "friends";

  static Future<bool> Api_insert(int fid, String uname, nickname, face, sex, telephone, remark, mail, introduction, destroy, destory_time, can_pull, can_notice) async {
    Database db = await TuuzDb().getDb();
    Map<String,dynamic> data = {
      "fid": fid,
      "uname": uname,
      "nickname": nickname,
      "face": face,
      "sex": sex,
      "telephone": telephone,
      "remark": remark,
      "mail": mail,
      "introduction": introduction,
      "destroy": destroy,
      "destory_time": destory_time,
      "can_pull": can_pull,
      "can_notice": can_notice,
    };
    return await TuuzOrm(db).table(_table).insert(data);
  }

  static Future<dynamic> Api_find(int fid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("fid", fid).first();
  }

  static Future<dynamic> Api_delete(int fid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("fid", fid).delete();
  }

  static Future<List> Api_select() async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).orderBy("id").get();
  }


}
