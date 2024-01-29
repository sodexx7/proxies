const { expect } = require("chai");


describe("TonyImplV1", function() {

  it('TonyImplV1 deployProxyTest', async () => {
    const TonyImplV1 = await ethers.getContractFactory("TonyImplV1");
    const tonyImplV1Proxy = await upgrades.deployProxy(TonyImplV1,[42]); // [42] default using initialize function
    const value = await tonyImplV1Proxy.retrieve();
    expect(value.toString()).to.equal('42');
 
  });

  it('TonyImplV1 update to TonyImplV2', async () => {
    const TonyImplV1 = await ethers.getContractFactory("TonyImplV1");
    const tonyImplV1Proxy = await upgrades.deployProxy(TonyImplV1,[42]); // [42] default using initialize function
  
    const value = await tonyImplV1Proxy.retrieve();
    expect(value.toString()).to.equal('42');

    
    const TonyImplV2 = await ethers.getContractFactory("TonyImplV2");
    const tonyImplV2Proxy = await upgrades.upgradeProxy(await tonyImplV1Proxy.getAddress(), TonyImplV2);
    await tonyImplV2Proxy.addOne();

    const newValue = await tonyImplV2Proxy.retrieve();
    expect(newValue.toString()).to.equal('43');
 
  });
});