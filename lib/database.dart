import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE merlin ("
          "id INTEGER PRIMARY KEY,"
          "student_name TEXT,"
          "college_name TEXT,"
          "email TEXT,"
          "mobile TEXT,"
          "department TEXT,"
          "year TEXT,"
          "division TEXT,"
          "roll_number TEXT,"
          "college_number TEXT"
          ")");
    });
  }

  Future<void> insertData(Map<String, dynamic> newData) async {
    final db = await database;
    var res = await db.insert('merlin', newData);
    return res;
  }

  Future<void> updateData(Map<String, dynamic> newData) async {
    final db = await database;
    var res =
        await db.update("merlin", newData, where: "id = ?", whereArgs: [1]);
    return res;
  }

  Future<Map<String, dynamic>> getData(int id) async {
    final db = await database;
    var res = await db.query("merlin", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      return res.first;
    }
  }
}
