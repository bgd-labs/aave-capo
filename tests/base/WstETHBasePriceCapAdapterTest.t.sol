// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';

contract WstETHBasePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3BaseAssets.wstETH_ORACLE,
      ForkParams({network: 'base', blockNumber: 10346240}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 7846275,
        finishBlock: 10346241,
        delayInBlocks: 308000, // 7 days
        step: 308000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 7846275, finishBlock: 10346241}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Base.ACL_MANAGER,
        baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
        ratioProviderAddress: MiscBase.wstETH_stETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
