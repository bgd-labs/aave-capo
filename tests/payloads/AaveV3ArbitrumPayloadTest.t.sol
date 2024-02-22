// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';

import {DeployArbitrumAdaptersAndPayload, CapAdaptersCodeArbitrum} from '../../scripts/DeployArbitrum.s.sol';

contract AaveV3ArbitrumPayloadTest is Test, DeployArbitrumAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 183394362);
  }

  function test_AaveV3ArbitrumPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.USDT_ADAPTER_CODE
    );
    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.USDC_ADAPTER_CODE
    );
    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.DAI_ADAPTER_CODE
    );
    address lusdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.LUSD_ADAPTER_CODE
    );
    address fraxPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.FRAX_ADAPTER_CODE
    );
    address rethPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.rETH_ADAPTER_CODE
    );
    address wstEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeArbitrum.wstETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address daiNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);

    address lusdNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.LUSD_UNDERLYING);
    assertEq(lusdNew, lusdPredicted);

    address fraxNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.FRAX_UNDERLYING);
    assertEq(fraxNew, fraxPredicted);

    address rethNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(AaveV3ArbitrumAssets.rETH_UNDERLYING);
    assertEq(rethNew, rethPredicted);

    address wstEthNew = AaveV3Arbitrum.ORACLE.getSourceOfAsset(
      AaveV3ArbitrumAssets.wstETH_UNDERLYING
    );
    assertEq(wstEthNew, wstEthPredicted);
  }
}
