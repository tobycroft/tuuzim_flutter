import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/model/BaseModel.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class FriendModel extends BaseModel {
  static String _table = "friend_list";

  static Future<bool> Api_insert(int fid, String uname, nickname, face, sex, telephone, remark, mail, introduction, destory, destory_time, can_pull, can_notice) async {
    Database db = await TuuzDb().getDb();
    Map data = {
      "fid": fid,
      "uname": uname,
      "nickname": nickname,
      "face": face,
      "sex": sex,
      "telephone": telephone,
      "remark": remark,
      "mail": mail,
      "introduction": introduction,
      "destory": destory,
      "destory_time": destory_time,
      "can_pull": can_pull,
      "can_notice": can_notice,
    };
    return TuuzOrm(db).insert(data);
  }

  static Future<Map> Api_find(int fid) async {
    Database db = await TuuzDb().getDb();
    return TuuzOrm(db).where("fid", fid).first();
  }

  static Future<List> Api_select() async {
    Database db = await TuuzDb().getDb();
    return TuuzOrm(db).get();
  }


}
