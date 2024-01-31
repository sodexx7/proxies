// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TonyImplV1UUPSWithCreatContract is
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    uint256 _num;

    // Emitted when the stored value changes
    event ValueChanged(uint256 value);

    function initialize(uint num, address testAddress) external initializer {
        // Initialize inheritance chain
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        _num = num;

        transferOwnership(address(new newContract(testAddress)));

        emit ValueChanged(num);
    }

    // for test, ignore the onlyOwner check
    function _authorizeUpgrade(address) internal override {}
}

contract newContract {
    event newCreateContract(address _address);
    address public _address;

    constructor(address testAaddress) {
        _address = testAaddress;
        emit newCreateContract(testAaddress);
    }
}
