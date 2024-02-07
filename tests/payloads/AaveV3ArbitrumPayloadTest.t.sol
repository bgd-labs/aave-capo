// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import 'forge-std/console.sol';
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';

import {DeployArbitrumAdaptersAndPayload} from '../../scripts/DeployArbitrum.s.sol';

contract AaveV3ArbitrumPayloadTest is Test, DeployArbitrumAdaptersAndPayload {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 178315580);
  }

  function test_AaveV3ArbitrumPayload() public {
    // predict addresses

    address payload = _deploy();

    GovV3Helpers.executePayload(vm, payload);
  }
}
