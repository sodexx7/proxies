// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title This contract's token as the StakingContract's ERC20 rewards
 * @dev
 * Only the stakingContract can mint the token.
 * stakingContract should get this contract's ownership before working.
 *
 * Currently, no other consideration that limiting this token's supply
 * @author Tony
 * @notice
 */
contract RewardTokenUpgrade is
    ERC20Upgradeable,
    Ownable2StepUpgradeable,
    UUPSUpgradeable
{
    function initialize() external initializer {
        // init parents contracts
        __ERC20_init("RewardToken", "RT");
        __Ownable_init(msg.sender);
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function mint(address account, uint256 amount) external onlyOwner {
        super._mint(account, amount);
    }
}
