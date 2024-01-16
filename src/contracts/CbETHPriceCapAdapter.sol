// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {ICbEthRateProvider} from 'cl-synchronicity-price-adapter/interfaces/ICbEthRateProvider.sol';

/**
 * @title CbETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (cbETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (cbETH / ETH) ratio.
 */
contract CbETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice rate provider for (cbETH / Base)
   */
  ICbEthRateProvider public immutable RATE_PROVIDER;

  /**
   * @param cbETHToBaseAggregatorAddress the address of cbETH / BASE feed
   * @param rateProviderAddress the address of the rate provider
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address cbETHToBaseAggregatorAddress,
    address rateProviderAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      cbETHToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    RATE_PROVIDER = ICbEthRateProvider(rateProviderAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(RATE_PROVIDER.exchangeRate());

    return ratio;
  }
}
