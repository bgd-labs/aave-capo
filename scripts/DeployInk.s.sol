// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {InkScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3InkWhitelabel} from 'aave-address-book/AaveV3InkWhitelabel.sol';
import {FixedPriceAdapter} from '../src/contracts/misc-adapters/FixedPriceAdapter.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable, IChainlinkAggregator} from '../src/contracts/PriceCapAdapterStable.sol';

library CapAdaptersCodeInk {
  address public constant USDT_PRICE_FEED = 0x176A9536feaC0340de9f9811f5272E39E80b424f;

  function USDTAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3InkWhitelabel.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDT_PRICE_FEED),
            adapterDescription: 'Capped USDT/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDGAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(FixedPriceAdapter).creationCode,
        abi.encode(8, int256(1 * 1e8), 'Fixed USDG/USD')
      );
  }
}

contract DeployUSDGInk is InkScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeInk.USDGAdapterCode());
  }
}

contract DeployUSDTInk is InkScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeInk.USDTAdapterCode());
  }
}
