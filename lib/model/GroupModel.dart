import 'package:sqflite/sqflite.dart';
import 'package:tuuzim_flutter/model/BaseModel.dart';
import 'package:tuuzim_flutter/tuuz/database/Db.dart';
import 'package:tuuzim_flutter/tuuz/database/Orm.dart';

class GroupoModel extends BaseModel {
  static String _table = "group";

  Future<bool> Api_insert(int gid, String announcement, ban_all, can_add, can_recommend, category, direct_join_group, group_name, img, introduction, max_admin_count, max_member_count) async {
    Database db = await TuuzDb().getDb();
    Map<String, dynamic> data = {
      "gid": gid,
      "announcement": announcement,
      "ban_all": ban_all,
      "can_add": can_add,
      "can_recommend": can_recommend,
      "category": category,
      "direct_join_group": direct_join_group,
      "group_name": group_name,
      "img": img,
      "introduction": introduction,
      "max_admin_count": max_admin_count,
      "max_member_count": max_member_count,
    };
    return await TuuzOrm(db).table(_table).insert(data);
  }

  Future<List> Api_select() async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).get();
  }

  Future<Map> Api_find(int gid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("gid", gid).first();
  }

  Future<bool> Api_delete(int gid) async {
    Database db = await TuuzDb().getDb();
    return await TuuzOrm(db).table(_table).where("gid", gid).delete();
  }
}
