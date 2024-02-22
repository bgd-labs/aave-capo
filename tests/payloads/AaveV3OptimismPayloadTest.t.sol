// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';

import {DeployOptimismAdaptersAndPayload, CapAdaptersCodeOptimism} from '../../scripts/DeployOptimism.s.sol';

contract AaveV3OptimismPayloadTest is Test, DeployOptimismAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 116510489);
  }

  function test_AaveV3OptimismPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.USDT_ADAPTER_CODE
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.USDC_ADAPTER_CODE
    );

    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.DAI_ADAPTER_CODE
    );

    address lusdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.LUSD_ADAPTER_CODE
    );

    address susdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.sUSD_ADAPTER_CODE
    );

    address rethPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.rETH_ADAPTER_CODE
    );

    address wstEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeOptimism.wstETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address daiNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);

    address lusdNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.LUSD_UNDERLYING);
    assertEq(lusdNew, lusdPredicted);

    address susdNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.sUSD_UNDERLYING);
    assertEq(susdNew, susdPredicted);

    address rethNew = AaveV3Optimism.ORACLE.getSourceOfAsset(AaveV3OptimismAssets.rETH_UNDERLYING);
    assertEq(rethNew, rethPredicted);

    address wstEthNew = AaveV3Optimism.ORACLE.getSourceOfAsset(
      AaveV3OptimismAssets.wstETH_UNDERLYING
    );
    assertEq(wstEthNew, wstEthPredicted);
  }
}
