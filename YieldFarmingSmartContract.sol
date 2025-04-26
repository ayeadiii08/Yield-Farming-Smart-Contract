
function withdrawStake(uint256 amount) external notPaused {
    require(stakedBalance[msg.sender] >= amount, "Insufficient staked balance");
    stakedBalance[msg.sender] -= amount;
    payable(msg.sender).transfer(amount);
}
function claimRewards() external notPaused {
    uint256 rewards = rewardBalance[msg.sender];
    require(rewards > 0, "No rewards to claim");

    rewardBalance[msg.sender] = 0;
    payable(msg.sender).transfer(rewards);
}
function getTotalRewardsEarned(address _user) external view returns (uint256) {
    return totalRewardsEarned[_user];
}
bool public paused = false;

modifier notPaused() {
    require(!paused, "Staking is paused");
    _;
}

function pause() external onlyOwner {
    paused = true;
}

function unpause() external onlyOwner {
    paused = false;
}
