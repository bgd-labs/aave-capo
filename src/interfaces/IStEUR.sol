// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the IStEUR interface allowing to get exchange ratio with agEUR
interface IStEUR {
  /**
   * @return The amount of agEUR that corresponds to token shares.
   */
  function convertToAssets(uint256) external view returns (uint256);
}
