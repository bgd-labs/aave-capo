// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {MantleScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Mantle} from 'aave-address-book/AaveV3Mantle.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IPriceCapAdapter, IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeMantle {
  address public constant USDC_PRICE_FEED = 0x22b422CECb0D4Bd5afF3EA999b048FA17F5263bD;
  address public constant USDT_PRICE_FEED = 0xd86048D5e4fe96157CE03Ae519A9045bEDaa6551;

  function USDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Mantle.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDC_PRICE_FEED),
            adapterDescription: 'Capped USDC/USD',
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
            aclManager: AaveV3Mantle.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(USDT_PRICE_FEED),
            adapterDescription: 'Capped USDT/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }
}

contract DeployUSDCMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.USDCAdapterCode());
  }
}

contract DeployUSDTMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.USDTAdapterCode());
  }
}

