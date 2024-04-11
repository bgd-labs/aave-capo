// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {IACLManager, BasicIACLManager} from 'aave-address-book/AaveV3.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseTestV2} from './BaseTestV2.sol';
import {IPriceCapAdapterStable, ICLSynchronicityPriceAdapter} from '../../src/interfaces/IPriceCapAdapterStable.sol';

import {CapAdaptersCodePolygon, AdaptersEthBasedPolygon} from '../../scripts/AaveV2/DeployPolygon.s.sol';

contract PolygonV2USDTTest is BaseTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodePolygon.USDTCappedAdapterCode()];

  constructor()
    BaseTestV2(
      AaveV2PolygonAssets.USDT_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.USDTtoETHAdapterCode()
      })
    )
  {}
}

contract PolygonV2USDCTest is BaseTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodePolygon.USDCCappedAdapterCode()];

  constructor()
    BaseTestV2(
      AaveV2PolygonAssets.USDC_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.USDCtoETHAdapterCode()
      })
    )
  {}
}

contract PolygonV2DAITest is BaseTestV2 {
  bytes[] public preRequisiteAdapters = [CapAdaptersCodePolygon.DAICappedAdapterCode()];

  constructor()
    BaseTestV2(
      AaveV2PolygonAssets.DAI_ORACLE,
      ForkParams({network: 'polygon', blockNumber: 55697113}),
      AdapterParams({
        preRequisiteAdapters: preRequisiteAdapters,
        adapterCode: AdaptersEthBasedPolygon.DAItoETHAdapterCode()
      })
    )
  {}
}
