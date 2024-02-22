// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {MiscBase} from 'aave-address-book/MiscBase.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3BasePayload} from '../src/contracts/payloads/AaveV3BasePayload.sol';

library CapAdaptersCodeBase {
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.02 * 1e8) // TODO: SET
      )
    );

  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.WETH_ORACLE,
        MiscBase.wstETH_stETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1156993146835803417,
          snapshotTimestamp: 1707962603, //15-02-2024
          maxYearlyRatioGrowthPercent: 8_72
        })
      )
    );
  bytes public constant cbETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.WETH_ORACLE,
        MiscBase.cbETH_ETH_AGGREGATOR,
        'Capped cbETH / ETH / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1063814269953974334,
          snapshotTimestamp: 1707962603, // 15-02-2024
          maxYearlyRatioGrowthPercent: 7_04
        })
      )
    );
}

contract DeployBaseAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV3BasePayload.Adapters memory adapters;

    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(CapAdaptersCodeBase.USDC_ADAPTER_CODE);
    adapters.cbEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeBase.cbETH_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeBase.wstETH_ADAPTER_CODE
    );

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV3BasePayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployBase is BaseScript, DeployBaseAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
