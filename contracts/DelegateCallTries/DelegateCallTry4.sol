pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "hardhat/console.sol";

// If a user calls a proxy makes a delegatecall to A, and A makes a regular call to B,
// from A's perspective, who is msg.sender? from B's perspective, who is msg.sender?
// From the proxy's perspective, who is msg.sender?

contract DelegateCallTry4 {
    function delegate(address payable impl) external payable {
        console.log("One user call");
        console.log(msg.sender);
        console.log(msg.value);

        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("normalCalB()")
        );
        require(ok);
    }
}

contract A {
    B immutable _b;

    constructor(B b) {
        _b = b;
    }

    function normalCalB() external payable {
        console.log("A was called by delegateCall");
        console.log(msg.sender);
        console.log(msg.value);
        _b.called();
    }
}

contract B {
    function called() external payable {
        console.log("B was called");
        console.log(msg.sender);
        console.log(msg.value);
    }
}
