// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

interface IFixedPriceAdapter {
  /**
   * @notice Number of decimals in the output of this price feed
   */
  function DECIMALS() external view returns (uint8);

  /**
   * @notice Hardcoded price of the price feed
   */
  function PRICE() external view returns (int256);

  /**
   * @notice Returns the description of the feed
   * @return string description
   */
  function description() external view returns (string memory);

  /**
   * @notice Returns the feed decimals
   * @return uint8 decimals
   */
  function decimals() external view returns (uint8);

  /**
   * @notice Returns the fixed hardcoded price of the feed
   * @return int256 latestAnswer
   */
  function latestAnswer() external view returns (int256);
}
