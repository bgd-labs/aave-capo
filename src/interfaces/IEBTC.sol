// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the AccountantWithRateProvider interface allowing to get exchange ratio with BTC
interface IEBTC {
  /**
   * @notice Get this BoringVault's current rate in the base.
   */
  function getRate() external view returns (uint256);
}
