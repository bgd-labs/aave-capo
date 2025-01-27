// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice A simple version of the IOsGNO interface allowing to get exchange ratio with GNO
interface IOsGNO {
  /**
   * @return the current exchange ratio of the osGNO to the GNO
   */
  function getRate() external view returns (uint256);
}
