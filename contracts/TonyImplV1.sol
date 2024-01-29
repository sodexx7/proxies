// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TonyImplV1 is Initializable {
    uint256 _num;

    // Variable `_num2` is immutable and will be initialized on the implementation
    // uint256 immutable _num2 = 5;
    // Variable `_num3` is assigned an initial value
    // uint256  _num3 = 5;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);

    // constructor is not allowed
    // constructor() payable {
    //     _num = 3;
    // }

    // Use of selfdestruct is not allowed
    // function riskOperation() external {
    //     selfdestruct(payable(address(0x09999)));

    // }

    // Use of delegatecall is not allowed
    // function delegate(address impl) external returns(uint256) {
    //     (bool ok, bytes memory result) = impl.delegatecall(abi.encodeWithSignature("data()"));
    //     return abi.decode(result, (uint256));
    // }

    function initialize(uint num) external initializer {
        _num = num;
        emit ValueChanged(num);
    }

    function retrieve() external view returns (uint256) {
        return _num;
    }
}
