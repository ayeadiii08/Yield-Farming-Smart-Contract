mapping(address => uint256) public totalRewardsEarned;

function stake() external payable notPaused {
    require(msg.value > 0, "You must stake more than 0 ETH");
    stakedBalance[msg.sender] += msg.value;
    uint256 reward = (msg.value * rewardRate) / 100;
    rewardBalance[msg.sender] += reward;
    totalRewardsEarned[msg.sender] += reward;
}

function depositRewards() external payable onlyOwner {
    require(msg.value > 0, "Must deposit some ETH");
}

function restakeRewards() external notPaused {
    uint256 rewards = rewardBalance[msg.sender];
    require(rewards > 0, "No rewards to restake");

    rewardBalance[msg.sender] = 0;
    stakedBalance[msg.sender] += rewards;

    uint256 newReward = (rewards * rewardRate) / 100;
    rewardBalance[msg.sender] += newReward;
    totalRewardsEarned[msg.sender] += newReward;
}

function getStakeAndRewards(address _user) external view returns (uint256 stake, uint256 rewards) {
    return (stakedBalance[_user], rewardBalance[_user]);
}

function burnUserRewards(address _user) external onlyOwner {
    rewardBalance[_user] = 0;
}
