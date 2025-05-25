import 'package:flutter/material.dart';
import 'package:todo_app/services/db_helper.dart';
import 'package:todo_app/widgets/add_todo_sheet_widget.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    getAllToDos();
  }

  getAllToDos() async {
    todos = await dbHelper!.fetchAllToDos();
    setState(() {});
  }

  onToDoStatusUpdate(bool? value, int index) async {
    await dbHelper!.updateToDoStatus(
      todoId: todos[index][DBHelper.todoIDColumn] ?? -1,
      isComplete: value == true ? 1 : 0,
    );
    getAllToDos();
  }

  onToDoTextUpdate(String text, int index) async {
    await dbHelper!.updateToDoText(
      todoId: todos[index][DBHelper.todoIDColumn] ?? -1,
      text: text,
    );
    getAllToDos();
  }

  onToDoDelete(int index) async {
    await dbHelper!.deleteToDo(
      todoId: todos[index][DBHelper.todoIDColumn] ?? -1,
    );
    getAllToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TODO List")),
      body:
          todos.isNotEmpty
              ? ListView.builder(
                shrinkWrap: true,
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Checkbox(
                        value:
                            (todos[index][DBHelper.todoCompletedColumn] ?? 0) ==
                            1,
                        onChanged: (value) => onToDoStatusUpdate(value, index),
                      ),
                      Expanded(
                        child: Text(
                          todos[index][DBHelper.todoTitleColumn] ?? "",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            isScrollControlled: true,
                            builder: (context) {
                              return AddTodoSheetWidget(
                                onSave: (title) async {
                                  await dbHelper!.updateToDoText(
                                    todoId:
                                        todos[index][DBHelper.todoIDColumn] ??
                                        -1,
                                    text: title.trim(),
                                  );
                                  await getAllToDos();
                                },
                                oldText:
                                    todos[index][DBHelper.todoTitleColumn] ??
                                    "",
                                isUpdating: true,
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () => onToDoDelete(index),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  );
                },
              )
              : Center(
                child: Text(
                  "No TODOs yet!!",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            isScrollControlled: true,
            builder: (context) {
              return AddTodoSheetWidget(
                onSave: (title) async {
                  await dbHelper!.addToDo(title: title.trim());
                  await getAllToDos();
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
