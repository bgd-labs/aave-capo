// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {MetisScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Metis, AaveV3MetisAssets} from 'aave-address-book/AaveV3Metis.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {AaveV3MetisPayload} from '../src/contracts/payloads/AaveV3MetisPayload.sol';

library CapAdaptersCodeMetis {
  bytes public constant mUSDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Metis.ACL_MANAGER,
        AaveV3MetisAssets.mUSDT_ORACLE,
        'Capped mUSDT/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant mUSDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Metis.ACL_MANAGER,
        AaveV3MetisAssets.mUSDC_ORACLE,
        'Capped mUSDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant mDAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Metis.ACL_MANAGER,
        AaveV3MetisAssets.mDAI_ORACLE,
        'Capped mDAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
}

contract DeployMetis is MetisScript {
  function run() external broadcast {
    AaveV3MetisPayload.Adapters memory adapters;

    adapters.mUsdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMetis.mUSDT_ADAPTER_CODE
    );
    adapters.mUsdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeMetis.mUSDC_ADAPTER_CODE
    );
    adapters.mDaiAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeMetis.mDAI_ADAPTER_CODE);

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3MetisPayload).creationCode, abi.encode(adapters))
    );
  }
}
