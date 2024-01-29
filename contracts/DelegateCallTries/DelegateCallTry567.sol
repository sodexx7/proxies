pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "hardhat/console.sol";

// If a proxy makes a delegatecall to A, and A does address(this).balance, whose balance is returned, the proxy's or A?

// If a proxy makes a delegatecall to A, and A calls codesize, is codesize the size of the proxy or A?

// If a delegatecall is made to a function that reverts, what does the delegatecall do?

contract DelegateCallTry5And6 {
    function delegate(address payable impl) external payable {
        (bool ok, bytes memory result) = impl.delegatecall(
            abi.encodeWithSignature("callRevert()")
        );
        require(ok);
        console.logBytes(result);
    }

    constructor() payable {}

    function checkCodeSize() external pure {
        uint size;
        assembly {
            size := codesize()
        }

        console.log(size);
    }
}

contract A {
    function checkBalance() external view {
        console.log(address(this).balance);
    }

    function checkCodeSize() external pure {
        uint size;
        assembly {
            size := codesize()
        }

        console.log(size);
    }

    function callRevert() external pure {
        revert("Test");
    }
}
