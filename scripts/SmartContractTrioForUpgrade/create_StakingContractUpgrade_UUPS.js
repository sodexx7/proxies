
const { ethers, upgrades } = require("hardhat");


async function main() {
  const nft1ProxyAddress = "0xfAE5D8d886EB743480BE7576F6279602E2413b83";
  const rewardTokenProxyAddress = "0x02467368e78B5e09B42fe385bBEbC5AAF06b4d90";
  const StakingContractUpgrade = await ethers.getContractFactory("StakingContractUpgrade");
  const stakingContractUpgradeUUPS = await upgrades.deployProxy(StakingContractUpgrade,[nft1ProxyAddress,rewardTokenProxyAddress],{
    kind:'uups'}); 
  await stakingContractUpgradeUUPS.waitForDeployment();
  
  console.log("stakingContractUpgradeUUPS deployed to:", await stakingContractUpgradeUUPS.getAddress());
  
}

main();