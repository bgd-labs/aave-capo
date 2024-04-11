// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

import {DeployAvalancheAdaptersAndPayload, CapAdaptersCodeAvalanche} from '../../../scripts/AaveV2/DeployAvalanche.s.sol';

contract AaveV2AvalanchePayloadTest is Test, DeployAvalancheAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 44074529);
  }

  function test_AaveV2AvalanchePayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.USDTCappedAdapterCode()
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.USDCCappedAdapterCode()
    );

    address daiePredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.DAICappedAdapterCode()
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.USDTe_UNDERLYING
    );
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.USDCe_UNDERLYING
    );
    assertEq(usdcNew, usdcPredicted);

    address daieNew = AaveV2Avalanche.ORACLE.getSourceOfAsset(
      AaveV2AvalancheAssets.DAIe_UNDERLYING
    );
    assertEq(daieNew, daiePredicted);
  }
}
