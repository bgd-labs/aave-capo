// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice A simple version of the IStEUR interface allowing to get exchange ratio with agEUR
interface IStEUR {
  /**
   * @return The exchange rate with agEUR.
   */
  function rate() external view returns (uint208);
}
