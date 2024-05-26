import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  static const _dbName = "Todo.db";
  static const _table = "Todo";
  static const _dbVersion = 1;
  static const _toDoTitle = "Todo title";
  static const _todo = "Todo";
  static const _toDoId = "Todo.db";
  Database? _db;

  Future<void> init() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE $_table(
    $_toDoId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_toDoTitle TEXT,
    $_todo TEXT
    )
    ''');
  }

  Future<int?> insert(String? title, String? todo) async {
    return await _db?.insert(_table, {_toDoTitle: title, _todo: todo},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>?> queryAllRows() async {
    return await _db?.query(_table);
  }

  Future<int?> update(int? columnID, String? title, String? todo) async {
    return await _db?.update(
        _table, {_toDoId: columnID, _toDoTitle: title, _todo: todo},
        where: "_toDoId=?", whereArgs: [columnID]);
  }

  Future<int?> delete(int? columnId) async {
    return await _db
        ?.delete(_table, where: "$_toDoId=?", whereArgs: [columnId]);
  }
}
