// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplWithParentContractV1NoInitializable = await ethers.getContractFactory("TonyImplWithParentContractV1NoInitializable");
  const tonyImplWithParentContractV1NoInitializable = await upgrades.deployProxy(TonyImplWithParentContractV1NoInitializable,[42]); // [42] default using initialize function
  await tonyImplWithParentContractV1NoInitializable.waitForDeployment();
  
  console.log("tonyImplWithParentContractV1NoInitializable deployed to:", await tonyImplWithParentContractV1NoInitializable.getAddress());

}

main();