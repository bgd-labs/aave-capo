// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the ISAvax interface allowing to get exchange ratio with AVAX
interface ISAvax {
  /**
   * @return The amount of AVAX that corresponds to `shareAmount` token shares.
   */
  function getPooledAvaxByShares(uint256 shareAmount) external view returns (uint256);
}
