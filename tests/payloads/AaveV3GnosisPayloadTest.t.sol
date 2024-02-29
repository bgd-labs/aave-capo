// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';

import {DeployGnosisAdaptersAndPayload, CapAdaptersCodeGnosis} from '../../scripts/DeployGnosis.s.sol';

contract AaveV3GnosisPayloadTest is Test, DeployGnosisAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('gnosis'), 32577034);
  }

  function test_AaveV3GnosisPayload() public {
    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeGnosis.USDC_ADAPTER_CODE
    );

    address wxdaiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeGnosis.WXDAI_ADAPTER_CODE
    );

    address sdaiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeGnosis.sDAI_ADAPTER_CODE
    );

    address wstEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeGnosis.wstETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdcNew = AaveV3Gnosis.ORACLE.getSourceOfAsset(AaveV3GnosisAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address wxdaiNew = AaveV3Gnosis.ORACLE.getSourceOfAsset(AaveV3GnosisAssets.WXDAI_UNDERLYING);
    assertEq(wxdaiNew, wxdaiPredicted);

    address sdaiNew = AaveV3Gnosis.ORACLE.getSourceOfAsset(AaveV3GnosisAssets.sDAI_UNDERLYING);
    assertEq(sdaiNew, sdaiPredicted);

    address wstEthNew = AaveV3Gnosis.ORACLE.getSourceOfAsset(AaveV3GnosisAssets.wstETH_UNDERLYING);
    assertEq(wstEthNew, wstEthPredicted);
  }
}
