// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {IStEUR} from '../interfaces/IStEUR.sol';
import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title stEURPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (stEUR / EUR) pair by using
 * @notice Price cap adapter for stablecoins (agEUR / EUR) and (stEUR / agEUR) ratio.
 */
contract stEURPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param agEurToEurAggregatorAddress the address of (agUER / EUR) feed
   * @param stEurAddress the address of the stEUR contract
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address agEurToEurAggregatorAddress,
    address stEurAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      agEurToEurAggregatorAddress,
      stEurAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IStEUR(RATIO_PROVIDER).convertToAssets(10 ** RATIO_DECIMALS));
  }
}
