// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TonyImplV2 is Initializable {
    // Error: New storage layout is incompatible
    // New variables should be placed after all existing inherited variables
    // address testAddress;

    uint256 _num;
    uint256 _num1;
    uint256 _num2;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);

    function initialize(uint num) external initializer {
        _num = num;
        emit ValueChanged(num);
    }

    function retrieve() external view returns (uint256) {
        return _num;
    }

    function addOne() external {
        _num = _num + 1;
    }
}
