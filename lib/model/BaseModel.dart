import 'package:sqflite/sqflite.dart';

class BaseModel {
  Future<void> create(Database db) async {
    //user
    await db.execute("CREATE TABLE \"user\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"uid\" INTEGER, \"token\" TEXT, \"username\" TEXT, \"password\" TEXT );");

    //friends
    await db.execute("CREATE TABLE \"friends\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"fid\" INTEGER, \"uname\" TEXT, \"nickname\" TEXT, \"face\" TEXT, \"sex\" TEXT, \"telephone\" TEXT, "
        "\"remark\" TEXT, \"mail\" TEXT, \"introduction\" TEXT, \"destroy\" TEXT, \"destory_time\" TEXT, \"can_pull\" TEXT, \"can_notice\" TEXT );");

    //groups
    await db.execute("CREATE TABLE \"groups\" ( \"id\" INTEGER PRIMARY KEY AUTOINCREMENT, \"gid\" INTEGER, \"announcement\" text, \"ban_all\" text, \"can_add\" text, "
        "\"can_recommend\" text, \"category\" text, \"direct_join_group\" text, \"group_name\" text, \"img\" text, \"introduction\" text, \"max_admin_count\" text, \"max_member_count\" text );");

    //anynomous
    await db.execute("CREATE TABLE \"anynomous\" ( \"id\" INTEGER NOT NULL, \"uid\" INTEGER, \"uname\" TEXT, \"face\" TEXT, PRIMARY KEY (\"id\") );");

    //group_member
    await db.execute("CREATE TABLE \"group_member\" ( \"id\" INTEGER NOT NULL, \"uid\" INTEGER, \"gid\" INTEGER, \"uname\" TEXT, \"face\" TEXT, \"role\" TEXT, \"card\" TEXT, PRIMARY KEY (\"id\") );");

    //private_chat
    await db.execute("CREATE TABLE \"private_chat\" ( \"id\" INTEGER NOT NULL, \"msg_id\" INTEGER, \"chat_id\" text, \"sender\" TEXT, \"type\" TEXT, \"message\" TEXT, \"extra\" TEXT, "
        "\"ident\" TEXT, \"is_read\" TEXT, \"date\" TEXT, PRIMARY KEY (\"id\") );");
  }

  Future<void> update(Database db) async {}
}
