// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title CLRatePriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (Asset / USD) pair by using
 * @notice Chainlink data feeds for (PEG / USD) and (ASSET / PEG).
 */
contract CLRatePriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice Ratio provider for  (Asset / PEG) pair
   */
  IChainlinkAggregator public immutable RATIO_PROVIDER;

  /**
   * @param aclManager ACL manager contract
   * @param pegToBaseAggregatorAddress the address of (PEG / USD) feed
   * @param ratioProviderAddress the address of the (ASSET / PEG) ratio feed
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address pegToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      pegToBaseAggregatorAddress,
      pairName,
      IChainlinkAggregator(ratioProviderAddress).decimals(),
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    RATIO_PROVIDER = IChainlinkAggregator(ratioProviderAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return RATIO_PROVIDER.latestAnswer();
  }
}
