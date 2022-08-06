import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_blockchain_dapp/model/todolist_model.dart';
import 'package:to_do_list_blockchain_dapp/screens/task_screen.dart';

import '../theme/colors.dart';

class TodoList extends StatelessWidget {
  final TextEditingController _editingController = TextEditingController();

  TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildBottomSheet(context);
        },
        backgroundColor: Colors.indigo[400],
        child: const Icon(Icons.add),
      ),
      body: listModel.isLoading
          ? buildLoadingIndicator()
          : SafeArea(
              child: Column(
                children: [
                  buildIconAndName(),
                  buildCountTaskText(listModel),
                  buildTodoListView(listModel),
                  buildSpacer(),
                ],
              ),
            ),
    );
  }

  Expanded buildTodoListView(TodoListModel listModel) {
    return Expanded(
      flex: 30,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: ListView.builder(
            itemCount: listModel.taskCount,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                listModel.todos[index].taskName.toString(),
                style: TextStyle(
                    fontSize: 20,
                    decoration: listModel.todos[index].isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
              onTap: () {
                listModel.toggleComplete(listModel.todos[index].id);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildBottomSheet(BuildContext context) {
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
                child: AddTaskScreen()),
          ),
        ),
      ),
    );
  }

  Spacer buildSpacer() => const Spacer(flex: 1);

  Center buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: white),
    );
  }

  Expanded buildCountTaskText(TodoListModel listModel) {
    return Expanded(
      flex: 1,
      child: Text(
        listModel.taskCount.toString() + " Tasks",
        style: const TextStyle(color: white, fontSize: 18),
      ),
    );
  }

  Expanded buildIconAndName() {
    return Expanded(
      flex: 3,
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Icon(
              Icons.playlist_add_check,
              size: 40,
              color: white,
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 8,
            child: Text(
              "Todo Chain",
              style: TextStyle(
                  fontSize: 40, color: white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
