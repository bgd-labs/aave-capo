// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the IWeEth interface allowing to get exchange ratio with eETH
interface IWeEth {
  /**
   * @return the current exchange ratio of the weETH to the eEth
   */
  function getRate() external view returns (uint256);
}
