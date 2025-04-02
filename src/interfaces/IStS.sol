// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the stS interface allowing to get exchange ratio with S
interface IStS {
  function convertToAssets(uint256 shares) external view returns (uint256 assets);
}
