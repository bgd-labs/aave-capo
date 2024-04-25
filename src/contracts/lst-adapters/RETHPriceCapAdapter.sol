// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IrETH} from 'cl-synchronicity-price-adapter/interfaces/IrETH.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

/**
 * @title RETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (rETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (rETH / ETH) ratio.
 */
contract RETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param rETHToBaseAggregatorAddress the address of (rETH / USD) feed
   * @param rETHAddress the address of the rETH token, the (rETH / ETH) ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address rETHToBaseAggregatorAddress,
    address rETHAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      rETHToBaseAggregatorAddress,
      rETHAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IrETH(RATIO_PROVIDER).getExchangeRate());
  }
}
