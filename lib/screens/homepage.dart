import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_blockchain_dapp/model/todolist_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
      ),
      body: listModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) =>
                          const ListTile(title: Text("To do"))),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: TextField(),
                        ),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: () {},
                            child: const Text('Ekle'),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
    );
  }
}
