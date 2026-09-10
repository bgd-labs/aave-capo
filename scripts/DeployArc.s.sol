// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ArcScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {MiscArc} from "aave-address-book/MiscArc.sol";
import {IACLManager} from "aave-address-book/AaveV3.sol";

import {PriceCapAdapterStable, IPriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {EURPriceCapAdapterStable, IEURPriceCapAdapterStable} from '../src/contracts/misc-adapters/EURPriceCapAdapterStable.sol';
import {IChainlinkAggregator} from '../src/interfaces/IChainlinkAggregator.sol';


library CapAdaptersCodeArc {
  address public constant USDC_SVR_USD_PRICE_FEED = 0xBC88A5182848151AE1f7b4877021F828d8F4D735;
  address public constant EURC_SVR_USD_PRICE_FEED = 0x71B0305ACA6A29d6485f9e4ac5a333af5Df2b62c;
  address public constant EUR_SVR_USD_PRICE_FEED = 0xa4266689D107aF71c7dBE975cfB92aB40E7b4EFE;

  function USDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: IACLManager(MiscArc.ACL_MANAGER),
            assetToUsdAggregator: IChainlinkAggregator(USDC_SVR_USD_PRICE_FEED),
            adapterDescription: 'Capped USDC/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function EURCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(EURPriceCapAdapterStable).creationCode,
        abi.encode(
          IEURPriceCapAdapterStable.CapAdapterStableParamsEUR({
            aclManager: IACLManager(MiscArc.ACL_MANAGER),
            assetToUsdAggregator: IChainlinkAggregator(EURC_SVR_USD_PRICE_FEED),
            baseToUsdAggregator: IChainlinkAggregator(EUR_SVR_USD_PRICE_FEED),
            adapterDescription: 'Capped EURC/USD',
            priceCapRatio: int256(1.04 * 1e8),
            ratioDecimals: 8
          })
        )
      );
  }
}

contract DeployUSDCArc is ArcScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArc.USDCAdapterCode());
  }
}

contract DeployEURCArc is ArcScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeArc.EURCAdapterCode());
  }
}
