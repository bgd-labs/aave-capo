// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AvalancheScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Avalanche, AaveV3AvalancheAssets} from 'aave-address-book/AaveV3Avalanche.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {SAvaxPriceCapAdapter, IPriceCapAdapter} from '../src/contracts/SAvaxPriceCapAdapter.sol';
import {AaveV3AvalanchePayload} from '../src/contracts/payloads/AaveV3AvalanchePayload.sol';

library CapAdaptersCodeAvalanche {
  bytes public constant USDt_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.USDt_ORACLE,
        'Capped USDt/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant DAIe_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.DAIe_ORACLE,
        'Capped DAI.e/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant FRAX_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.FRAX_ORACLE,
        'Capped FRAX/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );

  bytes public constant sAVAX_ADAPTER_CODE =
    abi.encodePacked(
      type(SAvaxPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Avalanche.ACL_MANAGER,
        AaveV3AvalancheAssets.WAVAX_ORACLE,
        AaveV3AvalancheAssets.sAVAX_UNDERLYING,
        'Capped sAVAX / AVAX / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
}

contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    AaveV3AvalanchePayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.USDt_ADAPTER_CODE
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.USDC_ADAPTER_CODE
    );
    adapters.daieAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.DAIe_ADAPTER_CODE
    );
    adapters.fraxAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.FRAX_ADAPTER_CODE
    );
    adapters.sAvaxAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeAvalanche.sAVAX_ADAPTER_CODE
    );

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3AvalanchePayload).creationCode, abi.encode(adapters))
    );
  }
}
