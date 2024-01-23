
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplWithParentContractV2 = await ethers.getContractFactory("TonyImplWithParentContractV2");
  await upgrades.validateUpgrade("0x08de053258ac125DA4E5bDdCDC5125672f6C4D23",TonyImplWithParentContractV2, {
    kind:'transparent'});
  
}

main();