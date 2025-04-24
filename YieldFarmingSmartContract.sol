// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YieldFarming {
    address public owner;
    bool public isPaused = false;

    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewardBalance;

    uint256 public rewardRate = 10; // 10%

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier notPaused() {
        require(!isPaused, "Staking is paused");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function stake() external payable notPaused {
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

    // 🧾 Check your balance and rewards
    function getMyStakeAndRewards() external view returns (uint256 stake, uint256 rewards) {
        return (stakedBalance[msg.sender], rewardBalance[msg.sender]);
    }

    // 💼 Owner can check total funds in contract
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // ⚠️ Emergency withdraw (owner only)
    function emergencyWithdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // 🔄 Update reward rate (owner only)
    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRate = _newRate;
    }

    // ⏸ Pause and resume staking
    function pauseStaking(bool _state) external onlyOwner {
        isPaused = _state;
    }
}
