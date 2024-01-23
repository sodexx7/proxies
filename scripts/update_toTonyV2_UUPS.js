// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");


async function main() {
  const proxyAddress ="0x8bF2C97C639C5e420Ef570bF5F005b6d52B7b875";
  const TonyImplV2UUPS = await ethers.getContractFactory("TonyImplV2UUPS");
  const tonyImplV2UUPSProxy = await upgrades.upgradeProxy(proxyAddress,TonyImplV2UUPS, {
    kind:'uups'}); 
  await tonyImplV2UUPSProxy.waitForDeployment();
  
  console.log("tonyImplV2UUPSProxy addresss:", await tonyImplV2UUPSProxy.getAddress());
  
}

main();