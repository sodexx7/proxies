
const { ethers, upgrades } = require("hardhat");


async function main() {
  const RewardTokenUpgrade = await ethers.getContractFactory("RewardTokenUpgrade");
  const rewardTokenUpgradeUUPS = await upgrades.deployProxy(RewardTokenUpgrade, {
    kind:'uups'}); 
  await rewardTokenUpgradeUUPS.waitForDeployment();
  
  console.log("rewardTokenUpgradeUUPS deployed to:", await rewardTokenUpgradeUUPS.getAddress());
  
}

main();