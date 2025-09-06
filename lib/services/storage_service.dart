import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class StorageService {
  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(todos.map((t) => t.toJson()).toList());
    await prefs.setString('todos', jsonData);
  }

  static List<Todo> loadTodos() {
    final prefs = SharedPreferences.getInstance();
    List<Todo> todos = [];
    prefs.then((p) {
      final String? data = p.getString('todos');
      if (data != null) {
        todos = (jsonDecode(data) as List)
            .map((json) => Todo.fromJson(json))
            .toList();
      }
    });
    return todos;
  }
}