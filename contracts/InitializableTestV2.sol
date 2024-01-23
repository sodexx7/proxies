// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract InitializableTestV2 is Initializable {

    uint256 _num;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);


    function initialize(uint num) external reinitializer(2) {
        _num = num;
        emit ValueChanged(num);
    }
    
    function addOne() external {
        _num = _num +4;
    }

}