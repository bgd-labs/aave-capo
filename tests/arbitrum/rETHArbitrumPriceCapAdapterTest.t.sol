// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../BaseTest.sol';

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {BaseAggregatorsArbitrum} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';
import {IChainlinkAggregator} from 'cl-synchronicity-price-adapter/interfaces/IChainlinkAggregator.sol';

import {CLRatePriceCapAdapter} from '../../src/contracts/CLRatePriceCapAdapter.sol';
import {IPriceCapAdapter, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';

contract rETHArbitrumPriceCapAdapterTest is BaseTest {
  constructor()
    BaseTest(
      AaveV3ArbitrumAssets.rETH_ORACLE,
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 7_50,
        minimumSnapshotDelay: 7 days,
        startBlock: 158995618,
        finishBlock: 178994966,
        delayInBlocks: 2550000, // > 7 days
        step: 2550000
      })
    )
  {}

  function createAdapter(
    IACLManager aclManager,
    address baseAggregatorAddress,
    address ratioProviderAddress,
    string memory pairDescription,
    uint48 minimumSnapshotDelay,
    IPriceCapAdapter.PriceCapUpdateParams memory priceCapParams
  ) public override returns (IPriceCapAdapter) {
    return
      new CLRatePriceCapAdapter(
        aclManager,
        baseAggregatorAddress,
        ratioProviderAddress,
        pairDescription,
        minimumSnapshotDelay,
        priceCapParams
      );
  }

  function createAdapterSimple(
    uint48 minimumSnapshotDelay,
    uint104 currentRatio,
    uint48 snapshotTimestamp,
    uint16 maxYearlyRatioGrowthPercent
  ) public override returns (IPriceCapAdapter) {
    return
      createAdapter(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.WETH_ORACLE,
        BaseAggregatorsArbitrum.RETH_ETH_AGGREGATOR,
        'Capped rETH / ETH / USD',
        minimumSnapshotDelay,
        currentRatio,
        snapshotTimestamp,
        maxYearlyRatioGrowthPercent
      );
  }

  function getCurrentRatio() public view override returns (uint104) {
    return
      uint104(
        uint256(IChainlinkAggregator(BaseAggregatorsArbitrum.RETH_ETH_AGGREGATOR).latestAnswer())
      );
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 178994964);
  }
}
