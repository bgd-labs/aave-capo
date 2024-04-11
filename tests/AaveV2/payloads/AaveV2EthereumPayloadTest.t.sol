// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';

import {DeployEthereumAdaptersAndPayload, AdaptersEthBasedEthereum} from '../../../scripts/AaveV2/DeployEthereum.s.sol';

contract AaveV2EthereumPayloadTest is Test, DeployEthereumAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19633928);
  }

  function test_AaveV2EthereumPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.USDTtoETHAdapterCode()
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.USDCtoETHAdapterCode()
    );

    address daiPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.DAItoETHAdapterCode()
    );

    address usdpPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.USDPtoETHAdapterCode()
    );

    address fraxPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.FRAXtoETHAdapterCode()
    );

    address tusdPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.TUSDtoETHAdapterCode()
    );

    address lusdPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.LUSDtoETHAdapterCode()
    );

    address busdPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.BUSDtoETHAdapterCode()
    );

    address susdPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.sUSDtoETHAdapterCode()
    );

    address ustPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.USTtoETHAdapterCode()
    );

    address dpiPredicted = GovV3Helpers.predictDeterministicAddress(
      AdaptersEthBasedEthereum.DPItoETHAdapterCode()
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);

    address usdcNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);

    address daiNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.DAI_UNDERLYING);
    assertEq(daiNew, daiPredicted);

    address usdpNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.USDP_UNDERLYING);
    assertEq(usdpNew, usdpPredicted);

    address fraxNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.FRAX_UNDERLYING);
    assertEq(fraxNew, fraxPredicted);

    address tusdNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.TUSD_UNDERLYING);
    assertEq(tusdNew, tusdPredicted);

    address lusdNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.LUSD_UNDERLYING);
    assertEq(lusdNew, lusdPredicted);

    address busdNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.BUSD_UNDERLYING);
    assertEq(busdNew, busdPredicted);

    address susdNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.sUSD_UNDERLYING);
    assertEq(susdNew, susdPredicted);

    address ustNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.UST_UNDERLYING);
    assertEq(ustNew, ustPredicted);

    address dpiNew = AaveV2Ethereum.ORACLE.getSourceOfAsset(AaveV2EthereumAssets.DPI_UNDERLYING);
    assertEq(dpiNew, dpiPredicted);
  }
}
