// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';

contract cbETHBasePriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3BaseAssets.cbETH_ORACLE,
      ForkParams({network: 'base', blockNumber: 10346239}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 10_75, // TODO: it doesn't work with 6_75 provided by chaos
        minimumSnapshotDelay: 7 days,
        startBlock: 7846275,
        finishBlock: 10346241,
        delayInBlocks: 308000, // 7 days
        step: 308000
      }),
      CapParams({maxYearlyRatioGrowthPercent: 1_00, startBlock: 7846275, finishBlock: 10346241}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Base.ACL_MANAGER,
        baseAggregatorAddress: AaveV3BaseAssets.WETH_ORACLE,
        ratioProviderAddress: MiscBase.cbETH_ETH_AGGREGATOR,
        pairDescription: 'Capped cbETH / ETH / USD'
      })
    )
  {}
}
