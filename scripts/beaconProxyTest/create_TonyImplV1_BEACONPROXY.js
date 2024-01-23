// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");


async function main() {
  const TonyImplV1 = await ethers.getContractFactory("TonyImplV1");

  const beacon = await upgrades.deployBeacon(TonyImplV1);
  await beacon.waitForDeployment();
  console.log("Beacon(TonyImplV1) deployed to:", await beacon.getAddress());

  const beaconProxy1 = await upgrades.deployBeaconProxy(beacon, TonyImplV1, [42]);
  await beaconProxy1.waitForDeployment();
  console.log("beaconProxy1 deployed to:", await beaconProxy1.getAddress());


  const beaconProxy2 = await upgrades.deployBeaconProxy(beacon, TonyImplV1, [42]);
  await beaconProxy2.waitForDeployment();
  console.log("beaconProxy2 deployed to:", await beaconProxy2.getAddress());

  
}

main();