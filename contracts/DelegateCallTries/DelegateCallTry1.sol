pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract DelegateCallTry1 {
    address _implementationAddress;

    // When a contract calls another call via call, delegatecall, or staticcall,
    // how is information passed between them? Where is this data stored?

    // one way
    function callB(
        address payable b_address,
        uint num
    ) external payable returns (uint256) {
        (bool ok, bytes memory result) = b_address.delegatecall(
            abi.encodeWithSignature("calledByParams(uint256)", num)
        );
        require(ok);
        return abi.decode(result, (uint256));
    }

    // another way
    fallback() external payable {
        address implementation = _implementationAddress;
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}

    function setTempImplementation(address implementsAddress) external {
        _implementationAddress = implementsAddress;
    }
}

contract AByCALL {
    function callB(address b_address) external payable returns (uint256) {
        (bool ok, bytes memory result) = b_address.call{
            value: 500000000000000000
        }(abi.encodeWithSignature("called()"));
        require(ok);
        return abi.decode(result, (uint256));
    }

    function callBByAssembly(
        address b_address
    ) external payable returns (uint256) {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := call(
                gas(),
                b_address,
                500000000000000000,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}

contract AByStaticCall {
    address _implementationAddress;

    function callB(address b_address) external view returns (uint256) {
        (bool ok, bytes memory result) = b_address.staticcall(
            abi.encodeWithSignature("called()")
        );
        require(ok);
        return abi.decode(result, (uint256));
    }

    function callBByAssembly(
        address b_address
    ) external view returns (uint256) {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := staticcall(gas(), b_address, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    fallback() external {
        address implementation = _implementationAddress;
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := staticcall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    function setTempImplementation(address implementsAddress) external {
        _implementationAddress = implementsAddress;
    }
}

contract B {
    event whoAmI(address);
    event howMuchIHave(uint256);

    function called() external payable returns (uint256) {
        emit whoAmI(msg.sender);
        emit howMuchIHave(msg.value);
        return 1;
    }

    function calledByParams(uint256 _num) external payable returns (uint256) {
        return 100;
    }

    constructor() payable {}
}
