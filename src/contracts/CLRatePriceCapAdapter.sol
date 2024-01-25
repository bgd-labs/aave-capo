// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title CLRatePriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (lstASSET / USD) pair by using
 * @notice Chainlink data feeds for (ASSET / USD) and (lstASSET / ASSET).
 */
contract CLRatePriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param assetToBaseAggregatorAddress the address of (ASSET / USD) feed
   * @param ratioProviderAddress the address of the (lstASSET / ASSET) ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param snapshotRatio the latest exchange ratio
   * @param snapshotTimestamp the timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address assetToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      assetToBaseAggregatorAddress,
      ratioProviderAddress,
      pairName,
      IChainlinkAggregator(ratioProviderAddress).decimals(),
      minimumSnapshotDelay,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return IChainlinkAggregator(RATIO_PROVIDER).latestAnswer();
  }
}
