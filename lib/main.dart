import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_blockchain_dapp/model/todolist_model.dart';

import 'screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TodoList Dapp',
        home: TodoList(),
      ),
    );
  }
}
