// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/// @notice A simple version of the IOsTokenVaultController interface allowing to get exchange ratio with ETH
interface IOsTokenVaultController {
  /**
   * @notice Converts assets to shares
   * @param shares The amount of shares to convert to assets
   * @return assets The amount of assets that the OsToken would exchange for the amount of shares provided
   */
  function convertToAssets(uint256 shares) external view returns (uint256 assets);
}
