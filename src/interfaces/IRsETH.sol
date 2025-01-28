// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the Kelp DAO LRT Oracle allowing to get the rsETH exchange ratio with ETH
interface IRsETH {
  /// @notice rsETH:ETH exchange rate
  function rsETHPrice() external view returns (uint256);
}
