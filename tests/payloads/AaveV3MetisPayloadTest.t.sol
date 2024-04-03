// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AaveV3Metis, AaveV3MetisAssets} from 'aave-address-book/AaveV3Metis.sol';

import {DeployMetisAdaptersAndPayload, CapAdaptersCodeMetis} from '../../scripts/DeployMetis.s.sol';
import {IPriceCapAdapter} from '../../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../../src/interfaces/IPriceCapAdapterStable.sol';

contract AaveV3MetisPayloadTest is Test, DeployMetisAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('metis'), 15250523);
  }

  function test_AaveV3MetisPayload() public {
    address musdtPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeMetis.mUSDT_ADAPTER_CODE
    );

    address musdcPredicted = GovV3Helpers.predictDeterministicAddress(
      CapAdaptersCodeMetis.mUSDC_ADAPTER_CODE
    );

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);

    address musdtNew = AaveV3Metis.ORACLE.getSourceOfAsset(AaveV3MetisAssets.mUSDT_UNDERLYING);
    assertEq(musdtNew, musdtPredicted);
    assertFalse(IPriceCapAdapterStable(musdtNew).isCapped());

    address musdcNew = AaveV3Metis.ORACLE.getSourceOfAsset(AaveV3MetisAssets.mUSDC_UNDERLYING);
    assertEq(musdcNew, musdcPredicted);
    assertFalse(IPriceCapAdapterStable(musdcNew).isCapped());
  }
}
