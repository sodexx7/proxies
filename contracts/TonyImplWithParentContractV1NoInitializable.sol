// SPDX-License-Identifier: None

pragma solidity ^0.8.0;


contract ParentContractTest {
    uint256 parentestNumV1;
    uint256 parentestNumV2;
    //if add new slot(parentestNumV3), the TonyImplWithParentContractV1NoInitializable's slots will change as below, breaking the storage layout
    //        old storaglayout   new storaglayout
    // slot0: parentestNumV1      parentestNumV1  
    // slot1: parentestNumV2      parentestNumV2
    // slot2: _num                parentestNumV3  
    // slot3:                     _num  
    uint256 parentestNumV3;   

}
contract TonyImplWithParentContractV1NoInitializable is ParentContractTest {

    uint256 _num;


    // Emitted when the stored value changes
    event ValueChanged(uint256 value);


    function initialize(uint num) external {
        _num = num;
        emit ValueChanged(num);
    }
    
    function retrieve() view external returns(uint256){
        return _num;
    }

}