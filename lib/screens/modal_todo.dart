import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/todo_model.dart';
import '../../../../providers/todo_provider.dart';

class TodoModal extends StatefulWidget {
  final String type;
  final Todo? item;

  TodoModal({super.key, required this.type, this.item});

  @override
  State<TodoModal> createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  final TextEditingController _formFieldController = TextEditingController();

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (widget.type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      case 'Delete':
        {
          return Text("Are you sure you want to delete '${widget.item?.title}'?");
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.item != null ? widget.item!.title : '',
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (widget.type) {
          case 'Add':
          {
            // Modify the add method to call the provider method
            Todo temp = Todo(
                // id: 1.toString(),
                completed: false,
                title: _formFieldController.text);
            context.read<TodoListProvider>().addTodo(temp);
            Navigator.of(context).pop();

            break;
          }
          case 'Edit':
            {
              if (widget.item?.id != null) {
                context.read<TodoListProvider>().editTodo(
                  widget.item!.id!,
                  _formFieldController.text,
                );
                // Remove dialog after editing
                Navigator.of(context).pop();
              } 
              break;
            }

          case 'Delete':
            {
            if (widget.item?.id != null) {
                  context.read<TodoListProvider>().deleteTodo(widget.item!.id!);
                  Navigator.of(context).pop();
                } 
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
