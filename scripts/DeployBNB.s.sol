// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {BNBScript} from 'aave-helpers/ScriptUtils.sol';
import {AaveV3BNB, AaveV3BNBAssets} from 'aave-address-book/AaveV3BNB.sol';

import {BNBxPriceCapAdapter} from '../src/contracts/lst-adapters/BNBxPriceCapAdapter.sol';
import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeBNB {
  address public constant STADER_STAKE_MANAGER = 0x7276241a669489E4BBB76f63d2A43Bfe63080F2F;

  function BNBxAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(BNBxPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3BNB.ACL_MANAGER,
            baseAggregatorAddress: AaveV3BNBAssets.WBNB_ORACLE,
            ratioProviderAddress: STADER_STAKE_MANAGER,
            pairDescription: 'Capped BNBx / BNB / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1092086785002882857,
              snapshotTimestamp: 1722567630, // 2nd of August 2024
              maxYearlyRatioGrowthPercent: 12_00
            })
          })
        )
      );
  }
}

contract DeployBnbXBNB is BNBScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeBNB.BNBxAdapterCode());
  }
}
