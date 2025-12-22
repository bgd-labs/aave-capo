// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {MantleScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Mantle} from 'aave-address-book/AaveV3Mantle.sol';
import {ChainlinkMantle} from 'aave-address-book/ChainlinkMantle.sol';
import {PriceCapAdapterStable, IPriceCapAdapterStable, IChainlinkAggregator} from '../src/contracts/PriceCapAdapterStable.sol';
import {CLRatePriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';
import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeMantle {
  function USDTAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Mantle.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(ChainlinkMantle.USDT_USD),
            adapterDescription: 'Capped USDT/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDCAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Mantle.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(ChainlinkMantle.USDC_USD),
            adapterDescription: 'Capped USDC/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function USDeAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Mantle.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(ChainlinkMantle.USDT_USD),
            adapterDescription: 'Capped USDe/USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }

  function sUSDeAdapterCode() internal pure returns (bytes memory) {
    // waiting params
  }
}

contract DeployUSDTMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.USDTAdapterCode());
  }
}

contract DeployUSDCMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.USDCAdapterCode());
  }
}

contract DeployUSDeMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.USDeAdapterCode());
  }
}

contract DeploySUSDeMantle is MantleScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeMantle.sUSDeAdapterCode());
  }
}
