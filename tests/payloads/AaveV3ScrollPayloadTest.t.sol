// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';

import {DeployScrollAdaptersAndPayload, CapAdaptersCodeScroll} from '../../scripts/DeployScroll.s.sol';

contract AaveV3ScrollPayloadTest is Test, DeployScrollAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('scroll'), 4005049);
  }

  function test_AaveV3ScrollPayload() public {
    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeScroll.USDC_ADAPTER_CODE
    );

    address wstETHPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeScroll.wstETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdcNew = AaveV3Scroll.ORACLE.getSourceOfAsset(AaveV3ScrollAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address wstETHNew = AaveV3Scroll.ORACLE.getSourceOfAsset(AaveV3ScrollAssets.wstETH_UNDERLYING);
    assertEq(wstETHNew, wstETHPredicted);
  }
}
