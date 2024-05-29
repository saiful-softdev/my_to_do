import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
    static const _dbName = "todo.db";
  static const _dbVersion = 1;
  static const _table="todo";
  static const _todoTitle = "todoTitle";
  static const _todo = "todo";
  static const _todoId = "todoId";
  Database? db;

  Future<void> init() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, _dbName);
    db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE $_table(
    $_todoId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $_todoTitle TEXT,
    $_todo TEXT)
    ''');
  }

  Future<int?> insert(String? title, String? todo) async {
    return await db?.insert(_table, {_todoTitle: title, _todo: todo},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>?> queryAllRows() async {
    return await db?.query(_table);
  }

  Future<int?> update(int? columnID, String? title, String? todo) async {
    return await db?.update(
        _table, {_todoId: columnID, _todoTitle: title, _todo: todo},
        where: "_toDoId=?", whereArgs: [columnID]);
  }

  Future<int?> delete(int? columnId) async {
    return await db?.delete(_table, where: "$_todoId=?", whereArgs: [columnId]);
  }
}
