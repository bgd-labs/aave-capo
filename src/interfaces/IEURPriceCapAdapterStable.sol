// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPriceCapAdapterStable, IACLManager, IChainlinkAggregator} from './IPriceCapAdapterStable.sol';

interface IEURPriceCapAdapterStable is IPriceCapAdapterStable {
  /**
   * @notice Parameters to create eur stable cap adapter
   * @param capAdapterStableParams parameters to create eur stable cap adapter
   */
  struct CapAdapterStableParamsEUR {
    IACLManager aclManager;
    IChainlinkAggregator assetToUsdAggregator;
    IChainlinkAggregator baseToUsdAggregator;
    string adapterDescription;
    int256 priceCap;
  }

  /**
   * @notice Price feed for (BASE / USD) pair
   */
  function BASE_TO_USD_AGGREGATOR() external view returns (IChainlinkAggregator);
}
