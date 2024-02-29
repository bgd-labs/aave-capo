// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';

import {DeployAvalancheAdaptersAndPayload, CapAdaptersCodeAvalanche} from '../../scripts/DeployAvalanche.s.sol';

contract AaveV3AvalanchePayloadTest is Test, DeployAvalancheAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 42013694);
  }

  function test_AaveV3AvalanchePayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.USDt_ADAPTER_CODE
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.USDC_ADAPTER_CODE
    );

    address daiePredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.DAIe_ADAPTER_CODE
    );

    address fraxPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.FRAX_ADAPTER_CODE
    );

    address savaxPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeAvalanche.sAVAX_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3Avalanche.ORACLE.getSourceOfAsset(
      AaveV3AvalancheAssets.USDt_UNDERLYING
    );
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV3Avalanche.ORACLE.getSourceOfAsset(
      AaveV3AvalancheAssets.USDC_UNDERLYING
    );
    assertEq(usdcNew, usdcPredicted);

    address daieNew = AaveV3Avalanche.ORACLE.getSourceOfAsset(
      AaveV3AvalancheAssets.DAIe_UNDERLYING
    );
    assertEq(daieNew, daiePredicted);

    address fraxNew = AaveV3Avalanche.ORACLE.getSourceOfAsset(
      AaveV3AvalancheAssets.FRAX_UNDERLYING
    );
    assertEq(fraxNew, fraxPredicted);

    address savaxNew = AaveV3Avalanche.ORACLE.getSourceOfAsset(
      AaveV3AvalancheAssets.sAVAX_UNDERLYING
    );
    assertEq(savaxNew, savaxPredicted);
  }
}
