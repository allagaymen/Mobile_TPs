import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlBD {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "myDB.db");
    Database myDB = await openDatabase(path,
        onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    return myDB;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes(id INTEGER PRIMARY KEY, description TEXT NOT NULL, date TEXT NOT NULL)');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  readData(String sql) async {
    Database? myDb = await db;
    List<Map> res = await myDb!.rawQuery(sql);
    return res;
  }

  insertData(String sql, List<String> list) async {
    Database? myDb = await db;
    int res = await myDb!.rawInsert(sql);
    return res;
  }

  updateData(String sql) async {
    Database? myDb = await db;
    int res = await myDb!.rawUpdate(sql);
    return res;
  }

  deleteData(String sql) async {
    Database? myDb = await db;
    int res = await myDb!.delete(sql);
    return res;
  }
}
