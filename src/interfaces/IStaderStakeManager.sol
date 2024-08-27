// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the interface allowing to get exchange ratio
interface IStaderStakeManager {
  /**
   * @return the current exchange ratio for BNBx to BNB
   */
  function convertBnbXToBnb(uint256 _amountInBnbX) external view returns (uint256);
}
