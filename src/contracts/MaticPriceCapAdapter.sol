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
   * @param aclManager ACL manager contract
   * @param maticToBaseAggregatorAddress the address of MATIC / USD feed
   * @param ratioProviderAddress the address of (lst Matic / MATIC) pair ratio feed
   * @param pairName name identifier
   * @param rewardsAligningInterval the interval in seconds, used to align rewards distribution, to keep them in sync with the yearly APY
   * @param snapshotRatio the latest exchange ratio
   * @param snapshotTimestamp the timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address maticToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint48 rewardsAligningInterval,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      maticToBaseAggregatorAddress,
      ratioProviderAddress,
      pairName,
      18,
      rewardsAligningInterval,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IMaticRateProvider(RATIO_PROVIDER).getRate());
  }
}
