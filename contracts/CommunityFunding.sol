// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityFunding {
    struct Project {
        string description;
        uint256 targetAmount;
        uint256 voteCount;
        address payable recipient;
        bool fundsDistributed;
    }

    Project[] public projects;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    function proposeProject(string memory _description, uint256 _targetAmount, address payable _recipient) public {
        projects.push(Project({
            description: _description,
            targetAmount: _targetAmount,
            voteCount: 0,
            recipient: _recipient,
            fundsDistributed: false
        }));
    }

    function voteForProject(uint256 _projectIndex) public {
        require(_projectIndex < projects.length, "Project does not exist");
        require(!hasVoted[_projectIndex][msg.sender], "Already voted for this project");

        hasVoted[_projectIndex][msg.sender] = true;
        projects[_projectIndex].voteCount += 1;
    }

    function distributeFunds(uint256 _projectIndex) public payable {
        Project storage project = projects[_projectIndex];
        require(!project.fundsDistributed, "Funds already distributed");
        require(project.voteCount > 0, "Project needs votes");
        require(address(this).balance >= project.targetAmount, "Contract has insufficient balance");

        project.fundsDistributed = true;
        (bool success, ) = project.recipient.call{value: project.targetAmount}("");
        require(success, "Transfer failed");
    }

    receive() external payable {}
}