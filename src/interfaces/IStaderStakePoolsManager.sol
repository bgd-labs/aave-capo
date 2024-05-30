// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the StaderStakePoolsManager interface allowing to get exchange ratio with ETH
interface IStaderStakePoolsManager {
  /**
   * @return the current exchange ratio of the ETHx to Eth
   */
  function getExchangeRate() external view returns (uint256);
}
