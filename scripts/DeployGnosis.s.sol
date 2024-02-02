// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {GnosisScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {SDAIGnosisPriceCapAdapter} from '../src/contracts/SDAIGnosisPriceCapAdapter.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3GnosisPayload} from '../src/contracts/payloads/AaveV3GnosisPayload.sol';

library CapAdaptersCodeGnosis {
  // TODO: move it to address book
  address public constant WSTETH_STETH_AGGREGATOR = 0x0064AC007fF665CF8D0D3Af5E0AD1c26a3f853eA;
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant WXDAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WXDAI_ORACLE,
        'Capped wXDAI/USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );
  bytes public constant sDAI_ADAPTER_CODE =
    abi.encodePacked(
      type(SDAIGnosisPriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WXDAI_ORACLE,
        AaveV3GnosisAssets.sDAI_UNDERLYING,
        'Capped sDAI / DAI / USD',
        int256(1.1 * 1e8) // TODO: SET
      )
    );

  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WETH_ORACLE,
        WSTETH_STETH_AGGREGATOR,
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

contract DeployGnosis is GnosisScript {
  function run() external broadcast {
    AaveV3GnosisPayload.Adapters memory adapters;

    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeGnosis.USDC_ADAPTER_CODE
    );
    adapters.wxDaiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeGnosis.WXDAI_ADAPTER_CODE
    );
    adapters.sDaiAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeGnosis.sDAI_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeGnosis.wstETH_ADAPTER_CODE
    );

    GovV3Helpers.deployDeterministic(
      abi.encode(type(AaveV3GnosisPayload).creationCode, abi.encode(adapters))
    );
  }
}
