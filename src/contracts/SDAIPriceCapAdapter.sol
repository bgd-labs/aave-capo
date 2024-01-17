// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IPot} from 'cl-synchronicity-price-adapter/interfaces/IPot.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title SDAIPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sDAI / USD) pair by using
 * @notice Chainlink data feed for (DAI / USD) and (sDAI / DAI) ratio.
 */
contract SDAIPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice ratio provider for (sDAI / DAI)
   */
  IPot public immutable RATIO_PROVIDER;

  /**
   * @param aclManager ACL manager contract
   * @param daiToBaseAggregatorAddress the address of (DAI / USD) feed
   * @param potAddress the address of the sDAI pot, the (sDAI / DAI) ratio feed
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address potAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      pairName,
      27, // TODO: very likely that it's incorrect, and useless
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    RATIO_PROVIDER = IPot(potAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(RATIO_PROVIDER.chi());
  }
}
