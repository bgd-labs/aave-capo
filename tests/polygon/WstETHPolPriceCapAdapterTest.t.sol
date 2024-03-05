// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {MiscPolygon} from 'aave-address-book/MiscPolygon.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';
import {CapAdaptersCodePolygon} from '../../scripts/DeployPolygon.s.sol';

contract WstETHPolPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3PolygonAssets.wstETH_ORACLE,
      CapAdaptersCodePolygon.wstETH_ADAPTER_CODE,
      ForkParams({network: 'polygon', blockNumber: 54293469}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 9_68,
        minimumSnapshotDelay: 7 days,
        startBlock: 50808790,
        finishBlock: 54293469,
        delayInBlocks: 280500, // 14 days
        step: 280500 // ~ 7 days
      }),
      CapParams({maxYearlyRatioGrowthPercent: 2_00, startBlock: 50808790, finishBlock: 53308720}),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Polygon.ACL_MANAGER,
        baseAggregatorAddress: AaveV3PolygonAssets.WETH_ORACLE,
        ratioProviderAddress: MiscPolygon.wstETH_stETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
