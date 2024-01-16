// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {PriceCapAdapterBase} from './PriceCapAdapterBase.sol';
import {IStETH} from 'cl-synchronicity-price-adapter/interfaces/IStETH.sol';

/**
 * @title WstETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (wstETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (wstETH / stETH) ratio.
 */
contract WstETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice stETH token contract to get ratio
   */
  IStETH public immutable STETH;

  /**
   * @param ethToBaseAggregatorAddress the address of ETH / BASE feed
   * @param stEthAddress the address of the stETH contract
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address ethToBaseAggregatorAddress,
    address stEthAddress,
    string memory pairName,
    uint256 snapshotRatio,
    uint256 snapshotTimestamp,
    uint16 maxYearlyRatioGrowth
  )
    PriceCapAdapterBase(
      aclManager,
      ethToBaseAggregatorAddress,
      pairName,
      18,
      snapshotRatio,
      snapshotTimestamp,
      maxYearlyRatioGrowth
    )
  {
    STETH = IStETH(stEthAddress);
  }

  function _getRatio() internal view override returns (int256) {
    int256 ratio = int256(STETH.getPooledEthByShares(10 ** RATIO_DECIMALS));

    return ratio;
  }
}
