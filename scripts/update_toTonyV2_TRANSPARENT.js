// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplV2 = await ethers.getContractFactory("TonyImplV2");
  const tonyImplV2 = await upgrades.upgradeProxy("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512", TonyImplV2);
  console.log("TonyImplV1  upgrade to TonyImplV2",tonyImplV2);
}

main();