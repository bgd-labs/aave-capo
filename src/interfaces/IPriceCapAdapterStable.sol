// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';
import {ICLSynchronicityPriceAdapter} from 'cl-synchronicity-price-adapter/interfaces/ICLSynchronicityPriceAdapter.sol';

interface IPriceCapAdapterStable is ICLSynchronicityPriceAdapter {
  /**
   * @dev Emitted when the price cap gets updated
   * @param priceCap the new price cap
   **/
  event PriceCapUpdated(int256 priceCap);

  /**
   * @notice Parameters to create stable cap adapter
   * @param capAdapterStableParams parameters to create stable cap adapter
   */
  struct CapAdapterStableParams {
    IACLManager aclManager;
    IChainlinkAggregator assetToUsdAggregator;
    string adapterDescription;
    int256 priceCap;
  }

  /**
   * @notice Price feed for (ASSET / USD) pair
   */
  function ASSET_TO_USD_AGGREGATOR() external view returns (IChainlinkAggregator);

  /**
   * @notice ACL manager contract
   */
  function ACL_MANAGER() external view returns (IACLManager);

  /**
   * @notice Updates price cap
   * @param priceCap the new price cap
   */
  function setPriceCap(int256 priceCap) external;

  /**
   * @notice Get price cap value
   */
  function getPriceCap() external view returns (int256);

  /**
   * @notice Returns if the price is currently capped
   */
  function isCapped() external view returns (bool);

  error ACLManagerIsZeroAddress();
  error CallerIsNotRiskOrPoolAdmin();
  error CapLowerThanActualPrice();
}
