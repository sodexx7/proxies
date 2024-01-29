pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract DelegateCallTry3 {
    // If a proxy calls an empty address or an implementation that was previously self-destructed, what happens?
    function delegate(address payable impl) external payable returns (bool) {
        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("testFun()")
        );
        console.log(ok);
        return abi.decode(result, (bool));
    }
}

contract implementation {
    function kill() external payable {
        selfdestruct(payable(address(0x01)));
    }

    function testFun() external returns (bool) {
        return true;
    }
}
