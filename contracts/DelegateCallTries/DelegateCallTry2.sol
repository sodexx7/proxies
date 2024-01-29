pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract DelegateCallTry2 {
    // If a proxy calls an implementation, and the implementation self-destructs in the function that gets called, what happens?

    function delegate(address payable impl) external payable returns (uint256) {
        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("kill()")
        );
        console.log(ok);
        // return abi.decode(result, (uint256));
    }

    function canThisFunWork() external pure returns (bool) {
        return true;
    }
}

contract implementation {
    function kill() external payable {
        selfdestruct(payable(address(0x01)));
    }
}
