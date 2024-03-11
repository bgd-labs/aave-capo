// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';
import {MiscScroll} from 'aave-address-book/MiscScroll.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodeScroll} from '../../scripts/DeployScroll.s.sol';

contract WstETHScrollPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3ScrollAssets.wstETH_ORACLE,
      CapAdaptersCodeScroll.wstETH_ADAPTER_CODE,
      ForkParams({network: 'scroll', blockNumber: 4005049}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 2668781,
        finishBlock: 4005049,
        delayInBlocks: 205000, // 7 days
        step: 205000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 2668781, finishBlock: 4005049}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Scroll.ACL_MANAGER,
        baseAggregatorAddress: AaveV3ScrollAssets.WETH_ORACLE,
        ratioProviderAddress: MiscScroll.wstETH_stETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
