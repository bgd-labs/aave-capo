// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseTestV2} from './BaseTestV2.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapterStable.sol';

import {AdaptersEthBasedPolygon} from '../../scripts/AaveV2/DeployPolygon.s.sol';

abstract contract BasePolygonTestV2 is BaseTestV2 {
  constructor(
    address referenceFeed,
    ForkParams memory _forkParams,
    AdapterParams memory _adapterParams
  )
    BaseTestV2(
      referenceFeed,
      _forkParams,
      _adapterParams,
      RetrospectionParams({
        startBlock: 54137000,
        finishBlock: 55697113,
        step: 140000 // ~ 3-4 days
      })
    )
  {}
}

contract PolygonV2USDTTest is BasePolygonTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BasePolygonTestV2(
      AaveV2PolygonAssets.USDT_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.USDTtoETHAdapterCode()
      })
    )
  {}
}

contract PolygonV2USDCTest is BasePolygonTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BasePolygonTestV2(
      AaveV2PolygonAssets.USDC_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.USDCtoETHAdapterCode()
      })
    )
  {}
}

contract PolygonV2DAITest is BasePolygonTestV2 {
  bytes[] public preRequisiteAdapters;

  constructor()
    BasePolygonTestV2(
      AaveV2PolygonAssets.DAI_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.DAItoETHAdapterCode()
      })
    )
  {}
}
