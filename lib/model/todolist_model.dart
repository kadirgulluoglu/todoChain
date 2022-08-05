import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class TodoListModel extends ChangeNotifier {
  List<Task> todos = [];
  bool isLoading = true;
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
        await rootBundle.loadString("src/abis/TodoList.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi['abi']);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi['networks']["5777"]["address"]);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = await _client!.credentialsFromPrivateKey(_privateKey);
    _ownerAddress = await _credentials!.extractAddress();
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode!, "todoList"), _contractAddress!);
    _taskCount = _contract!.function("taskCount");
    _createTask = _contract!.function("createTask");
    _todos = _contract!.function("todos");
    _taskCreatedEvent = _contract!.event("TaskCreated");
    getTodos();
  }

  getTodos() async {
    List totalTasksList = await _client!
        .call(contract: _contract!, function: _taskCount!, params: []);
    BigInt totalTasks = totalTasksList[0];
    todos.clear();
    for (var i = 0; i < totalTasks.toInt(); i++) {
      var temp = await _client!.call(
          contract: _contract!, function: _todos!, params: [BigInt.from(i)]);
      print(temp);
      todos.add(Task(taskName: temp[0], isCompleted: temp[1]));
    }
    isLoading = false;
    notifyListeners();
  }
}

class Task {
  String? taskName;
  bool? isCompleted;
  Task({this.taskName, this.isCompleted});
}
