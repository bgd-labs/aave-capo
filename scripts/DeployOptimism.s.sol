// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {OptimismScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {BaseAggregatorsOptimism} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsOptimism.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3OptimismPayload} from '../src/contracts/payloads/AaveV3OptimismPayload.sol';

library CapAdaptersCodeOptimism {
  bytes public constant USDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.USDT_ORACLE,
        'Capped USDT/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant DAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.DAI_ORACLE,
        'Capped DAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant LUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.LUSD_ORACLE,
        'Capped LUSD/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant sUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.sUSD_ORACLE,
        'Capped sUSD/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant rETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.WETH_ORACLE,
        BaseAggregatorsOptimism.RETH_ETH_AGGREGATOR,
        'Capped rETH / ETH / USD',
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.WETH_ORACLE,
        BaseAggregatorsOptimism.WSTETH_STETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD', // TODO: is it actually going to STETH, but then using ETH feed
        7 days, // TODO: SET
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 0,
          snapshotTimestamp: 0,
          maxYearlyRatioGrowthPercent: 0
        })
      )
    );
}

contract DeployOptimism is OptimismScript {
  function run() external broadcast {
    AaveV3OptimismPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.USDT_ADAPTER_CODE
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.USDC_ADAPTER_CODE
    );
    adapters.daiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.DAI_ADAPTER_CODE
    );
    adapters.lusdAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.LUSD_ADAPTER_CODE
    );
    adapters.sUsdAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.sUSD_ADAPTER_CODE
    );
    adapters.rEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.rETH_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeOptimism.wstETH_ADAPTER_CODE
    );

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3OptimismPayload).creationCode, abi.encode(adapters))
    );
  }
}
