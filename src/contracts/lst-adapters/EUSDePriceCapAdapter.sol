// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';
import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';

/**
 * @title EUSDePriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (eUSDe / USD) pair by using
 * @notice Chainlink data feed for (USDT / USD) and (eUSDe / USDe) ratio.
 * @dev IMPORTANT: eUSDe lacks internal accounting in `totalAssets` and relies on the `USDe.balanceOf(eUSDe)`, making it vulnerable to inflation attacks.
 * This adapter will be deployed with the `maxYearlyRatioGrowthPercent` parameter set to zero,
 * and will cap the price if any increase in the exchange rate of eUSDe happens.
 * Anyone who considers using this adapter should be aware of its behavior.
 */
contract EUSDePriceCapAdapter is PriceCapAdapterBase {
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
