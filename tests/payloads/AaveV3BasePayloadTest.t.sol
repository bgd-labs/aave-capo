// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';

import {DeployBaseAdaptersAndPayload, CapAdaptersCodeBase} from '../../scripts/DeployBase.s.sol';

contract AaveV3BasePayloadTest is Test, DeployBaseAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('base'), 10915170);
  }

  function test_AaveV3BasePayload() public {
    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBase.USDC_ADAPTER_CODE
    );

    address wstETHPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBase.wstETH_ADAPTER_CODE
    );

    address cbETHPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBase.cbETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdcNew = AaveV3Base.ORACLE.getSourceOfAsset(AaveV3BaseAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address wstETHNew = AaveV3Base.ORACLE.getSourceOfAsset(AaveV3BaseAssets.wstETH_UNDERLYING);
    assertEq(wstETHNew, wstETHPredicted);

    address cbETHNew = AaveV3Base.ORACLE.getSourceOfAsset(AaveV3BaseAssets.cbETH_UNDERLYING);
    assertEq(cbETHNew, cbETHPredicted);
  }
}
