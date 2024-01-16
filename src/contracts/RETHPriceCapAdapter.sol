// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {IrETH} from 'cl-synchronicity-price-adapter/interfaces/IrETH.sol';

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
   * @param rETHToBaseAggregatorAddress the address of cbETH / BASE feed
   * @param rethAddress the address of the rETH token
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address rETHToBaseAggregatorAddress,
    address rethAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      rETHToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    RETH = IrETH(rethAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(RETH.getExchangeRate());

    return ratio;
  }
}
