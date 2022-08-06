import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todolist_model.dart';
import '../theme/colors.dart';

buildBottomSheet(BuildContext context, {Task? task}) {
  final TextEditingController _editingController = TextEditingController();
  var listModel = Provider.of<TodoListModel>(context, listen: false);
  Size size = MediaQuery.of(context).size;
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (context) => ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 16, sigmaX: 16),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.4)),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: size.height * .3,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  buildHoldBar(size),
                  SizedBox(height: size.height * .03),
                  task == null
                      ? buildTitle("Add Task")
                      : buildTitle("Update Task"),
                  SizedBox(height: size.height * .01),
                  buildInputText(_editingController),
                  SizedBox(height: size.height * .01),
                  task == null
                      ? buildButton("Add", () {
                          addTaskFunc(_editingController, listModel, context);
                        })
                      : buildButton("Update", () {
                          updateTaskFunc(
                              _editingController, listModel, task, context);
                        })
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void updateTaskFunc(TextEditingController _editingController,
    TodoListModel listModel, Task task, BuildContext context) {
  if (_editingController.text != "") {
    listModel.updateTask(task.id, _editingController.text);
    Navigator.pop(context);
  }
}

void addTaskFunc(TextEditingController _editingController,
    TodoListModel listModel, BuildContext context) {
  if (_editingController.text != "") {
    listModel.addTask(_editingController.text);
    Navigator.pop(context);
  }
}

Container buildHoldBar(Size size) {
  return Container(
    height: 5,
    width: size.width * .3,
    decoration: BoxDecoration(
        color: Colors.grey[300], borderRadius: BorderRadius.circular(16)),
  );
}

buildButton(String text, VoidCallback onPressed) {
  return MaterialButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(color: white),
    ),
    color: primary,
  );
}

buildInputText(TextEditingController _editingController) {
  return TextField(
    autofocus: true,
    cursorColor: white,
    controller: _editingController,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: action.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: action.withOpacity(0.9)),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}

buildTitle(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 30, color: white, fontWeight: FontWeight.w600),
  );
}
