import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() {
    return DBHelper._();
  }

  Database? mDB;

  static const String todosTable = "todos";
  static const String todoIDColumn = "todo_id";
  static const String todoTitleColumn = "todo_title";
  static const String todoCompletedColumn = "todo_completed";
  static const String todoCreatedAtColumn = "todo_created_at";

  Future<Database> initDB() async {
    if (mDB == null) {
      mDB = await openDB();
      return mDB!;
    } else {
      return mDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "todoDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $todosTable ( $todoIDColumn integer primary key autoincrement, $todoTitleColumn text, $todoCompletedColumn integer, $todoCreatedAtColumn text )",
        );
      },
    );
  }

  Future<void> addToDo({required String title}) async {
    var db = await initDB();

    int now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(todosTable, {
      todoTitleColumn: title,
      todoCompletedColumn: 0,
      todoCreatedAtColumn: now.toString(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllToDos() async {
    var db = await initDB();

    return await db.query(todosTable);
  }

  Future<void> updateToDoStatus({
    required int todoId,
    required int isComplete,
  }) async {
    var db = await initDB();

    await db.update(
      todosTable,
      {todoCompletedColumn: isComplete},
      where: '$todoIDColumn = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> updateToDoText({
    required int todoId,
    required String text,
  }) async {
    var db = await initDB();

    await db.update(
      todosTable,
      {todoTitleColumn: text},
      where: '$todoIDColumn = ?',
      whereArgs: [todoId],
    );
  }

  Future<void> deleteToDo({required int todoId}) async {
    var db = await initDB();

    await db.delete(
      todosTable,
      where: '$todoIDColumn = ?',
      whereArgs: [todoId],
    );
  }
}
