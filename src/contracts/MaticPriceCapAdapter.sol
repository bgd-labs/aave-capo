// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IMaticRateProvider} from 'cl-synchronicity-price-adapter/interfaces/IMaticRateProvider.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title MaticPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (lst Matic / USD) pair by using
 * @notice Chainlink data feed for (MATIC / USD) and (lst Matic / MATIC) ratio.
 * @notice can be used as it is for stMatic and MaticX on Polygon network
 */
contract MaticPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice Ratio provider for  (lst Matic / MATIC) pair
   */
  IMaticRateProvider public immutable RATIO_PROVIDER;

  /**
   * @param aclManager ACL manager contract
   * @param maticToBaseAggregatorAddress the address of MATIC / USD feed
   * @param ratioProviderAddress the address of the lst Matic token
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address maticToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      maticToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    RATIO_PROVIDER = IMaticRateProvider(ratioProviderAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(RATIO_PROVIDER.getRate());
  }
}
