const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "ETH");

  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy({ value: hre.ethers.parseEther("0.01") });
  await faucet.waitForDeployment();

  const address = await faucet.getAddress();
  console.log("Faucet deployed to:", address);
  console.log("Faucet balance:", hre.ethers.formatEther(await hre.ethers.provider.getBalance(address)), "ETH");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
