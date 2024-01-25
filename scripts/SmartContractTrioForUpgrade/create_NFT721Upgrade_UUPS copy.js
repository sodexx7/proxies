
const { ethers, upgrades } = require("hardhat");


async function main() {
  const NFT721Upgrade = await ethers.getContractFactory("NFT721Upgrade");
  const nFT721UpgradeUUPs = await upgrades.deployProxy(NFT721Upgrade,["0x5a62e056db9887c17d8ded5d939c167f0aab07ac728c32753b86ca0ffa0b3362"], {
    kind:'uups'}); 
  await nFT721UpgradeUUPs.waitForDeployment();
  
  console.log("nFT721UpgradeUUPs deployed to:", await nFT721UpgradeUUPs.getAddress());
  
}

main();