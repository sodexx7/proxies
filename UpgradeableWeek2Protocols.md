## UpgradeableWeek2Protocols:the change points for upgrade contracts

1. [NFT721Upgrade](contracts/SmartContractTrioForUpgrade/NFT721Upgrade.sol)
   1. Convert constructor to initialize, includes parent's constructor function
   2. All import contracts using upgradable version
   3. Dealing variables:
      1. bytes32 public immutable \_merkleRoot; => bytes32 public \_merkleRoot (make the proxy can use it)
   4. Security consideration
      - add below code in the contract, one case can see [Ethernaut Motorbike](https://github.com/sodexx7/proxies/blob/main/Ethernaut.md#L13)
      ```
          /// @custom:oz-upgrades-unsafe-allow constructor
          constructor() {
              _disableInitializers();
          }
      ```
   5. For using UUPs, inherited UUPSUpgradeable. which should implement \_authorizeUpgrade that check only the owner can execute upgrade.
   6. [on-chain code](https://sepolia.etherscan.io/address/0xfAE5D8d886EB743480BE7576F6279602E2413b83#code)
2. [RewardTokenUpgrade](contracts/SmartContractTrioForUpgrade/RewardTokenUpgrade.sol)

   1. Convert constructor to initialize, includes parent's constructor function

   ```
       function initialize() external initializer {
       // init parents contracts
       __ERC20_init("RewardToken", "RT");
       __Ownable_init(msg.sender);
   }
   ```

   2. Security consideration

   ```
           /// @custom:oz-upgrades-unsafe-allow constructor
           constructor() {
               _disableInitializers();
           }
   ```

   5. For using UUPs, inherited UUPSUpgradeable. which should implement \_authorizeUpgrade that check only the owner can execute upgrade.
   6. [on-chain code](https://sepolia.etherscan.io/address/0x02467368e78B5e09B42fe385bBEbC5AAF06b4d90#code)

3. [StakingContractUpgrade](contracts/SmartContractTrioForUpgrade/StakingContractUpgrade.sol)

   1. Inherited Ownable2StepUpgradeable, the previous version didn't add it

   2. The related instance should use upgradeContract, and delete the immutable for proxy usage

   ```
   // staking nft address
   NFT721 immutable _nft1;

   // reward ERC20 Token
   RewardToken immutable _rewardToken;

   ========================>
   // staking nft address
   NFT721Upgrade public _nft1;

   // reward ERC20 Token
   RewardTokenUpgrade public _rewardToken;

   ```

   3. Convert constructor to initialize

   ```
    function initialize(address nft1, address rewardToken) external initializer {
        _nft1 = NFT721Upgrade(nft1);
       _rewardToken = RewardTokenUpgrade(rewardToken);
   }

   ```

   4. Security consideration

   ```
          /// @custom:oz-upgrades-unsafe-allow constructor
          constructor() {
              _disableInitializers();
          }
   ```

   5. For using UUPs, inherited UUPSUpgradeable. which should implement \_authorizeUpgrade that check only the owner can execute upgrade.
   6. [on-chain code](https://sepolia.etherscan.io/address/0x08de053258ac125DA4E5bDdCDC5125672f6C4D23#code)

4. [NFT721UpgradeWithGodMod](contracts/SmartContractTrioForUpgrade/NFT721UpgradeWithGodMod.sol)
   1. add function specificalTransfer
   2. add initialize function, but should use reinitializer and the version should as 2
   ```
        function initialize(address specialAddress) external reinitializer(2) {
        _specialAddress = specialAddress;
       }
   ```
   3. [test-scripts](test/SmartContractTrioForUpgrade/NFT721UpgradeWithGodMod.t.js)
   4. [on-chain code](https://sepolia.etherscan.io/address/0xfAE5D8d886EB743480BE7576F6279602E2413b83#code)
   5. [tx-god-transfer](https://sepolia.etherscan.io/tx/0x2adb4b3eaf5be8a1c4bdfbcf25e8c2faa3ede35e8e0822fa5bee1d6cf9e07014)
