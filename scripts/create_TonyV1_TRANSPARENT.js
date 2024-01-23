// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");


async function main() {
  const TonyImplV1 = await ethers.getContractFactory("TonyImplV1");
  const tonyImplV1 = await upgrades.deployProxy(TonyImplV1,[42]); // [42] default using initialize function
  await tonyImplV1.waitForDeployment();
  
  console.log("tonyImplV1 deployed to:", await tonyImplV1.getAddress());
  
}

main();