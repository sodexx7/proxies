// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");


async function main() {
  const InitializableTestV1 = await ethers.getContractFactory("InitializableTestV1");
  const initializableTestV1 = await upgrades.deployProxy(InitializableTestV1,[42]); 
  await initializableTestV1.waitForDeployment();
  
  console.log("initializableTestV1 deployed to:", await initializableTestV1.getAddress());
  
}

main();