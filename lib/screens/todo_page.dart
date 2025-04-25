import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/todo_model.dart';
import '../../../../providers/todo_provider.dart';
import 'modal_todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    return Scaffold(
      appBar: AppBar(title: const Text("Todo")),
body: StreamBuilder(
  stream: todosStream,
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Center(
        child: Text("Error encountered! ${snapshot.error}"),
      );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (!snapshot.hasData) {
      return Center(
        child: Text("No Todos Found"),
      );
    }

    return ListView.builder(
      itemCount: snapshot.data?.docs.length,
      itemBuilder: ((context, index) {
        final doc = snapshot.data!.docs[index];
        Todo todo = Todo.fromJson(doc.data() as Map<String, dynamic>);
        todo.id = doc.id;
        return Dismissible(
          key: Key(todo.id.toString()),
          confirmDismiss: (direction) async {
                  // Show confirmation dialog for delete
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm"),
                      content: Text("Delete '${todo.title}'?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },
          onDismissed: (direction) {
            context.read<TodoListProvider>().deleteTodo(todo.id!);

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${todo.title} dismissed')));
          },
          background: Container(
            color: Colors.red,
            child: const Icon(Icons.delete),
          ),
          child: ListTile(
            title: Text(todo.title),
            leading: Checkbox(
              value: todo.completed,
              onChanged: (bool? value) {
                context
                    .read<TodoListProvider>()
                    .toggleStatus(
                        todo.id!,
                        !todo.completed,
                      );
                print("we changed the value to" + "${todo.completed}");
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => TodoModal(
                        type: 'Edit',
                        item: todo, // pass the item
                      ),
                    );
                  },
                  icon: const Icon(Icons.create_outlined),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => TodoModal(
                        type: 'Delete',
                        item: todo, // pass the item
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outlined),
                )
              ],
            ),
          ),
        );
      }),
    );
  },
),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(type: 'Add'),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
