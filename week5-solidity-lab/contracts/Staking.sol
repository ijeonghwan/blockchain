// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Staking Contract
 * @notice 사용자가 ETH를 스테이킹하고, 시간에 따라 보상을 받을 수 있는 컨트랙트
 * @dev Features: deposit, withdraw, reward calculation, time-locked staking, emergency withdrawal
 */
contract Staking {
    address public owner;

    // 스테이킹 정보 구조체
    struct StakeInfo {
        uint256 amount;          // 스테이킹한 금액
        uint256 startTime;       // 스테이킹 시작 시간
        uint256 lastClaimTime;   // 마지막 보상 수령 시간
        uint256 rewardsClaimed;  // 누적 수령 보상
    }

    mapping(address => StakeInfo) public stakes;

    uint256 public totalStaked;           // 전체 스테이킹 총량
    uint256 public rewardRatePerSecond;   // 초당 보상률 (basis points, 1 = 0.01%)
    uint256 public lockDuration;          // 잠금 기간 (초)
    uint256 public emergencyFeePercent;   // 긴급 출금 수수료 (%)

    // 이벤트
    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward, uint256 timestamp);
    event RewardClaimed(address indexed user, uint256 reward, uint256 timestamp);
    event EmergencyWithdrawn(address indexed user, uint256 amount, uint256 fee, uint256 timestamp);
    event Deposited(address indexed from, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    /**
     * @notice 컨트랙트 생성자
     * @param _rewardRate 초당 보상률 (basis points) - 예: 1 = 초당 0.01%
     * @param _lockDuration 잠금 기간 (초) - 예: 60 = 1분
     * @param _emergencyFee 긴급 출금 수수료 (%) - 예: 10 = 10%
     */
    constructor(
        uint256 _rewardRate,
        uint256 _lockDuration,
        uint256 _emergencyFee
    ) payable {
        owner = msg.sender;
        rewardRatePerSecond = _rewardRate;
        lockDuration = _lockDuration;
        emergencyFeePercent = _emergencyFee;
    }

    /**
     * @notice ETH를 스테이킹합니다
     */
    function stake() external payable {
        require(msg.value > 0, "Must stake more than 0");

        StakeInfo storage info = stakes[msg.sender];

        // 기존 스테이킹이 있으면 보상을 먼저 정산
        if (info.amount > 0) {
            uint256 pending = calculateReward(msg.sender);
            if (pending > 0) {
                info.rewardsClaimed += pending;
                payable(msg.sender).transfer(pending);
                emit RewardClaimed(msg.sender, pending, block.timestamp);
            }
        }

        info.amount += msg.value;
        info.startTime = block.timestamp;
        info.lastClaimTime = block.timestamp;
        totalStaked += msg.value;

        emit Staked(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice 스테이킹한 ETH와 보상을 출금합니다 (잠금 기간 후)
     */
    function withdraw() external {
        StakeInfo storage info = stakes[msg.sender];
        require(info.amount > 0, "No staked amount");
        require(
            block.timestamp >= info.startTime + lockDuration,
            "Tokens are still locked"
        );

        uint256 reward = calculateReward(msg.sender);
        uint256 amount = info.amount;
        uint256 total = amount + reward;

        // 상태 업데이트 (재진입 방지)
        totalStaked -= info.amount;
        info.amount = 0;
        info.rewardsClaimed += reward;
        info.lastClaimTime = block.timestamp;

        require(address(this).balance >= total, "Insufficient contract balance");
        payable(msg.sender).transfer(total);

        emit Withdrawn(msg.sender, amount, reward, block.timestamp);
    }

    /**
     * @notice 보상만 수령합니다 (원금은 유지)
     */
    function claimReward() external {
        StakeInfo storage info = stakes[msg.sender];
        require(info.amount > 0, "No staked amount");

        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, "No reward available");

        info.rewardsClaimed += reward;
        info.lastClaimTime = block.timestamp;

        require(address(this).balance >= reward, "Insufficient contract balance");
        payable(msg.sender).transfer(reward);

        emit RewardClaimed(msg.sender, reward, block.timestamp);
    }

    /**
     * @notice 긴급 출금 - 잠금 기간 전에도 출금 가능 (수수료 부과)
     */
    function emergencyWithdraw() external {
        StakeInfo storage info = stakes[msg.sender];
        require(info.amount > 0, "No staked amount");

        uint256 amount = info.amount;
        uint256 fee = (amount * emergencyFeePercent) / 100;
        uint256 payout = amount - fee;

        // 상태 업데이트
        totalStaked -= info.amount;
        info.amount = 0;
        info.lastClaimTime = block.timestamp;

        require(address(this).balance >= payout, "Insufficient contract balance");
        payable(msg.sender).transfer(payout);

        emit EmergencyWithdrawn(msg.sender, payout, fee, block.timestamp);
    }

    /**
     * @notice 특정 사용자의 미청구 보상을 계산합니다
     * @param _user 사용자 주소
     * @return 미청구 보상 (wei)
     */
    function calculateReward(address _user) public view returns (uint256) {
        StakeInfo storage info = stakes[_user];
        if (info.amount == 0) return 0;

        uint256 duration = block.timestamp - info.lastClaimTime;
        // 보상 = 스테이킹 금액 * 경과시간 * 보상률 / 10000 (basis points)
        uint256 reward = (info.amount * duration * rewardRatePerSecond) / 10000;
        return reward;
    }

    /**
     * @notice 사용자의 스테이킹 잔액을 조회합니다
     * @param _user 사용자 주소
     * @return 스테이킹된 금액 (wei)
     */
    function getStakedBalance(address _user) external view returns (uint256) {
        return stakes[_user].amount;
    }

    /**
     * @notice 잠금 해제까지 남은 시간을 조회합니다
     * @param _user 사용자 주소
     * @return 남은 시간 (초), 이미 해제되었으면 0
     */
    function getRemainingLockTime(address _user) external view returns (uint256) {
        StakeInfo storage info = stakes[_user];
        if (info.amount == 0) return 0;

        uint256 unlockTime = info.startTime + lockDuration;
        if (block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }

    /**
     * @notice 컨트랙트 잔액을 조회합니다
     * @return 컨트랙트 잔액 (wei)
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice 오너가 보상 풀에 ETH를 추가합니다
     */
    function depositRewardPool() external payable onlyOwner {
        require(msg.value > 0, "Must deposit more than 0");
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @notice 오너가 잠금 기간을 변경합니다
     */
    function setLockDuration(uint256 _newDuration) external onlyOwner {
        lockDuration = _newDuration;
    }

    /**
     * @notice 오너가 보상률을 변경합니다
     */
    function setRewardRate(uint256 _newRate) external onlyOwner {
        rewardRatePerSecond = _newRate;
    }

    // 컨트랙트로 직접 ETH를 보낼 수 있도록
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }
}
