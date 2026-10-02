// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoList {
    string[] public tasks;

    function addTask(string memory _task) public {
        tasks.push(_task);
    }

    function removeTask(uint256 _index) public {
        require(_index < tasks.length, "Index out of bounds");
        tasks[_index] = tasks[tasks.length - 1];
        tasks.pop();
    }

    function getAllTasks() public view returns (string[] memory) {
        return tasks;
    }
}