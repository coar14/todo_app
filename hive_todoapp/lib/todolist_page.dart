import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todoapp/todo_item.dart';
import 'package:hive_todoapp/todo_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoService _todoService = TodoService();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive TODO List"),
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoItem>('todoBox').listenable(),
        builder: (context, Box<TodoItem> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var todo = box.getAt(index);
              return ListTile(
                title: Text(todo!.title),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (val) {
                    _todoService.toggleCompleted(index, todo);
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _todoService.deleteTodo(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add Todo'),
                  content: TextField(
                    controller: _controller,
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text('Add'),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          var todo = TodoItem(_controller.text, false);
                          _todoService.addTodo(todo);
                          _controller.clear();
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
