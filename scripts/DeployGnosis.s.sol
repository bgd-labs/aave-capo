// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {GnosisScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';
import {MiscGnosis} from 'aave-address-book/MiscGnosis.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {SDAIGnosisPriceCapAdapter} from '../src/contracts/SDAIGnosisPriceCapAdapter.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3GnosisPayload} from '../src/contracts/payloads/AaveV3GnosisPayload.sol';

library CapAdaptersCodeGnosis {
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.04 * 1e8)
      )
    );
  bytes public constant WXDAI_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WXDAI_ORACLE,
        'Capped wXDAI/USD',
        int256(1.04 * 1e8)
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
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1041259405371548076, // TODO: please recheck
          snapshotTimestamp: 1707988835,
          maxYearlyRatioGrowthPercent: 10_15
        })
      )
    );

  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Gnosis.ACL_MANAGER,
        AaveV3GnosisAssets.WETH_ORACLE,
        MiscGnosis.wstETH_stETH_AGGREGATOR,
        'Capped wstETH / stETH(ETH) / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1157105995453941980,
          snapshotTimestamp: 1707988835,
          maxYearlyRatioGrowthPercent: 9_68
        })
      )
    );
}

contract DeployGnosisAdaptersAndPayload {
  function _deploy() internal returns (address) {
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

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV3GnosisPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployGnosis is GnosisScript, DeployGnosisAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
