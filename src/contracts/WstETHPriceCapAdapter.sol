// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IStETH} from 'cl-synchronicity-price-adapter/interfaces/IStETH.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title WstETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (wstETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (wstETH / stETH) ratio.
 */
contract WstETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param ethToBaseAggregatorAddress the address of (ETH / USD) feed
   * @param stEthAddress the address of the stETH contract, the (wStETH / ETH) ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param snapshotRatio the latest exchange ratio
   * @param snapshotTimestamp the timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address ethToBaseAggregatorAddress,
    address stEthAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      ethToBaseAggregatorAddress,
      stEthAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IStETH(RATIO_PROVIDER).getPooledEthByShares(10 ** RATIO_DECIMALS));
  }
}
