// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

/**
 * @title CLRatePriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (Asset / USD) pair by using
 * @notice Chainlink data feeds for (PEG / USD) and (ASSET / PEG).
 */
contract CLRatePriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice Price feed for (Asset / Peg) pair
   */
  IChainlinkAggregator public immutable RATE_PROVIDER;

  /**
   * @param pegToBaseAggregatorAddress the address of PEG / BASE feed
   * @param rateProviderAddress the address of the ASSET / PEG feed
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address pegToBaseAggregatorAddress,
    address rateProviderAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      pegToBaseAggregatorAddress,
      pairName,
      IChainlinkAggregator(rateProviderAddress).decimals(),
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    RATE_PROVIDER = IChainlinkAggregator(rateProviderAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = RATE_PROVIDER.latestAnswer();

    return ratio;
  }
}
