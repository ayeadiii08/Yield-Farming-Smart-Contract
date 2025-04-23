// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YieldFarming {
    address public owner;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewardBalance;
    uint256 public rewardRate = 10; // Example: 10% reward

    constructor() {
        owner = msg.sender;
    }

    function stake() external payable {
        require(msg.value > 0, "You must stake more than 0 ETH");
        stakedBalance[msg.sender] += msg.value;
        rewardBalance[msg.sender] += (msg.value * rewardRate) / 100;
    }

    function withdraw() external {
        uint256 staked = stakedBalance[msg.sender];
        uint256 rewards = rewardBalance[msg.sender];
        require(staked > 0, "Nothing to withdraw");

        stakedBalance[msg.sender] = 0;
        rewardBalance[msg.sender] = 0;

        payable(msg.sender).transfer(staked + rewards);
    }
}

