// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {MiscArbitrum} from 'aave-address-book/MiscArbitrum.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract WstETHArbitrumPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3ArbitrumAssets.wstETH_ORACLE,
      CapAdaptersCodeArbitrum.wstETH_ADAPTER_CODE,
      ForkParams({network: 'arbitrum', blockNumber: 187326915}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 158995618,
        finishBlock: 187326915,
        delayInBlocks: 2550000, // > 7 days
        step: 2550000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 158995618, finishBlock: 178994966}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Arbitrum.ACL_MANAGER,
        baseAggregatorAddress: AaveV3ArbitrumAssets.WETH_ORACLE,
        ratioProviderAddress: MiscArbitrum.wstETH_stETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
