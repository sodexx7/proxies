# PROXY RELATED QUESTIONS

### 1. The OZ upgrade tool for hardhat defends against 6 kinds of mistakes. What are they and why do they matter?

The OZ upgrade tool for hardhat includes two steps: deployProxy and upgradeProxy. Different proxy have some slightly differences when deploying and updating but the core procession are same.

While deploying proxy, involving below points
* Validate implementation contract.  This includes below checks against some mistakes

1. **Don't use constructor, should use initialize.**

    * constructor's code of implementation contract never can be used by the proxy contract, because constructor can only be executed once and it's the not the runtime code, which means the code can't be used by the proxy contract. But if want to achieve the same goal: init some params while deploying, can build one regular function and can only be executed once, openzeppelin's Initializable can help build this.
    * [the-constructor-caveat](https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies#the-constructor-caveat)
    

2. **state-variable-assignment**
    * Setting one variable's value like initing the variable's value in the constructor, So as point 1 shows, this don't work for proxy address
    * [avoid-initial-values-in-field-declarations](https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#avoid-initial-values-in-field-declarations)

3. **state-variable-immutable check**
    * immutable variable  either should be initialized inline or in the constructor, initing its value in the constructor doesn't work for proxy address.
    * [why-cant-i-use-immutable-variables](https://docs.openzeppelin.com/upgrades-plugins/1.x/faq#why-cant-i-use-immutable-variables)

4. **delegatecall** 
5. **selfdestruct**
    * Above operations will bring potential security problems, such as if hacker can execute the selfdestruct, the corrospending's contract will removed, and call delegateCall can take on arbitrary malicious code.

While updating proxy, involving below points
* Validate new implementation contract also check the contract is safe like above

6. **storage layout of the new implementation contract should compatible with old one**

    * The cases including changig the storage layout, changing the previous slot type, renaming are all disallowed, the only accept change is to add the new storage after old storage layout.



5. ？？？ new implementation 

TransparentProxy
1. constructor check realted file
2. initiable only execute once


should consider differnt proxy pattern
3. security check list
    1. implementation contract: initialize
    2. storage collsion check
    3. funciton clashes

    if is uups 
    1. check: Implementation is missing a public `upgradeTo(address)` or `upgradeToAndCall(address,bytes)` function

q
    1. not check initialize can be executed only one time.


### 2. What is a beacon proxy used for?


### 3. Why does the openzeppelin upgradeable tool insert something like uint256[50] private __gap; inside the contracts? To see it, create an upgradeable smart contract that has a parent contract and look in the parent.


### 4.  What is the difference between initializing the proxy and initializing the implementation? Do you need to do both? When do they need to be done?


### 5. What is the use for the reinitializer? Provide a minimal example of proper use in Solidity?

