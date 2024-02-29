// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

import {DeployEthereumAdaptersAndPayload, CapAdaptersCodeEthereum, CapAdaptersStablesCodeEthereum} from '../../scripts/DeployEthereum.s.sol';

contract AaveV3EthereumPayloadTest is Test, DeployEthereumAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19284368);
  }

  function test_AaveV3EthereumPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.USDT_ADAPTER_CODE
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.USDC_ADAPTER_CODE
    );

    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.DAI_ADAPTER_CODE
    );

    address sdaiPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeEthereum.sDAI_ADAPTER_CODE
    );

    address lusdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.LUSD_ADAPTER_CODE
    );

    address fraxPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.FRAX_ADAPTER_CODE
    );

    address crvUsdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.crvUSD_ADAPTER_CODE
    );

    address pyUsdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersStablesCodeEthereum.pyUSD_ADAPTER_CODE
    );

    address cbEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeEthereum.cbETH_ADAPTER_CODE
    );

    address rEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeEthereum.rETH_ADAPTER_CODE
    );

    address wstEthPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeEthereum.wstETH_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address daiNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);

    address sdaiNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.sDAI_UNDERLYING);
    assertEq(sdaiNew, sdaiPredicted);

    address lusdNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.LUSD_UNDERLYING);
    assertEq(lusdNew, lusdPredicted);

    address fraxNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.FRAX_UNDERLYING);
    assertEq(fraxNew, fraxPredicted);

    address crvUsdNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(
      AaveV3EthereumAssets.crvUSD_UNDERLYING
    );
    assertEq(crvUsdNew, crvUsdPredicted);

    address pyUsdNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(
      AaveV3EthereumAssets.PYUSD_UNDERLYING
    );
    assertEq(pyUsdNew, pyUsdPredicted);

    address cbEthNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(
      AaveV3EthereumAssets.cbETH_UNDERLYING
    );
    assertEq(cbEthNew, cbEthPredicted);

    address rEthNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(AaveV3EthereumAssets.rETH_UNDERLYING);
    assertEq(rEthNew, rEthPredicted);

    address wstEthNew = AaveV3Ethereum.ORACLE.getSourceOfAsset(
      AaveV3EthereumAssets.wstETH_UNDERLYING
    );
    assertEq(wstEthNew, wstEthPredicted);
  }
}
