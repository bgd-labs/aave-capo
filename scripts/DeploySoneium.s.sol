// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {SoneiumScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Soneium} from 'aave-address-book/AaveV3Soneium.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';

library CapAdaptersCodeSoneium {
  address public constant USDC_PRICE_FEED = 0x46522a7fD5bD5E7aaFF862C17E116152e07d7158;
  address public constant USDT_PRICE_FEED = 0xE92d289831823c96C22592952C1cfA2584a65038;

  function USDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Soneium.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDC_PRICE_FEED),
            adapterDescription: 'Capped USDC / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDTAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Soneium.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDT_PRICE_FEED),
            adapterDescription: 'Capped USDT / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }
}

contract DeployUSDCSoneium is SoneiumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeSoneium.USDCAdapterCode());
  }
}

contract DeployUSDTSoneium is SoneiumScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeSoneium.USDTAdapterCode());
  }
}
