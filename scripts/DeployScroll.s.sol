// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ScrollScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {AaveV3ScrollPayload} from '../src/contracts/payloads/AaveV3ScrollPayload.sol';

library CapAdaptersCodeScroll {
  bytes public constant USDC_ADAPTER_CODE =
    abi.encodePacked(
      type(PriceCapAdapterStable).creationCode,
      abi.encode(
        AaveV3Scroll.ACL_MANAGER,
        AaveV3ScrollAssets.USDC_ORACLE,
        'Capped USDC/USD',
        int256(1.04 * 1e8)
      )
    );

  bytes public constant wstETH_ADAPTER_CODE =
    abi.encodePacked(
      type(CLRatePriceCapAdapter).creationCode,
      abi.encode(
        AaveV3Scroll.ACL_MANAGER,
        AaveV3ScrollAssets.WETH_ORACLE,
        0xE61Da4C909F7d86797a0D06Db63c34f76c9bCBDC,
        'Capped wstETH / stETH(ETH) / USD',
        7 days,
        IPriceCapAdapter.PriceCapUpdateParams({
          snapshotRatio: 1157631222242093480,
          snapshotTimestamp: 1708459390, //20-02-2024
          maxYearlyRatioGrowthPercent: 9_68
        })
      )
    );
}

contract DeployScrollAdaptersAndPayload {
  function _deploy() internal returns (address) {
    AaveV3ScrollPayload.Adapters memory adapters;

    adapters.usdcAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeScroll.USDC_ADAPTER_CODE
    );
    adapters.wstEthAdapter = GovV3Helpers.deployDeterministic(
      CapAdaptersCodeScroll.wstETH_ADAPTER_CODE
    );

    return
      GovV3Helpers.deployDeterministic(
        abi.encodePacked(type(AaveV3ScrollPayload).creationCode, abi.encode(adapters))
      );
  }
}

contract DeployScroll is ScrollScript, DeployScrollAdaptersAndPayload {
  function run() external broadcast {
    _deploy();
  }
}
