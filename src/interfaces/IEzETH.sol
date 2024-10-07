// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the Renzo ezETH system interface allowing to get exchange ratio with ETH
interface IEzETHRestakeManager {
  /// @dev This function calculates the TVLs for each operator delegator by individual token, total for each OD, and total for the protocol.
  /// @return operatorDelegatorTokenTVLs Each OD's TVL indexed by operatorDelegators array by collateralTokens array
  /// @return operatorDelegatorTVLs Each OD's Total TVL in order of operatorDelegators array
  /// @return totalTVL The total TVL across all operator delegators.
  function calculateTVLs() external view returns (uint256[][] memory, uint256[] memory, uint256);

  /// @return ezETH token contract
  function ezETH() external view returns (IEzEthToken);
}

interface IEzEthToken {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);
}
