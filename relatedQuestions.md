# PROXY RELATED QUESTIONS

### 1. The OZ upgrade tool for hardhat defends against 6 kinds of mistakes. What are they and why do they matter?

The OZ upgrade tool for hardhat includes two steps: deployProxy and upgradeProxy. Different proxy have some slightly differences when deploying and updating but the core procession are same.

While deploying proxy, involving below points
* Validate implementation contract.  This includes below checks against some mistakes

1. **Don't use constructor, should use initialize.**

    * constructor's code of implementation contract never can be used by the proxy contract, because constructor can only be executed once and it's the not the runtime code, which means the code can't be used by the proxy contract. But if want to achieve the same goal: init some params while deploying, can build one regular function and can only be executed once, openzeppelin's Initializable can help build this.
    * [the-constructor-caveat](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#the-constructor-caveat)
    * [code](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV1.sol#L20)

2. **state-variable-assignment**
    * Setting one variable's value like initing the variable's value in the constructor, So as point 1 shows, this don't work for proxy address
    * [avoid-initial-values-in-field-declarations](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#avoid-initial-values-in-field-declarations)
    * [code](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV1.sol#L14)

3. **state-variable-immutable check**
    * immutable variable  either should be initialized inline or in the constructor, initing its value in the constructor doesn't work for proxy address.
    * [why-cant-i-use-immutable-variables](https://docs.openzeppelin.com/upgrades-plugins/1.x/faq#why-cant-i-use-immutable-variables)
    * [code](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV1.sol#L12)

4. **delegatecall** 
5. **selfdestruct**
    * Above operations will bring potential security problems, such as if hacker can execute the selfdestruct, the corrospending's contract will removed, and call delegateCall can take on arbitrary malicious code.
    * [selfdestruct](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV1.sol#L25)
    * [delegatecall](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV1.sol#L31)

While updating proxy, involving below points
* Validate new implementation contract also check the contract is safe like above and includes below

6. **storage layout of the new implementation contract should compatible with old one**

    * The cases including changig the storage layout, changing the previous slot type, renaming are all disallowed, which will break the storage layout of the proxy address, no matter how implementation contract chaning, must keep the consistant of storage layout of the proxy address.
     the only accept change is to add the new slots after old storage layout.
    * [code](https://github.com/sodexx7/proxies/blob/main/contracts/TonyImplV2.sol#L11)

### 2. What is a beacon proxy used for?
* For Beacon proxy type, beside the proxy and implement contract, there exists the Beacon contract storing the implementation contract address, and all proxies points to beacon contract. Comparing Transparent and UUPs, number of beacon proxies can be upgraded atomically at the same time by upgrading the beacon that they point to.
* Sometimes need to deplpy many same contracts at the same times, as deploying many  [ERC-1167 Minimal Clones](https://www.rareskills.io/post/eip-1167-minimal-proxy-standard-with-initialization-clone-pattern) or [ERC-3448 Metaproxy](https://www.rareskills.io/post/erc-3448-metaproxy-clone). For this situation can apply beacon proxy to deploy many clones contract, advantanges: 1) deploy many clones at the sametime 2) save gas for deploying and executing.  THIS should check, ERC-1167 Minimal Clones can be used for beacon proxy?



### 3. Why does the openzeppelin upgradeable tool insert something like uint256[50] private __gap; inside the contracts? To see it, create an upgradeable smart contract that has a parent contract and look in the parent.

* Because when updating the implementation contract which inherited one parent contract, as we know, the new implementation contract storage layout should compitable with the old, but if changed the  parent contract, such as adding new slot in parent contract which will leads confliction between old implementation contract and new implementation contract.
```solidity
contract ParentContractTest {
    uint256 parentestNumV1;
    uint256 parentestNumV2;
    //if add new slot(parentestNumV3), the TonyImplWithParentContractV1NoInitializable's slots will change as below, breaking the storage layout
    //        old storaglayout   new storaglayout
    // slot0: parentestNumV1      parentestNumV1  
    // slot1: parentestNumV2      parentestNumV2
    // slot2: _num                parentestNumV3  
    // slot3:                     _num  
    uint256 parentestNumV3;   

}
contract TonyImplWithParentContractV1NoInitializable is ParentContractTest {

    uint256 _num;


    // Emitted when the stored value changes
    event ValueChanged(uint256 value);
.....

```
* adding code like this `uint256[50] private __gap`, which main enough slots for future changes. But for now, seems It's recommended using Namespaced Storage Layout [EIP-7201](https://eips.ethereum.org/EIPS/eip-7201)
* todo check https://eips.ethereum.org/EIPS/eip-7201,  OpenZepllin[Initializable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/a5c4cd8182103aa96c2147433bf1bfb8fde63ca9/contracts/proxy/utils/Initializable.sol#L63) have used the EIP7201.


### 4.  What is the difference between initializing the proxy and initializing the implementation? Do you need to do both? When do they need to be done?
(TODO CHECK)
* Initializing the proxy will set the initial params which was used by the proxy contract, the core params includes the owner of the proxy, set the implementation contract address. Initializing the implementation I think the initial params were based on the implementation contract, generally, there are no relationships between these params and proxy contract. the states in the implementation can ignored.

* For the Transparent or UUPS, just initializing the proxy. No need initializing the implementation. One specifical case is beaconProxy, should initializing the beacon which should set the implementation contract address. 
   
* Firstly, should deploy the implementation contract, then deploy the proxy and initializing the proxy by delegatcall the implementation contract.


### 5. What is the use for the reinitializer? Provide a minimal example of proper use in Solidity?

* This involves the upgrade contracts, It's very often to need one function should only be called once when using proxy, which sets the init value for the proxy and can't change. as below `initialize` only be called once. 
```
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
contract InitializableTestV1 is Initializable {

    uint256 _num;

    function initialize(uint num) external initializer {
        _num = num;
        emit ValueChanged(num);
    }

}
```
* reinitializer is for the demand that set the init param again. user can change the init param again when deploying new implementation contract.

```
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
contract InitializableTestV2 is Initializable {

    uint256 _num;

    function initialize(uint num) external reinitializer(2) {
        _num = num;
        emit ValueChanged(num);
    }
```
* Demo code
    * [InitializableTestV1](contracts/InitializableTestV1.sol), this implementation contract  num =42 [version=1](https://goerli.etherscan.io/tx/0x9faf8eb65a0f95c0a6a2309e34e1e1ee4f2b385123b09e9723e53b99a884990b#eventlog)
    * [InitializableTestV2](contracts/InitializableTestV2.sol), this implementation contract  num =55 [version=2](https://goerli.etherscan.io/tx/0x4828afc6df22421f43c04d1f011ee0e6b69f1244a482df80eb712685e4db7a71#eventlog)
* [reinitializer](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/096fb04d46b093aa2bd5d63af8b952ad4ca39875/contracts/proxy/utils/Initializable.sol#L152)
