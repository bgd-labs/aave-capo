// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the StaderStakePoolsManager interface allowing to get exchange ratio with ETH
interface IwBETH {
  /**
   * @return the current exchange ratio of the ETHX to the ETH
   */
  function exchangeRate() external view returns (uint256);
}
