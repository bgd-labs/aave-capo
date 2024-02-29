// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';

contract rETHArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3ArbitrumAssets.rETH_ORACLE,
      ForkParams({network: 'arbitrum', blockNumber: 178994964}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_30,
        minimumSnapshotDelay: 7 days,
        startBlock: 158995618,
        finishBlock: 178994966,
        delayInBlocks: 2550000, // > 7 days
        step: 2550000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 158995618, finishBlock: 178994966}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Arbitrum.ACL_MANAGER,
        baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
        ratioProviderAddress: MiscArbitrum.rETH_ETH_AGGREGATOR,
        pairDescription: 'Capped rETH / ETH / USD'
      })
    )
  {}
}
