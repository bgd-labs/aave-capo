// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {IPot} from 'cl-synchronicity-price-adapter/interfaces/IPot.sol';

/**
 * @title SDAIPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sDAI / USD) pair by using
 * @notice Chainlink data feed for (DAI / USD) and (sDAI / DAI) ratio.
 */
contract SDAIPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice rate provider for (sDAI / DAI)
   */
  IPot public immutable RATE_PROVIDER;

  /**
   * @param daiToBaseAggregatorAddress the address of DAI / BASE feed
   * @param potAddress the address of the sDAI pot
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address potAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      pairName,
      27,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    RATE_PROVIDER = IPot(potAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(RATE_PROVIDER.chi());

    return ratio;
  }
}
