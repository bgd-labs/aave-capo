// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {SonicScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Sonic, AaveV3SonicAssets} from 'aave-address-book/AaveV3Sonic.sol';
import {StSPriceCapAdapter} from '../src/contracts/lst-adapters/StSPriceCapAdapter.sol';
import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeSonic {
  address public constant StS = 0xE5DA20F15420aD15DE0fa650600aFc998bbE3955;

  function stSAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(StSPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Sonic.ACL_MANAGER,
            baseAggregatorAddress: AaveV3SonicAssets.wS_ORACLE,
            ratioProviderAddress: StS,
            pairDescription: 'Capped stS / S / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_014594985698922305,
              snapshotTimestamp: 1742981173, // 06th of March 2025
              maxYearlyRatioGrowthPercent: 11_04
            })
          })
        )
      );
  }
}

contract DeployStSSonic is SonicScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeSonic.stSAdapterCode());
  }
}
