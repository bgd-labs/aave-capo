// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import {IACLManager} from 'aave-address-book/AaveV3.sol';

import {PriceCapAdapterBase, IPriceCapAdapter} from '../PriceCapAdapterBase.sol';
import {IEthxOracle} from '../../interfaces/IEthxOracle.sol';

/**
 * @title ETHxPriceCapAdapter
 * @author Alice - Aave-chan Initiativee
 * @notice Price capped adapter to calculate price of (ETHx / USD) pair by using
 * @notice Chainlink data feed for (ETH / USD) and (ETHx / ETH) ratio.
 */
contract ETHxPriceCapAdapter is PriceCapAdapterBase {
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
    IEthxOracle.ExchangeRate memory exchangeRate = IEthxOracle(RATIO_PROVIDER).getExchangeRate();
    return int256((exchangeRate.totalETHBalance * 10**RATIO_DECIMALS)/ exchangeRate.totalETHXSupply);
  }
}
