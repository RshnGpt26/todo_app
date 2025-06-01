import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../services/db_helper.dart';
import 'add_update_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<TodoProvider>(context, listen: false).init();
    context.read<TodoProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TODO List")),
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          if (context.watch<TodoProvider>().todos.isEmpty) {
            // if (provider.todos.isEmpty) {
            return Center(
              child: Text(
                "No TODOs yet!!",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: provider.todos.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Checkbox(
                    value:
                        (provider.todos[index][DBHelper.todoCompletedColumn] ??
                            0) ==
                        1,
                    onChanged:
                        (value) => provider.onToDoStatusUpdate(value, index),
                  ),
                  Expanded(
                    child: Text(
                      provider.todos[index][DBHelper.todoTitleColumn] ?? "",
                      style: TextStyle(
                        decoration:
                            (provider.todos[index][DBHelper
                                            .todoCompletedColumn] ??
                                        0) ==
                                    1
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => AddUpdateTodoScreen(
                                onSave: (title) {
                                  provider.onUpdateSave(
                                    id:
                                        provider.todos[index][DBHelper
                                            .todoIDColumn] ??
                                        -1,
                                    title: title.trim(),
                                  );
                                },
                                oldText:
                                    provider.todos[index][DBHelper
                                        .todoTitleColumn] ??
                                    "",
                                isUpdating: true,
                              ),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: () => provider.onToDoDelete(index),
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => AddUpdateTodoScreen(
                    onSave:
                        (title) => context.read<TodoProvider>().onAddSave(
                          title: title.trim(),
                        ),
                  ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
