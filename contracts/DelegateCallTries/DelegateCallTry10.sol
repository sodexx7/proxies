pragma solidity ^0.8.0;

import "hardhat/console.sol";

// If a delegatecall is made to a contract that makes a delegatecall to another contract, who is msg.sender in the proxy, the first contract, and the second contract?

contract DelegateCallTry10 {
    // uint256  test = 123445678911;

    function delegate(address payable impl) external payable {
        console.log("DelegateCallTry10 was called");
        console.log(msg.sender);
        console.log(msg.value);

        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("delegate()")
        );
        require(ok);
        console.log(abi.decode(result, (uint256)));
    }
}

contract A {
    address immutable _b; // there must be as immutable otherwise delegatecakk wiil used the DelegateCallTry10's first slot.

    constructor(address b) {
        _b = b;
    }

    function delegate() external payable returns (uint256) {
        console.log("A was called");
        console.log(msg.sender);
        console.log(msg.value);

        (bool ok, bytes memory result) = _b.delegatecall(
            abi.encodeWithSignature("called()")
        );
        return abi.decode(result, (uint256));
    }
}

contract B {
    function called() external payable {
        console.log("B was called");
        console.log(msg.sender);
        console.log(msg.value);
    }
}
