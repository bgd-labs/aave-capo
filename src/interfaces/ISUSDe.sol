// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the ISUSDe interface allowing to get exchange ratio with USDe
interface ISUSDe {
  /**
   * @return The amount of USDe that corresponds to token shares.
   */
  function convertToAssets(uint256) external view returns (uint256);
}
