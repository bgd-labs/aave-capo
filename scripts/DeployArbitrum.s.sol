// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ArbitrumScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Arbitrum, AaveV3ArbitrumAssets} from 'aave-address-book/AaveV3Arbitrum.sol';
import {BaseAggregatorsArbitrum} from 'cl-synchronicity-price-adapter/lib/BaseAggregatorsArbitrum.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3ArbitrumPayload} from '../src/contracts/payloads/AaveV3ArbitrumPayload.sol';

library CapAdaptersCodeArbitrum {
  bytes public constant USDT_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.USDT_ORACLE,
        'Capped USDT/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant DAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.DAI_ORACLE,
        'Capped DAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant LUSD_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.LUSD_ORACLE,
        'Capped LUSD/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant FRAX_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.FRAX_ORACLE,
        'Capped FRAX/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant rETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.WETH_ORACLE,
        BaseAggregatorsArbitrum.RETH_ETH_AGGREGATOR,
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
        AaveV3Arbitrum.ACL_MANAGER,
        AaveV3ArbitrumAssets.WETH_ORACLE,
        BaseAggregatorsArbitrum.WSTETH_STETH_AGGREGATOR,
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

contract DeployArbitrumAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV3ArbitrumPayload.Adapters memory adapters;

    adapters.usdtAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.USDT_ADAPTER_CODE
    );
    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.USDC_ADAPTER_CODE
    );
    adapters.daiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.DAI_ADAPTER_CODE
    );
    adapters.lusdAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.LUSD_ADAPTER_CODE
    );
    adapters.fraxAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.FRAX_ADAPTER_CODE
    );
    adapters.rEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.rETH_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeArbitrum.wstETH_ADAPTER_CODE
    );

    address payload = GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3ArbitrumPayload).creationCode, abi.encode(adapters))
    );

    return payload;
  }
}

contract DeployArbitrum is ArbitrumScript, DeployArbitrumAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
