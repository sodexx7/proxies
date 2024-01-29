// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TonyImplV2UUPS is UUPSUpgradeable, OwnableUpgradeable {
    uint256 _num;
    uint256 _num2;
    uint256 _num3;

    function addOne() external {
        _num = _num + 1;
    }

    // for UUPSUpgradeable,ignore the onlyOwner check
    function _authorizeUpgrade(address) internal override {}
}
