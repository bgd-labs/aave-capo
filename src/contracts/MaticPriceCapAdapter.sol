// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {IMaticRateProvider} from 'cl-synchronicity-price-adapter/interfaces/IMaticRateProvider.sol';

/**
 * @title MaticPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (lst matic / USD) pair by using
 * @notice Chainlink data feed for (MATIC / USD) and (liquid staked matic / MATIC) ratio.
 */
contract MaticPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice Price feed for (MATIC / Base) pair
   */
  IMaticRateProvider public immutable RATE_PROVIDER;

  /**
   * @param maticToBaseAggregatorAddress the address of cbETH / BASE feed
   * @param rateProviderAddress the address of the rETH token
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address maticToBaseAggregatorAddress,
    address rateProviderAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      maticToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    RATE_PROVIDER = IMaticRateProvider(rateProviderAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(RATE_PROVIDER.getRate());

    return ratio;
  }
}
