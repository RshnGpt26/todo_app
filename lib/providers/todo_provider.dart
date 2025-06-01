import 'package:flutter/material.dart';

import '../services/db_helper.dart';

class TodoProvider extends ChangeNotifier {
  DBHelper? _dbHelper;
  List<Map<String, dynamic>> _todos = [];

  DBHelper? get dbHelper => _dbHelper;

  List<Map<String, dynamic>> get todos => _todos;

  init() {
    _dbHelper = DBHelper.getInstance();
    getAllToDos();
  }

  getAllToDos() async {
    _todos = await _dbHelper!.fetchAllToDos();
    notifyListeners();
  }

  onToDoStatusUpdate(bool? value, int index) async {
    await _dbHelper!.updateToDoStatus(
      todoId: _todos[index][DBHelper.todoIDColumn] ?? -1,
      isComplete: value == true ? 1 : 0,
    );
    getAllToDos();
  }

  onToDoTextUpdate(String text, int index) async {
    await _dbHelper!.updateToDoText(
      todoId: _todos[index][DBHelper.todoIDColumn] ?? -1,
      text: text,
    );
    getAllToDos();
  }

  onToDoDelete(int index) async {
    await _dbHelper!.deleteToDo(
      todoId: _todos[index][DBHelper.todoIDColumn] ?? -1,
    );
    getAllToDos();
  }

  onUpdateSave({required int id, required String title}) async {
    await _dbHelper!.updateToDoText(
      todoId: id,
      // todoId: _todos[index][DBHelper.todoIDColumn] ?? -1,
      text: title.trim(),
    );
    await getAllToDos();
  }

  onAddSave({required String title}) async {
    await _dbHelper!.addToDo(title: title.trim());
    await getAllToDos();
  }
}
