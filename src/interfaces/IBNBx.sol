// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the BNBx Stake Manager V2 interface allowing to get exchange ratio with BNB

interface IBNBx {
  /// @notice Convert BnbX to BNB.
  /// @param _amountInBnbX The amount of BnbX to convert.
  /// @return The amount of BNB equivalent.
  function convertBnbXToBnb(uint256 _amountInBnbX) external view returns (uint256);
}
