// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

import {DeployAvalancheAdaptersAndPayload} from '../../../scripts/AaveV2/DeployAvalanche.s.sol';
import {AaveV2AvalanchePayload} from '../../../src/contracts/payloads/AaveV2/AaveV2AvalanchePayload.sol';

contract AaveV2AvalanchePayloadTest is Test, DeployAvalancheAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 44074529);
  }

  function test_AaveV2AvalanchePayload() public {
    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.USDTe_UNDERLYING
    );
    assertEq(usdtNew, AaveV2AvalanchePayload(payload).USDT_ADAPTER());

    address usdcNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.USDCe_UNDERLYING
    );
    assertEq(usdcNew, AaveV2AvalanchePayload(payload).USDC_ADAPTER());

    address daieNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.DAIe_UNDERLYING
    );
    assertEq(daieNew, AaveV2AvalanchePayload(payload).DAIe_ADAPTER());
  }
}
