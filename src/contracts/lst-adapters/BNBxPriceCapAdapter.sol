// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IBNBx} from '../../interfaces/IBNBx.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

/**
 * @title BNBxPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (BNBx / USD) pair by using
 * @notice Chainlink data feed for (BNB / USD) and (BNBx / BNB) ratio.
 */
contract BNBxPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @param capAdapterParams parameters to create cap adapter
   */
  constructor(
    CapAdapterParams memory capAdapterParams
  )
    PriceCapAdapterBase(
      CapAdapterBaseParams({
        aclManager: capAdapterParams.aclManager,
        baseAggregatorAddress: capAdapterParams.baseAggregatorAddress,
        ratioProviderAddress: capAdapterParams.ratioProviderAddress,
        pairDescription: capAdapterParams.pairDescription,
        ratioDecimals: 18,
        minimumSnapshotDelay: capAdapterParams.minimumSnapshotDelay,
        priceCapParams: capAdapterParams.priceCapParams
      })
    )
  {}

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(IBNBx(RATIO_PROVIDER).convertBnbXToBnb(10 ** RATIO_DECIMALS));
  }
}
