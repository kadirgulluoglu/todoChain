import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel extends ChangeNotifier {
  List<Task> todos = [];
  bool isLoading = true;
  int taskCount = 0;
  final String _rpcUrl = "HTTP://192.168.1.37:7545";
  final String _wsUrl = "ws://192.168.1.37:7545/";
  final String _privateKey =
      "c8da28ba2e81cf97fb29bc046b6c19c993abe286b7d6c821d011b20429c69bc7";
  Credentials? _credentials;
  Web3Client? _client;
  String? _abiCode;
  EthereumAddress? _contractAddress;
  EthereumAddress? _ownerAddress;
  DeployedContract? _contract;
  ContractFunction? _taskCount;
  ContractFunction? _todos;
  ContractFunction? _createTask;
  ContractFunction? _updateTask;
  ContractFunction? _deleteTask;
  ContractFunction? _toggleComplete;
  ContractEvent? _taskCreatedEvent;

  TodoListModel() {
    initiateSetup();
  }

  Future<void> initiateSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("src/abis/TodoContract.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client!.credentialsFromPrivateKey(_privateKey);
    _ownerAddress = await _credentials!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "TodoList"), _contractAddress!);
    _taskCount = _contract!.function("taskCount");
    _updateTask = _contract!.function("updateTask");
    _createTask = _contract!.function("createTask");
    _deleteTask = _contract!.function("deleteTask");
    _toggleComplete = _contract!.function("toggleComplete");
    _todos = _contract!.function("todos");
    await getTodos();
  }

  getTodos() async {
    List totalTasksList = await _client!
        .call(contract: _contract!, function: _taskCount!, params: []);
    BigInt totalTasks = totalTasksList[0];
    taskCount = totalTasks.toInt();
    todos.clear();
    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await _client!.call(
          contract: _contract!, function: _todos!, params: [BigInt.from(i)]);
      if (temp[1] != "") {
        todos.add(
          Task(
            id: (temp[0] as BigInt).toInt(),
            taskName: temp[1],
            isCompleted: temp[2],
          ),
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  updateTask(int id, String taskNameData) async {
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _updateTask!,
        parameters: [BigInt.from(id), taskNameData],
      ),
    );
    await getTodos();
  }

  deleteTask(int id) async {
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _deleteTask!,
        parameters: [BigInt.from(id)],
      ),
    );
    await getTodos();
  }

  toggleComplete(int id) async {
    await _client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _toggleComplete!,
        parameters: [BigInt.from(id)],
      ),
    );
    await getTodos();
  }

  addTask(String taskNameData) async {
    isLoading = true;
    notifyListeners();
    await _client!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _createTask!,
            parameters: [taskNameData]));
    await getTodos();
  }
}

class Task {
  final int id;
  final String? taskName;
  final bool isCompleted;
  Task({required this.id, this.taskName, this.isCompleted = false});
}
