// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplV1UUPS = await ethers.getContractFactory("TonyImplV1UUPS");
  const tonyImplV1UUPS = await upgrades.deployProxy(TonyImplV1UUPS, [42], {
    kind: "uups",
  }); // [42] default using initialize function
  await tonyImplV1UUPS.waitForDeployment();

  console.log("tonyImplV1UUPS deployed to:", await tonyImplV1UUPS.getAddress());
}

main();
