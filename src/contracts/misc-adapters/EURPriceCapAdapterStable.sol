// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {PriceCapAdapterStable, IChainlinkAggregator, ICLSynchronicityPriceAdapter, IPriceCapAdapterStable} from '../PriceCapAdapterStable.sol';
import {IEURPriceCapAdapterStable} from '../../interfaces/IEURPriceCapAdapterStable.sol';

/**
 * @title EURPriceCapAdapterStable
 * @author BGD Labs
 * @notice Price capped adapter to cap the price of the EUR asset using the
 * @notice chainlink market feeds ASSET/USD and EUR/USD
 */
contract EURPriceCapAdapterStable is IEURPriceCapAdapterStable, PriceCapAdapterStable {
  /// @inheritdoc IEURPriceCapAdapterStable
  IChainlinkAggregator public immutable BASE_TO_USD_AGGREGATOR;

  /**
   * @param capAdapterStableParams parameters to create eur stable cap adapter
   */
  constructor(CapAdapterStableParamsEUR memory capAdapterStableParams)
    PriceCapAdapterStable(
      CapAdapterStableParams(
        capAdapterStableParams.aclManager,
        capAdapterStableParams.assetToUsdAggregator,
        capAdapterStableParams.adapterDescription,
        capAdapterStableParams.priceCap
      )
    ) {
    BASE_TO_USD_AGGREGATOR = capAdapterStableParams.baseToUsdAggregator;
  }

  /// @inheritdoc ICLSynchronicityPriceAdapter
  function latestAnswer() external view override(ICLSynchronicityPriceAdapter, PriceCapAdapterStable) virtual returns (int256) {
    int256 assetPrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    int256 basePrice = BASE_TO_USD_AGGREGATOR.latestAnswer();
    int256 maxPrice = (basePrice * _priceCap) / 1e8;

    if (assetPrice > maxPrice) {
      return maxPrice;
    }

    return assetPrice;
  }

  /**
   * @notice Updates price cap
   * @param priceCap the new price cap
   */
  function _setPriceCap(int256 priceCap) internal override {
    int256 assetPrice = ASSET_TO_USD_AGGREGATOR.latestAnswer();
    int256 basePrice = BASE_TO_USD_AGGREGATOR.latestAnswer();

    if ((basePrice * priceCap) / 1e8 < assetPrice) {
      revert CapLowerThanActualPrice();
    }

    _priceCap = priceCap;

    emit PriceCapUpdated(priceCap);
  }
}
