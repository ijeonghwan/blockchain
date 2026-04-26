const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");

  // 배포 파라미터
  const rewardRate = 1;          // 초당 0.01% 보상률
  const lockDuration = 60;       // 1분 잠금 (테스트용)
  const emergencyFee = 10;       // 긴급 출금 수수료 10%

  console.log("\n--- Staking Contract Parameters ---");
  console.log("Reward Rate:", rewardRate, "basis points per second");
  console.log("Lock Duration:", lockDuration, "seconds (1 minute)");
  console.log("Emergency Fee:", emergencyFee, "%");
  console.log("Initial Reward Pool: 0.005 ETH");

  // 배포 (0.005 ETH를 보상 풀로 전송)
  const Staking = await ethers.getContractFactory("Staking");
  const staking = await Staking.deploy(
    rewardRate,
    lockDuration,
    emergencyFee,
    { value: ethers.parseEther("0.005") }
  );

  await staking.waitForDeployment();
  const address = await staking.getAddress();

  console.log("\n✅ Staking deployed to:", address);
  console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(address)), "ETH");

  // === 트랜잭션 수행 ===

  // 1. Stake (deposit) 0.005 ETH
  console.log("\n--- 1. Staking 0.005 ETH ---");
  const stakeTx = await staking.stake({ value: ethers.parseEther("0.005") });
  const stakeReceipt = await stakeTx.wait();
  console.log("✅ Stake TX Hash:", stakeReceipt.hash);

  // 잔액 확인
  const stakedBalance = await staking.getStakedBalance(deployer.address);
  console.log("Staked Balance:", ethers.formatEther(stakedBalance), "ETH");

  // 2. 잠금 기간 대기 (60초) - 테스트넷에서는 바로 진행
  console.log("\n--- 2. Waiting for lock period (60s)... ---");
  console.log("(On testnet, we'll use emergencyWithdraw to demonstrate withdrawal without waiting)");

  // 3. Emergency Withdraw (잠금 전 긴급 출금 - 10% 수수료)
  console.log("\n--- 3. Emergency Withdraw ---");
  const emergencyTx = await staking.emergencyWithdraw();
  const emergencyReceipt = await emergencyTx.wait();
  console.log("✅ Emergency Withdraw TX Hash:", emergencyReceipt.hash);

  // 4. 다시 스테이킹 후 정상 출금을 위해 한 번 더
  console.log("\n--- 4. Re-staking 0.003 ETH for normal withdraw ---");
  const stake2Tx = await staking.stake({ value: ethers.parseEther("0.003") });
  const stake2Receipt = await stake2Tx.wait();
  console.log("✅ Stake TX Hash:", stake2Receipt.hash);

  // 잠금 기간은 60초이므로 대기
  console.log("Waiting 65 seconds for lock period...");
  await new Promise(r => setTimeout(r, 65000));

  // 5. Normal Withdraw
  console.log("\n--- 5. Normal Withdraw (after lock period) ---");
  const withdrawTx = await staking.withdraw();
  const withdrawReceipt = await withdrawTx.wait();
  console.log("✅ Withdraw TX Hash:", withdrawReceipt.hash);

  // 최종 상태
  const finalStaked = await staking.getStakedBalance(deployer.address);
  const contractBal = await staking.getContractBalance();

  console.log("\n=== FINAL STATE ===");
  console.log("Staked Balance:", ethers.formatEther(finalStaked), "ETH");
  console.log("Contract Balance:", ethers.formatEther(contractBal), "ETH");

  console.log("\n=== SUBMISSION INFO ===");
  console.log("Contract Address:", address);
  console.log("Deployment TX: check on Etherscan");
  console.log("Stake TX Hash:", stakeReceipt.hash);
  console.log("Withdraw TX Hash:", withdrawReceipt.hash);
  console.log("Emergency Withdraw TX Hash:", emergencyReceipt.hash);
  console.log("\nEtherscan:", `https://sepolia.etherscan.io/address/${address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
