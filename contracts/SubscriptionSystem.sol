// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionSystem {
    address public owner;
    uint256 public subscriptionPrice;
    uint256 public subscriptionDuration;

    mapping(address => uint256) public subscriptionExpiration;

    constructor(uint256 _priceInWei, uint256 _durationInSeconds) {
        owner = msg.sender;
        subscriptionPrice = _priceInWei;
        subscriptionDuration = _durationInSeconds;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function setSubscriptionPrice(uint256 _newPrice) public onlyOwner {
        subscriptionPrice = _newPrice;
    }

    function subscribe() public payable {
        require(msg.value >= subscriptionPrice, "Incorrect payment amount");
        
        if (subscriptionExpiration[msg.sender] > block.timestamp) {
            subscriptionExpiration[msg.sender] += subscriptionDuration;
        } else {
            subscriptionExpiration[msg.sender] = block.timestamp + subscriptionDuration;
        }
    }

    function isSubscriptionActive(address _user) public view returns (bool) {
        return subscriptionExpiration[_user] > block.timestamp;
    }
}