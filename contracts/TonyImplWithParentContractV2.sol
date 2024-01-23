// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "./ParentContract2.sol";

contract TonyImplWithParentContractV2 is ParentContract2,Initializable {

    uint256 _num;
    uint256 _num2;
    uint256 _num3;


    // Emitted when the stored value changes
    event ValueChanged(uint256 value);


    function initialize(uint num) external initializer {
        _num = num;
        emit ValueChanged(num);
    }
    
    function retrieve() view external returns(uint256){
        return _num;
    }

}