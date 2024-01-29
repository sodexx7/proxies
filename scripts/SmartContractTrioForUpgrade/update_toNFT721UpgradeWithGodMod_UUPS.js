
const { ethers, upgrades } = require("hardhat");


async function main() {

  const nFT721UpgradeUUPsProxyAddress = "0xfAE5D8d886EB743480BE7576F6279602E2413b83";
  const godAddress = "0xaf9cC770475a9A36184124f3ECC023Eb9ee80D2e";
  const NFT721UpgradeWithGodModUUPS = await ethers.getContractFactory("NFT721UpgradeWithGodMod");
  const nFT721UpgradeWithGodModUUPSProxy = await upgrades.upgradeProxy(nFT721UpgradeUUPsProxyAddress,NFT721UpgradeWithGodModUUPS,{call:{fn:'initialize',args:[godAddress]}}, {
      kind:'uups'}); 

  console.log("nFT721UpgradeWithGodModUUPSProxy addresss:", await nFT721UpgradeWithGodModUUPSProxy.getAddress());
  
}

main();