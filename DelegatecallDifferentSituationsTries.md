### 1. When a contract calls another call via call, delegatecall, or staticcall, how is information passed between them? Where is this data stored?
* how is information passed between them
    ```
    delegateCall:
        EOA=>contractA => contractB
        
        contractA: 
            EOA     msg.sender
                    msg.value
        contractB: 

            EOA         msg.sender
                        msg.value


    call:
        EOA=>contractA => contractB
        
        contractA: 
            EOA     msg.sender
                    msg.value

        contractB: 

            contractA   msg.sender
                        msg.value

    staticcall
        EOA=>contractA => contractB
        
        contractA: 
            EOA     msg.sender
                    msg.value

        contractB: 

            can't get the msg.sender and msg.value
    
    ```
* how data stored?

    * For delegatecall(solidity built-in function), based on the used memory in my demo code, 
        * calldata 0x80 store calldata length; the following memory: store the actual data.
        * for the return data(based on used memory): return data: first word in memory: length. following: actual data
        ```
        // calldata
        0x80: 24
        0xa0:  function signaure
        0xb0: params


        // return data
        0xe0: 0x20
        0x100: actual data
        ```
        *If using delegatecall in YUI. for example the proxy.sol of openzepplin which will use the memory beginning from 0x00.
        
    * Call/staticcall: how to manipuate the data in memory should as delegatecall(solidity built-in function). 
* [code-try](contracts/DelegateCallTries/DelegateCallTry1.sol)

### 2. If a proxy calls an implementation, and the implementation self-destructs in the function that gets called, what happens?

* proxy contract will be deleted.
* [code-try](contracts/DelegateCallTries/DelegateCallTry2.sol)


### 3. If a proxy calls an empty address or an implementation that was previously self-destructed, what happens?

* an account with no code will return success as true.
* [code-try](contracts/DelegateCallTries/DelegateCallTry3.sol)

### 4.  If a user calls a proxy makes a delegatecall to A, and A makes a regular call to B, from A's perspective, who is msg.sender? from B's perspective, who is msg.sender? From the proxy's perspective, who is msg.sender?

* from A's perspective, who is msg.sender? the user, not the proxy.
* from B's perspective, who is msg.sender?  the proxy, using delegateCall ,current context is proxy, then cal A, the msg.sender still is the proxy
*  From the proxy's perspective, who is msg.sender?  the user
* [code-try](contracts/DelegateCallTries/DelegateCallTry4.sol)

### 5. If a proxy makes a delegatecall to A, and A does address(this).balance, whose balance is returned, the proxy's or A?

* proxy' balance, as current context is proxy.
* [code-try](contracts/DelegateCallTries/DelegateCallTry567.sol)

### 6 If a proxy makes a delegatecall to A, and A calls codesize, is codesize the size of the proxy or A?

* proxy' codesie, as current context is proxy.
* [code-try](contracts/DelegateCallTries/DelegateCallTry567.sol)


### 7 If a delegatecall is made to a function that reverts, what does the delegatecall do?
* also reverts. The actually return data as below
    return false and error info
    return error info. 
```
    0x08c379a0                                                                  Error(string)               
    0000000000000000000000000000000000000000000000000000000000000020            //
    0000000000000000000000000000000000000000000000000000000000000004            // the error data  54657374
    5465737400000000000000000000000000000000000000000000000000000000            // 


```
* [code-try](contracts/DelegateCallTries/DelegateCallTry567.sol)
    
### 8 Under what conditions does the Openzeppelin Proxy.sol overwrite the free memory pointer? Why is it safe to do this?

* the free memory pointer is 0X40, and the initial corrospending's memory location is 0x80.

When the calldatasize is no less than 0x40, in this situation, copying the calldata to the memory beginning from 0x00 and covering the 0x40 but no other places have the need dealing with the free memory pointer and its corrospending's memory location when using the proxy's delegatecall function.

```
let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

```

### 9 If a delegatecall is made to a function that reads from an immutable variable, what will the value be?

* return the implementation contract's varibale, as make the varibale as immutable which is part of the implementation contract's code, so just the immutable variable. Comparing this, if delete immutable, will return the proxy's corrospending's value.
* [code-try](contracts/DelegateCallTries/DelegateCallTry9.sol)


### 10 If a delegatecall is made to a contract that makes a delegatecall to another contract, who is msg.sender in the proxy, the first contract, and the second contract?

* The msg.sender should as the same caller for all these contract. the caller is who delegatecall the first contract.
* [code-try](contracts/DelegateCallTries/DelegateCallTry10.sol)

