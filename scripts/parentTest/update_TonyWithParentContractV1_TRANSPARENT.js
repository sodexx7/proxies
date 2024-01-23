// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplWithParentContractV1 = await ethers.getContractFactory("TonyImplWithParentContractV1");
  const tonyImplWithParentContractV1 = await upgrades.upgradeProxy("0xB21187714b852FA595739BADF25999559F1E466b", TonyImplWithParentContractV1);
  console.log("tonyImplWithParentContractV1  upgrade to tonyImplWithParentContractV2",await tonyImplWithParentContractV1.getAddress());

}

main();