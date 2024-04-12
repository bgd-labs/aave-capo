// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AvalancheScript} from 'aave-helpers/ScriptUtils.sol';

import {AaveV2AvalanchePayload} from '../../src/contracts/payloads/AaveV2/AaveV2AvalanchePayload.sol';

contract DeployAvalancheAdaptersAndPayload {
  function _deploy() internal returns (address) {
    return
      GovV3Helpers.deployDeterministic(abi.encodePacked(type(AaveV2AvalanchePayload).creationCode));
  }
}

contract DeployAvalanche is AvalancheScript, DeployAvalancheAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
