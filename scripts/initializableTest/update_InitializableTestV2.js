// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {

  const proxyAddress ="0x515A101694a3bF58bc8B66E6a58c488D0ce5D29B";
  const InitializableTestV2 = await ethers.getContractFactory("InitializableTestV2");
  const initializableTestV2 = await upgrades.upgradeProxy(proxyAddress,InitializableTestV2,{call:{fn:'initialize',args:[55]}}); 
  await initializableTestV2.waitForDeployment();
  
  console.log("initializableTestV2 addresss:", await initializableTestV2.getAddress());


}

main();