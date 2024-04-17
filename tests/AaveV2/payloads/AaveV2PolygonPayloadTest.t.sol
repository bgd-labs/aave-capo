// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';

import {ProtocolV2TestBase} from 'aave-helpers/ProtocolV2TestBase.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';

import {DeployPolygonAdaptersAndPayload, AdaptersEthBasedPolygon} from '../../../scripts/AaveV2/DeployPolygon.s.sol';

contract AaveV2PolygonPayloadTest is ProtocolV2TestBase, DeployPolygonAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 55709767);
  }

  function test_defaultProposalExecution() public {
    address payload = _deploy();

    defaultTest('AaveV2Polygon_SetPriceCapAdapters', AaveV2Polygon.POOL, payload);
  }

  function test_AaveV2PolygonPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedPolygon.USDTtoETHAdapterCode()
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedPolygon.USDCtoETHAdapterCode()
    );

    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedPolygon.DAItoETHAdapterCode()
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV2Polygon.ORACLE.getSourceOfAsset(AaveV2PolygonAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV2Polygon.ORACLE.getSourceOfAsset(AaveV2PolygonAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address daiNew = AaveV2Polygon.ORACLE.getSourceOfAsset(AaveV2PolygonAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);
  }
}
