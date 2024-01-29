pragma solidity ^0.8.0;

import "hardhat/console.sol";

// If a delegatecall is made to a function that reads from an immutable variable, what will the value be?

contract DelegateCallTry9 {
    // uint256  test = 123445678911;

    function delegate(address payable impl) external payable {
        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("getImmutableVal()")
        );
        require(ok);
        console.log(abi.decode(result, (uint256)));
    }
}

contract A {
    uint256 immutable test = 1234456789;

    function getImmutableVal() external returns (uint256) {
        return test;
    }
}
