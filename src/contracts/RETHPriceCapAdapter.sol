// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IrETH} from 'cl-synchronicity-price-adapter/interfaces/IrETH.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title RETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (rETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (rETH / ETH) ratio.
 */
contract RETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice rETH token contract
   */
  IrETH public immutable RETH;

  /**
   * @param aclManager ACL manager contract
   * @param rETHToBaseAggregatorAddress the address of (rETH / USD) feed
   * @param rETHAddress the address of the rETH token, the (rETH / ETH) ratio feed
   * @param pairName name identifier
   * @param snapshotRatio The latest exchange ratio
   * @param snapshotTimestamp The timestamp of the latest exchange ratio
   * @param maxYearlyRatioGrowthPercent Maximum growth of the underlying asset value per year, 100_00 is equal 100%
   */
  constructor(
    IACLManager aclManager,
    address rETHToBaseAggregatorAddress,
    address rETHAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  )
    PriceCapAdapterBase(
      aclManager,
      rETHToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowthPercent
    )
  {
    RETH = IrETH(rETHAddress);
  }

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(RETH.getExchangeRate());
  }
}
