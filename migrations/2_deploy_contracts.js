const TodoList = artifacts.require("TodoContract");

module.exports = function (deployer) {
  deployer.deploy(TodoList);
};
