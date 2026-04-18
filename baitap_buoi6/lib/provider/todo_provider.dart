import 'package:flutter/material.dart';
import '../database/db_todo.dart';
import '../model/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await DatabaseHelper().getTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await DatabaseHelper().insertTodo(todo);
    loadTodos();
  }

  Future<void> toggleStatus(Todo todo) async {
    todo.isDone = (todo.isDone == 0) ? 1 : 0;
    await DatabaseHelper().updateTodo(todo);
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper().deleteTodo(id);
    loadTodos();
  }
}
