// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplWithParentContractV2 = await ethers.getContractFactory("TonyImplWithParentContractV2");
  const tonyImplWithParentContractV2 = await upgrades.upgradeProxy("0xB21187714b852FA595739BADF25999559F1E466b", TonyImplWithParentContractV2);
  console.log("tonyImplWithParentContractV1  upgrade to tonyImplWithParentContractV2",await tonyImplWithParentContractV2.getAddress());

}

main();