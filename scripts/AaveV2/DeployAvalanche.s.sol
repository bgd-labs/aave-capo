// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AvalancheScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';
import {AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';

import {PriceCapAdapterStable} from '../../src/contracts/PriceCapAdapterStable.sol';
import {AaveV2AvalanchePayload} from '../../src/contracts/payloads/AaveV2/AaveV2AvalanchePayload.sol';

library CapAdaptersCodeAvalanche {
  function USDTCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Avalanche.ACL_MANAGER,
          AaveV2AvalancheAssets.USDTe_ORACLE,
          'Capped USDT / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function USDCCappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Avalanche.ACL_MANAGER,
          AaveV2AvalancheAssets.USDCe_ORACLE,
          'Capped USDC / USD',
          int256(1.04 * 1e8)
        )
      );
  }

  function DAICappedAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          AaveV3Avalanche.ACL_MANAGER,
          AaveV2AvalancheAssets.DAIe_ORACLE,
          'Capped DAI / USD',
          int256(1.04 * 1e8)
        )
      );
  }
}

contract DeployAvalancheAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV2AvalanchePayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.USDTCappedAdapterCode()
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.USDCCappedAdapterCode()
    );
    adapters.daieAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.DAICappedAdapterCode()
    );

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV2AvalanchePayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployAvalanche is AvalancheScript, DeployAvalancheAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
