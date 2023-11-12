import 'package:hive/hive.dart';
import 'package:hive_todoapp/todo_item.dart';

class TodoService {
  final String mybox = "todoBox";

  Future<Box<TodoItem>> get _box async => await Hive.openBox<TodoItem>(mybox);

   Future<void> addTodo(TodoItem item) async {
    var box = await _box;
    await box.add(item);
  }

  Future<List<TodoItem>> getAllTodos() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteTodo(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }

  Future<void> toggleCompleted(int index, TodoItem item) async {
    var box = await _box;
    item.isCompleted = !item.isCompleted;
    await box.putAt(index, item);
  }
}
