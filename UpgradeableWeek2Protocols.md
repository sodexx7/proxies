## UpgradeableWeek2Protocols the change points for upgrade contracts

1. [NFT721Upgrade](contracts/SmartContractTrioForUpgrade/NFT721Upgrade.sol)
    1. Convert constructor  to initialize, includes parent's constructor function
    2. All import contracts using upgradable version
    3. Dealing variables:
        1. bytes32 public immutable _merkleRoot; =>  bytes32 public _merkleRoot (make the proxy can use it)
    4. Security consideration
        * add below code in the contract, one case can see [Ethernaut Motorbike](https://github.com/sodexx7/proxies/blob/main/Ethernaut.md#L13)
        ```
            /// @custom:oz-upgrades-unsafe-allow constructor
            constructor() {
                _disableInitializers();
            }
        ```
    5. For using UUPs, inherited UUPSUpgradeable. which should implement _authorizeUpgrade that check only the owner can execute upgrade.
    6. [on-chain code](https://sepolia.etherscan.io/address/0xFa8ddE57D262aE9a65D3BAbD7e57187F4804818c#code)
2. [RewardTokenUpgrade](contracts/SmartContractTrioForUpgrade/RewardTokenUpgrade.sol)
    1.  Convert constructor  to initialize, includes parent's constructor function
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
    5. For using UUPs, inherited UUPSUpgradeable. which should implement _authorizeUpgrade that check only the owner can execute upgrade.
    6. [on-chain code](https://sepolia.etherscan.io/address/0x02467368e78B5e09B42fe385bBEbC5AAF06b4d90#code)

3. [StakingContractUpgrade](contracts/SmartContractTrioForUpgrade/StakingContractUpgrade.sol)
    0. Inherited Ownable2StepUpgradeable, the previous version didn't add it
    1. The related instance should use upgradeContract, and delete the immutable for proxy usage
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
    2. Convert constructor to initialize
    ```
     function initialize(address nft1, address rewardToken) external initializer {
         _nft1 = NFT721Upgrade(nft1);
        _rewardToken = RewardTokenUpgrade(rewardToken);
    }
    
    ```
    3. Security consideration
     ```
            /// @custom:oz-upgrades-unsafe-allow constructor
            constructor() {
                _disableInitializers();
            }
    ```
    4. For using UUPs, inherited UUPSUpgradeable. which should implement _authorizeUpgrade that check only the owner can execute upgrade.
    5. [on-chain code](https://sepolia.etherscan.io/address/0x08de053258ac125DA4E5bDdCDC5125672f6C4D23#code)


