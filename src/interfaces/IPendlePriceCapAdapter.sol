// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from 'cl-synchronicity-price-adapter/interfaces/ICLSynchronicityPriceAdapter.sol';

import {IPendlePrincipalToken} from '../interfaces/IPendlePrincipalToken.sol';

interface IPendlePriceCapAdapter is ICLSynchronicityPriceAdapter {
  /// @dev Attempted to set zero address
  error ZeroAddress();

  /// @dev Attempted to create price adapter for pendle token with already passed maturity
  error MaturityHasAlreadyPassed();

  /// @dev Attempted to set parameters that are valued at a discount of more than 100% for this linear model
  error DiscountExceeds100Percent();

  /// @dev Attempted to change `maxDiscountPerYear` from unauthorized address
  error CallerIsNotRiskOrPoolAdmin();

  /**
   * @notice Sets a new value `maxDiscountPerYear` used for PT tokens pricing
   * @dev Can be called from risk admin or pool admin only
   * @param maxDiscountPerYear_ New max discount per year
   */
  function setMaxDiscountPerYear(uint16 maxDiscountPerYear_) external;

  /**
   * @notice Returns the current discount on PT tokens
   * @dev The discount amount is always inside [0; `PERCENTAGE_FACTOR`) range
   * @return currentDiscount Current discount amount for the asset pricing
   */
  function getCurrentDiscount() external view returns (uint256 currentDiscount);

  /**
   * @notice Returns max discount per year in percents
   * @dev The value may exceed 100%, but only if the period to maturity is less than a year
   * @dev The parameter should be set based on the maximum possible APY value of the underlying asset
   * @return maxDiscountPerYear The maximum discount for the asset pricing
   */
  function getMaxDiscountPerYear() external view returns (uint256 maxDiscountPerYear);

  /**
   * @notice Price feed for (ASSET / USD) pair
   */
  function ASSET_TO_USD_AGGREGATOR() external view returns (IChainlinkAggregator);

  /**
   * @notice Pendle principal token contract
   */
  function PENDLE_PRINCIPAL_TOKEN() external view returns (IPendlePrincipalToken);

  /**
   * @notice ACL manager contract
   */
  function ACL_MANAGER() external view returns (IACLManager);

  /**
   * @notice Asset maturity timestamp
   */
  function MATURITY() external view returns (uint256);

  /**
   * @notice Number of decimals in the output of this price adapter
   */
  function DECIMALS() external view returns (uint8);

  /**
   * @notice Maximum percentage factor (100.00%)
   */
  function PERCENTAGE_FACTOR() external pure returns (uint256);

  /**
   * @notice Number of seconds per year (365 days)
   */
  function SECONDS_PER_YEAR() external pure returns (uint256);
}
