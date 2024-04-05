// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IWeEth} from '../interfaces/IWeEth.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title WeETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (weETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (weETH / eETH) ratio.
 */
contract WeETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param ethToBaseAggregatorAddress the address of (ETH / USD) feed
   * @param weEthAddress the address of the weETH contract, the (weETH / ETH) ratio
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address ethToBaseAggregatorAddress,
    address weEthAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      ethToBaseAggregatorAddress,
      weEthAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IWeEth(RATIO_PROVIDER).getRate());
  }
}
