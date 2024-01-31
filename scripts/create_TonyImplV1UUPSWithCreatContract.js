// scripts/create-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const TonyImplV1UUPSWithCreatContract = await ethers.getContractFactory(
    "TonyImplV1UUPSWithCreatContract"
  );
  const tonyImplV1UUPSWithCreatContract = await upgrades.deployProxy(
    TonyImplV1UUPSWithCreatContract,
    [42, "0x437C6eAbA704F2f00fD3B9A19C3DdC1F7E96968C"],
    {
      kind: "uups",
    }
  ); // [42] default using initialize function
  await tonyImplV1UUPSWithCreatContract.waitForDeployment();

  console.log(
    "tonyImplV1UUPSWithCreatContract deployed to:",
    await tonyImplV1UUPSWithCreatContract.getAddress()
  );
}

main();
