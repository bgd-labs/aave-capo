// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';
import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

/**
 * @title sUSDSPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sUSDS / USD) pair by using
 * @notice Capped adapter for (USDS <-> DAI / USD) and (sUSDS / USDS) ratio.
 */
contract sUSDSPriceCapAdapter is PriceCapAdapterBase {
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
    return int256(IERC4626(RATIO_PROVIDER).convertToAssets(10 ** RATIO_DECIMALS));
  }
}
