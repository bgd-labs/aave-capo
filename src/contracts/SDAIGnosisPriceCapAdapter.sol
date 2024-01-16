// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IERC4626} from 'forge-std/interfaces/IERC4626.sol';

import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';

/**
 * @title SDAIGnosisPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (sDAI / USD) pair by using
 * @notice Chainlink data feed for (DAI / USD) and (sDAI / DAI) ratio.
 */
contract SDAIGnosisPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice sDAI token contract to get the exchange rate
   */
  IERC4626 public immutable sDAI;

  /**
   * @param daiToBaseAggregatorAddress the address of DAI / BASE feed
   * @param sDaiAddress the address of the sDAI
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address daiToBaseAggregatorAddress,
    address sDaiAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      daiToBaseAggregatorAddress,
      pairName,
      IERC4626(sDaiAddress).decimals(),
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    sDAI = IERC4626(sDaiAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(sDAI.convertToAssets(10 ** RATIO_DECIMALS));

    return ratio;
  }
}
