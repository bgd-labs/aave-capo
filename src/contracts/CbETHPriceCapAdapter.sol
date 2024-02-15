// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {ICbEthRateProvider} from 'cl-synchronicity-price-adapter/interfaces/ICbEthRateProvider.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title CbETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (cbETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (cbETH / ETH) ratio.
 */
contract CbETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param cbETHToBaseAggregatorAddress the address of cbETH / BASE feed
   * @param ratioProviderAddress the address of the (cbETH / ETH) ratio provider
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address cbETHToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      cbETHToBaseAggregatorAddress,
      ratioProviderAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(ICbEthRateProvider(RATIO_PROVIDER).exchangeRate());
  }
}
