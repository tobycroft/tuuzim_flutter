import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future<Database> _db;

  Future<Database> getDb() {
    _db ??= _initDb();
    return _db;
  }

  // Guaranteed to be called only once.
  Future<Database> _initDb() async {
    final db = await openDatabase(
      "tuuzim.db",
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpdate,
      singleInstance: true,
    );
    // do "tons of stuff in async mode"
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute("CREATE TABLE \"user\" ( \"id\" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, \"uid\" INTEGER, \"token\" TEXT, \"username\" TEXT, \"password\" TEXT );");
    // populate data
  }

  Future<void> _onUpdate(Database db, int oldVersion, int newVersion) async {
    // Database is created, create the table
    // await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)");
    // populate data
  }
}
