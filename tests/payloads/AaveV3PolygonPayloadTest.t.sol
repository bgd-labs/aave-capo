// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Polygon, AaveV3PolygonAssets} from 'aave-address-book/AaveV3Polygon.sol';

import {DeployPolygonAdaptersAndPayload, CapAdaptersCodePolygon} from '../../scripts/DeployPolygon.s.sol';
import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../../src/interfaces/IPriceCapAdapterStable.sol';

contract AaveV3PolygonPayloadTest is Test, DeployPolygonAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 54683775);
  }

  function test_AaveV3PolygonPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.USDT_ADAPTER_CODE
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.USDC_ADAPTER_CODE
    );

    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.DAI_ADAPTER_CODE
    );

    address maiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.MAI_ADAPTER_CODE
    );

    address wstEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.wstETH_ADAPTER_CODE
    );

    address stMaticPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.stMATIC_ADAPTER_CODE
    );

    address maticXPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodePolygon.MaticX_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3Polygon.ORACLE.getSourceOfAsset(AaveV3PolygonAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);
    assertFalse(IPriceCapAdapterStable(usdtNew).isCapped());

    address usdcNew = AaveV3Polygon.ORACLE.getSourceOfAsset(AaveV3PolygonAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);
    assertFalse(IPriceCapAdapterStable(usdcNew).isCapped());

    address daiNew = AaveV3Polygon.ORACLE.getSourceOfAsset(AaveV3PolygonAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);
    assertFalse(IPriceCapAdapterStable(daiNew).isCapped());

    address maiNew = AaveV3Polygon.ORACLE.getSourceOfAsset(AaveV3PolygonAssets.miMATIC_UNDERLYING);
    assertEq(maiNew, maiPredicted);
    assertFalse(IPriceCapAdapterStable(maiNew).isCapped());

    address wstEthNew = AaveV3Polygon.ORACLE.getSourceOfAsset(
      AaveV3PolygonAssets.wstETH_UNDERLYING
    );
    assertEq(wstEthNew, wstEthPredicted);
    assertFalse(IPriceCapAdapterStable(wstEthNew).isCapped());

    address stMaticNew = AaveV3Polygon.ORACLE.getSourceOfAsset(
      AaveV3PolygonAssets.stMATIC_UNDERLYING
    );
    assertEq(stMaticNew, stMaticPredicted);
    assertFalse(IPriceCapAdapter(stMaticNew).isCapped());

    address maticXNew = AaveV3Polygon.ORACLE.getSourceOfAsset(
      AaveV3PolygonAssets.MaticX_UNDERLYING
    );
    assertEq(maticXNew, maticXPredicted);
    assertFalse(IPriceCapAdapter(maticXNew).isCapped());
  }
}
