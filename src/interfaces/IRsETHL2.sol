// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the rsETH L2 Oracle allowing to get the rsETH exchange ratio with ETH
interface IRsETHL2 {
  /// @notice rsETH:ETH exchange rate
  function rate() external view returns (uint256);
}
