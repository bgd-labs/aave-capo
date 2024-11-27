// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {AvalancheScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Avalanche} from 'aave-address-book/AaveV3Avalanche.sol';

import {PriceCapAdapterStable} from '../src/contracts/PriceCapAdapterStable.sol';
import {IChainlinkAggregator} from '../src/interfaces/IPriceCapAdapter.sol';
import {IPriceCapAdapterStable} from '../src/interfaces/IPriceCapAdapterStable.sol';

library CapAdaptersCodeAvalanche {
  address public constant AUSD_PRICE_FEED = 0x5C2d58627Fbe746f5ea24Ef6D618f09f8e3f0122;

  function AUSDAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(PriceCapAdapterStable).creationCode,
        abi.encode(
          IPriceCapAdapterStable.CapAdapterStableParams({
            aclManager: AaveV3Avalanche.ACL_MANAGER,
            assetToUsdAggregator: IChainlinkAggregator(AUSD_PRICE_FEED),
            adapterDescription: 'Capped AUSD / USD',
            priceCap: int256(1.04 * 1e8)
          })
        )
      );
  }
}

contract DeployAUSDAvalanche is AvalancheScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeAvalanche.AUSDAdapterCode());
  }
}
