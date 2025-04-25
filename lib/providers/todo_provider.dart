import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/todo_model.dart';
import '../api/firebase_todo_api.dart';

class TodoListProvider with ChangeNotifier {
late FirebaseTodoAPI firebaseService;
late Stream<QuerySnapshot> _todosStream;

TodoListProvider() {
  firebaseService = FirebaseTodoAPI();
  fetchTodos();
}

Stream<QuerySnapshot> get todos => _todosStream;

fetchTodos() {
  _todosStream = firebaseService.getAllTodos();
  notifyListeners();
}

  // TODO: add todo item and store it in Firestore
  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson());
    print(message);
    notifyListeners();
  }

  // TODO: edit a todo item and update it in Firestore
  Future<void> editTodo(String id, String newTitle) async {
    String message = await firebaseService.editTodo(id, {'title': newTitle});
    print(message);
    notifyListeners();
  }

  // delete Todo
  Future<void> deleteTodo(String id) async {
    String message = await firebaseService.deleteTodo(id);
    print(message);
    notifyListeners();
  }

  // TODO: modify a todo status and update it in Firestore
  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.toggleStatus(id, status);
    print(message);
    notifyListeners();
  }

  
}
