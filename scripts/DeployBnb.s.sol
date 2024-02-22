// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BNBScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {AaveV3BnbPayload} from '../src/contracts/payloads/AaveV3BnbPayload.sol';

library CapAdaptersCodeBnb {
  bytes public constant USDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3BNB.ACL_MANAGER,
        AaveV3BNBAssets.USDT_ORACLE,
        'Capped USDT/USD',
        int256(1.02 * 1e6)
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3BNB.ACL_MANAGER,
        AaveV3BNBAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.02 * 1e6)
      )
    );
}

contract DeployBnbAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV3BnbPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeBnb.USDT_ADAPTER_CODE);
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeBnb.USDC_ADAPTER_CODE);

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV3BnbPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployBNB is BNBScript, DeployBnbAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
