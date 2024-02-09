// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';
import {BaseAggregatorsPolygon} from 'cl-synchronicity-price-adapter/lib/BaseAggregators.sol';

import {CLAdapterBaseTest} from '../CLAdapterBaseTest.sol';

contract WstETHPolPriceCapAdapterTest is CLAdapterBaseTest {
  constructor()
    CLAdapterBaseTest(
      AaveV3PolygonAssets.wstETH_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 52496344}),
      RetrospectionParams({
        maxYearlyRatioGrowthPercent: 8_72,
        minimumSnapshotDelay: 7 days,
        startBlock: 50808790,
        finishBlock: 53308720,
        delayInBlocks: 280500, // 14 days
        step: 280500 // ~ 7 days
      }),
      AdapterCreationDefaultParams({
        aclManager: AaveV3Polygon.ACL_MANAGER,
        baseAggregatorAddress: AaveV3PolygonAssets.WETH_ORACLE,
        ratioProviderAddress: BaseAggregatorsPolygon.WSTETH_STETH_AGGREGATOR,
        pairDescription: 'Capped wstETH / stETH(ETH) / USD'
      })
    )
  {}
}
