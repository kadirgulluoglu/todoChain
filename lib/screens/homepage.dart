import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_blockchain_dapp/model/todolist_model.dart';

import '../theme/colors.dart';
import 'bottom_sheet.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);
    return Scaffold(
      backgroundColor: primary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFloatingActionButton(context),
      body: SafeArea(
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

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        buildBottomSheet(context);
      },
      backgroundColor: action,
      child: const Icon(Icons.add),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: listModel.isLoading
                ? buildLoadingIndicator()
                : ListView.builder(
                    itemCount: listModel.taskCount,
                    itemBuilder: (context, index) => GestureDetector(
                      onHorizontalDragStart: (dragStartDetails) {
                        listModel.toggleComplete(listModel.todos[index].id);
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            Text("● ",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: listModel.todos[index].isCompleted
                                      ? action
                                      : black,
                                )),
                            Text(
                              listModel.todos[index].taskName.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: listModel.todos[index].isCompleted
                                      ? action
                                      : black,
                                  decoration: listModel.todos[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ],
                        ),
                        onTap: () {
                          buildBottomSheet(context,
                              task: listModel.todos[index]);
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Spacer buildSpacer() => const Spacer(flex: 1);

  Center buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(color: primary),
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
