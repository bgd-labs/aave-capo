// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IMaticRateProvider} from 'cl-synchronicity-price-adapter/interfaces/IMaticRateProvider.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title MaticPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (lst Matic / USD) pair by using
 * @notice Chainlink data feed for (MATIC / USD) and (lst Matic / MATIC) ratio.
 * @notice can be used as it is for stMatic and MaticX on Polygon network
 */
contract MaticPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param aclManager ACL manager contract
   * @param maticToBaseAggregatorAddress the address of MATIC / USD feed
   * @param ratioProviderAddress the address of (lst Matic / MATIC) pair ratio feed
   * @param pairName name identifier
   * @param minimumSnapshotDelay minimum time (in seconds) that should have passed from the snapshot timestamp to the current block.timestamp
   * @param priceCapParams parameters to set price cap
   */
  constructor(
    IACLManager aclManager,
    address maticToBaseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairName,
    uint48 minimumSnapshotDelay,
    PriceCapUpdateParams memory priceCapParams
  )
    PriceCapAdapterBase(
      aclManager,
      maticToBaseAggregatorAddress,
      ratioProviderAddress,
      pairName,
      18,
      minimumSnapshotDelay,
      priceCapParams
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IMaticRateProvider(RATIO_PROVIDER).getRate());
  }
}
