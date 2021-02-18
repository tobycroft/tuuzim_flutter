import 'package:sqflite/sqflite.dart';

class BaseModel {
  Future<void> create(Database db) async {
    await db.execute("CREATE TABLE \"user\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"uid\" INTEGER, \"token\" TEXT, \"username\" TEXT, \"password\" TEXT );");


  }

  Future<void> update(Database db) async {

    await db.execute("CREATE TABLE \"friends\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"fid\" INTEGER, \"uname\" TEXT, \"nickname\" TEXT, \"face\" TEXT, \"sex\" TEXT, \"telephone\" TEXT, "
        "\"remark\" TEXT, \"mail\" TEXT, \"introduction\" TEXT, \"destroy\" TEXT, \"destory_time\" TEXT, \"can_pull\" TEXT, \"can_notice\" TEXT );");


    await db.execute("CREATE TABLE \"groups\" ( \"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"gid\" INTEGER, \"announcement\" text, \"ban_all\" text, \"can_add\" text, \"can_recommend\" text, \"category\" text,"
        " \"direct_join_group\" text, \"group_name\" text, \"img\" text, \"introduction\" text, \"max_admin_count\" text, \"max_member_count\" text );");
  }
}
