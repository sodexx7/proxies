// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TonyImplV1UUPS is Initializable, UUPSUpgradeable {
    uint256 _num;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);

    function initialize(uint num) external initializer {
        _num = num;
        emit ValueChanged(num);
    }

    function retrieve() external view returns (uint256) {
        return _num;
    }

    // for test, ignore the onlyOwner check
    function _authorizeUpgrade(address) internal override {}
}
