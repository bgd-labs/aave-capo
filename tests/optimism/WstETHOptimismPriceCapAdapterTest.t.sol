// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeOptimism} from '../../scripts/DeployOptimism.s.sol';

contract WstETHOptimismPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3OptimismAssets.wstETH_ORACLE,
      CapAdaptersCodeOptimism.wstETH_ADAPTER_CODE,
      ForkParams({network: 'optimism', blockNumber: 117020445}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 113441931,
        finishBlock: 117020445,
        delayInBlocks: 310000, // 7 days
        step: 310000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 113441931, finishBlock: 115941709}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Optimism.ACL_MANAGER,
        baseAggregatorAddress: AaveV3OptimismAssets.WETH_ORACLE,
        ratioProviderAddress: MiscOptimism.wstETH_stETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
