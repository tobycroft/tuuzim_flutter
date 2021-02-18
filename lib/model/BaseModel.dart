import 'package:sqflite/sqflite.dart';

class BaseModel {
  Future<void> create(Database db) async {
    await db.execute("CREATE TABLE \"user\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
        " \"uid\" INTEGER, \"token\" TEXT, \"username\" TEXT, \"password\" TEXT );");

    await db.execute("CREATE TABLE \"friend\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"fid\" INTEGER, \"uname\" TEXT, "
        "\"nickname\" TEXT, \"face\" TEXT, \"sex\" TEXT, \"telephone\" TEXT, \"remark\" TEXT,"
        " \"mail\" TEXT, \"introduction\" TEXT, \"destroy\" TEXT, \"destory_time\" TEXT, \"can_pull\" TEXT, \"can_notice\" TEXT );");
  }

  Future<void> update(Database db) async {
    await db.execute("CREATE TABLE \"friend\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"fid\" INTEGER, \"uname\" TEXT, "
        "\"nickname\" TEXT, \"face\" TEXT, \"sex\" TEXT, \"telephone\" TEXT, \"remark\" TEXT,"
        " \"mail\" TEXT, \"introduction\" TEXT, \"destroy\" TEXT, \"destory_time\" TEXT, \"can_pull\" TEXT, \"can_notice\" TEXT );");
  }
}
