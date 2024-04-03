// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

import {DeployBnbAdaptersAndPayload, CapAdaptersCodeBnb} from '../../scripts/DeployBnb.s.sol';
import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../../src/interfaces/IPriceCapAdapterStable.sol';

contract AaveV3BnbPayloadTest is Test, DeployBnbAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('bnb'), 36987594);
  }

  function test_AaveV3BnbPayload() public {
    address usdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBnb.USDT_ADAPTER_CODE
    );

    address usdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBnb.USDC_ADAPTER_CODE
    );

    address fdusdPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeBnb.FDUSD_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address usdtNew = AaveV3BNB.ORACLE.getSourceOfAsset(AaveV3BNBAssets.USDT_UNDERLYING);
    assertEq(usdtNew, usdtPredicted);
    assertFalse(IPriceCapAdapterStable(usdtNew).isCapped());

    address usdcNew = AaveV3BNB.ORACLE.getSourceOfAsset(AaveV3BNBAssets.USDC_UNDERLYING);
    assertEq(usdcNew, usdcPredicted);
    assertFalse(IPriceCapAdapterStable(usdcNew).isCapped());

    address fdusdNew = AaveV3BNB.ORACLE.getSourceOfAsset(AaveV3BNBAssets.FDUSD_UNDERLYING);
    assertEq(fdusdNew, fdusdPredicted);
    assertFalse(IPriceCapAdapterStable(fdusdNew).isCapped());
  }
}
