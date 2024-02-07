// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BaseScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Base, AaveV3BaseAssets} from 'aave-address-book/AaveV3Base.sol';
import {BaseAggregatorsBase} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsBase.sol';

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
        int256(1.1 * 1e8) // TODO: SET
      )
    );

  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.WETH_ORACLE,
        BaseAggregatorsBase.WSTETH_STETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD', // TODO: is it actually going to STETH, but then using ETH feed
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1151642949000000000,
          snapshotTimestamp: 1703743921,
          maxYearlyRatioGrowthPercent: 10_00
        })
      )
    );
  bytes public constant cbETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Base.ACL_MANAGER,
        AaveV3BaseAssets.WETH_ORACLE,
        BaseAggregatorsBase.CBETH_ETH_AGGREGATOR,
        'Capped cbETH / ETH / USD', // TODO: is it actually going to STETH, but then using ETH feed
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1059523963000000000,
          snapshotTimestamp: 1703743921,
          maxYearlyRatioGrowthPercent: 10_00
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
