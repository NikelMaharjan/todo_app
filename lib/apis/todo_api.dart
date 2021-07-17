import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_bloc/models/todo_model.dart';

class TodoApi {

  var root = "https://todo-1b5db-default-rtdb.firebaseio.com/todo";

  Future<List<TodoModel>?> getAllTodos(String uid) async {
    try {
      final uri = Uri.parse("$root/$uid.json");
      final response = await get(uri);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> body =
      jsonDecode(response.body) as Map<String, dynamic>;
      print("The response is $body");

      List<TodoModel> todos = [];
      for (var key in body.keys) {
        final singleTodo = TodoModel.fromJson(body[key], key);  //to store id
        todos.add(singleTodo);
      }
      return todos;
    } catch (e) {
      print("Error are $e");
      return null;
    }
  }

  Future<String?> createTodo(TodoModel todo, String uid) async {
    try {
      final uri = Uri.parse("$root/$uid.json");
      final response = await post(uri, body: jsonEncode(todo.toJson()));
      if (response.statusCode != 200) {
        return null;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      if (body["name"] == null) {
        return null;
      }
      return body["name"];
    } catch (e) {
      print("Creating todo error $e");
      return null;
    }
  }

  Future<bool> updateTodo(TodoModel todo, String uid) async {
    var url = "https://todo-1b5db-default-rtdb.firebaseio.com/todo/$uid";
    try {
      final uri = Uri.parse("$url/${todo.id}.json");
      print("Uri is $uri");
      final response = await put(uri, body: jsonEncode(todo.toJson()));
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      if (body["name"] == null) {
        return false;
      }
      return true;
    } catch (e) {
      print("Updating todo error $e");
      return false;
    }
  }
  Future<bool> deleteTodo(String id, String uid) async {
    var url = "https://todo-1b5db-default-rtdb.firebaseio.com/todo/$uid";
    try {
      final uri = Uri.parse("$url/$id.json");
      print("Uri is $uri");
      final response = await delete(uri);
      if (response.statusCode != 200) {
        return false;
      }
      var body = jsonDecode(response.body);
      print("Body $body");
      return true;
    } catch (e) {
      print("Delete todo error $e");
      return false;
    }
  }
}