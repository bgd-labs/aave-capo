// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {OptimismScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Optimism, AaveV3OptimismAssets} from 'aave-address-book/AaveV3Optimism.sol';
import {MiscOptimism} from 'aave-address-book/MiscOptimism.sol';

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
        int256(1.04 * 1e8)
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.04 * 1e8)
      )
    );
  bytes public constant DAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.DAI_ORACLE,
        'Capped DAI/USD',
        int256(1.04 * 1e8)
      )
    );
  bytes public constant LUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.LUSD_ORACLE,
        'Capped LUSD/USD',
        int256(1.04 * 1e8)
      )
    );
  bytes public constant sUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.sUSD_ORACLE,
        'Capped sUSD/USD',
        int256(1.04 * 1e8)
      )
    );
  bytes public constant rETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.WETH_ORACLE,
        MiscOptimism.rETH_ETH_AGGREGATOR,
        'Capped rETH / ETH / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1098211995352594225,
          snapshotTimestamp: 1703743921,
          maxYearlyRatioGrowthPercent: 9_30
        })
      )
    );
  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Optimism.ACL_MANAGER,
        AaveV3OptimismAssets.WETH_ORACLE,
        MiscOptimism.wstETH_stETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1157105995453941980,
          snapshotTimestamp: 1707992685,
          maxYearlyRatioGrowthPercent: 9_68
        })
      )
    );
}

contract DeployOptimismAdaptersAndPayload {
  function _deploy() internal returns (address) {
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

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV3OptimismPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployOptimism is OptimismScript, DeployOptimismAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
