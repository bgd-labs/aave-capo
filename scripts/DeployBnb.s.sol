// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BNBScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3Bnb.sol';

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
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3BNB.ACL_MANAGER,
        AaveV3BNBAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
}

contract DeployBNB is BNBScript {
  function run() external broadcast {
    AaveV3BnbPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeBnb.USDT_ADAPTER_CODE);
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeBnb.USDC_ADAPTER_CODE);

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3BnbPayload).creationCode, abi.encode(adapters))
    );
  }
}
