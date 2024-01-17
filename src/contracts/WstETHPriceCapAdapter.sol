// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';
import {IStETH} from 'cl-synchronicity-price-adapter/interfaces/IStETH.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from './PriceCapAdapterBase.sol';

/**
 * @title WstETHPriceCapAdapter
 * @author BGD Labs
 * @notice Price capped adapter to calculate price of (wstETH / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (wstETH / stETH) ratio.
 */
contract WstETHPriceCapAdapter is PriceCapAdapterBase {
  /**
   * @notice ratio provider for (wstETH / stETH)
   */
  IStETH public immutable STETH;

  /**
   * @param ethToBaseAggregatorAddress the address of (ETH / USD) feed
   * @param stEthAddress the address of the stETH contract, the (wStETH / ETH) ratio fee
   * @param pairName name identifier
   */
  constructor(
    IACLManager aclManager,
    address ethToBaseAggregatorAddress,
    address stEthAddress,
    string memory pairName,
    uint104 snapshotRatio,
    uint48 snapshotTimestamp,
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

  /// @inheritdoc IPriceCapAdapter
  function getRatio() public view override returns (int256) {
    return int256(STETH.getPooledEthByShares(10 ** RATIO_DECIMALS));
  }
}
