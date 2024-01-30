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
   * @param aclManager ACL manager contract
   * @param daiToBaseAggregatorAddress the address of (DAI / USD) feed
   * @param potAddress the address of the sDAI pot, used the (sDAI / DAI) ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address potAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      potAddress,
      pairName,
      27,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IPot(RATIO_PROVIDER).chi());
  }
}
