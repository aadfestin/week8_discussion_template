import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      await db.collection("todos").add(todo);

      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
 
  }

  Future<String> editTodo(String id, Map<String, dynamic> updates) async {
    try {
      // Update the doc without using dot notation.
      await db.collection("todos").doc(id).update(updates);
      return 'Todo updated successfully';
    } catch (e) {
      return 'Error updating todo: $e';
    }
  }

  Future<String> deleteTodo(String id) async {
    try {
      // Update the doc without using dot notation.
      await db.collection("todos").doc(id).delete();
      return 'Todo deleted successfully';
    } catch (e) {
      return 'Error deleting todo: $e';
    }
  }

  Future<String> toggleStatus(String id, bool status) async {
    try {
      // Update the completion status without using dot notation.
      await db.collection("todos").doc(id).update({'completed': status});
      return 'Status updated successfully';
    } catch (e) {
      return 'Error updating status: $e';
    }
  }




}