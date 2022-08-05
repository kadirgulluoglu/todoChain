import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todolist_model.dart';
import '../theme/colors.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Görev Ekle',
            style: TextStyle(fontSize: 30),
          ),
          TextField(
            controller: _editingController,
          ),
          MaterialButton(
            onPressed: () {
              listModel.addTask(_editingController.text);
              _editingController.clear();
            },
            child: const Text(
              'Ekle',
              style: TextStyle(color: white),
            ),
            color: primary,
          ),
        ],
      ),
    );
  }
}
