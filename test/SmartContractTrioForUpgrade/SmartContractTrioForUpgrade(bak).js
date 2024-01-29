const { expect } = require("chai");

const { ethers, upgrades } = require("hardhat");


    
describe('GodModTest', () => {

    let rewardTokenUpgradeUUPSProxy,
    nFT721UpgradeUUPsProxy,
    stakingContractUpgradeUUPSProxy,
    nFT721UpgradeUUPsProxyAddress,
    nFT721UpgradeWithGodModProxy,
    owner,
    addr1,
    addr2,
    godAddress;


    before(async () => {

        [owner, addr1, addr2,god] = await ethers.getSigners();

        const RewardTokenUpgrade = await ethers.getContractFactory("RewardTokenUpgrade");
        rewardTokenUpgradeUUPSProxy = await upgrades.deployProxy(RewardTokenUpgrade, {
            kind:'uups'}); 
        
        const NFT721Upgrade = await ethers.getContractFactory("NFT721Upgrade");
        nFT721UpgradeUUPsProxy = await upgrades.deployProxy(NFT721Upgrade,["0x5a62e056db9887c17d8ded5d939c167f0aab07ac728c32753b86ca0ffa0b3362"], {
            kind:'uups'}); 
        
        godAddress =  await god.getAddress();
        // const NFT721UpgradeWithGodMod = await ethers.getContractFactory("NFT721UpgradeWithGodMod");
        // nFT721UpgradeWithGodModProxy = await upgrades.deployProxy(NFT721UpgradeWithGodMod,[godAddress], {
        //     kind:'uups'}); 
        
        // const rewardTokenUpgradeUUPSProxyAddress =  await rewardTokenUpgradeUUPSProxy.getAddress(); 
        nFT721UpgradeUUPsProxyAddress =  await nFT721UpgradeUUPsProxy.getAddress();   
        // console.log("rewardTokenUpgradeUUPSProxyAddress",rewardTokenUpgradeUUPSProxyAddress);
        // console.log("nFT721UpgradeUUPsProxyAddress",nFT721UpgradeUUPsProxyAddress); 

        // const StakingContractUpgrade = await ethers.getContractFactory("StakingContractUpgrade");
        // stakingContractUpgradeUUPSProxy = await upgrades.deployProxy(StakingContractUpgrade,[nFT721UpgradeUUPsProxyAddress,rewardTokenUpgradeUUPSProxyAddress],{
        //     kind:'uups'}); 

          
        // const stakingContractUpgradeUUPSProxyAddress = await stakingContractUpgradeUUPSProxy.getAddress();
        // console.log("stakingContractUpgradeUUPSProxyAddress",stakingContractUpgradeUUPSProxyAddress); 
        
        // stakingContract will control the rewardToken(Ownable2Step)
        // await rewardTokenUpgradeUUPSProxy.transferOwnership(stakingContractUpgradeUUPSProxyAddress);
        
        // await stakingContractUpgradeUUPSProxy.connect(stakingContractUpgradeUUPSProxyAddress).acceptOwnership();    not work todo check
    });


    // it('Mint Test', async () => {
    //     await nFT721UpgradeUUPsProxy.connect(addr1).mintNft({value:ethers.parseEther("0.1")});

    //     const tokenId =  await nFT721UpgradeUUPsProxy.balanceOf(addr1);

    //     console.log("tokenId",tokenId);

    // });

    it('NFT721UpgradeWithGodMod Test', async () => {

        // old version mint nft
        await nFT721UpgradeUUPsProxy.connect(addr1).mintNft({value:ethers.parseEther("0.1")});

        const tokenId =  await nFT721UpgradeUUPsProxy.balanceOf(addr1);

        console.log("tokenId",tokenId);

        // new implementation, godAddress transfer nft
        const NFT721UpgradeWithGodModUUPS = await ethers.getContractFactory("NFT721UpgradeWithGodMod");
        const nFT721UpgradeWithGodModUUPSProxy = await upgrades.upgradeProxy(nFT721UpgradeUUPsProxyAddress,NFT721UpgradeWithGodModUUPS,{call:{fn:'initialize',args:[godAddress]}}, {
            kind:'uups'}); 
        

        await nFT721UpgradeWithGodModUUPSProxy.connect(god).specificalTransfer(addr1,addr2,tokenId);

        const tokenId2 =  await nFT721UpgradeUUPsProxy.balanceOf(addr2);
        expect(tokenId).to.equal(tokenId2);
          

    });

   

});

	