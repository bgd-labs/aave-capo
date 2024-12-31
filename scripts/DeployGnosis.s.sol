// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {GnosisScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';

import {sDAIGnosisPriceCapAdapter} from '../src/contracts/lst-adapters/sDAIGnosisPriceCapAdapter.sol';
import {OsGNOPriceCapAdapter} from '../src/contracts/lst-adapters/OsGNOPriceCapAdapter.sol';
import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeGnosis {
  address public constant DAI_PRICE_FEED = 0x678df3415fc31947dA4324eC63212874be5a82f8;
  address public constant OSGNO_RATE = 0x9B1b13afA6a57e54C03AD0428a4766C39707D272;

  function sDAIAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(sDAIGnosisPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Gnosis.ACL_MANAGER,
            baseAggregatorAddress: DAI_PRICE_FEED,
            ratioProviderAddress: AaveV3GnosisAssets.sDAI_UNDERLYING,
            pairDescription: 'Capped sDAI / DAI / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1_118618102334074883,
              snapshotTimestamp: 1729423540,
              maxYearlyRatioGrowthPercent: 9_69
            })
          })
        )
      );
  }

  function osGNOAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(OsGNOPriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Gnosis.ACL_MANAGER,
            baseAggregatorAddress: AaveV3GnosisAssets.GNO_ORACLE,
            ratioProviderAddress: OSGNO_RATE,
            pairDescription: 'Capped osGNO / GNO / USD',
            minimumSnapshotDelay: 14 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1034800537023806496,
              snapshotTimestamp: 1734067335, // dec-13-2024
              maxYearlyRatioGrowthPercent: 13_01
            })
          })
        )
      );
  }
}

contract DeploySDaiGnosis is GnosisScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeGnosis.sDAIAdapterCode());
  }
}

contract DeployOsGNOGnosis is GnosisScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeGnosis.osGNOAdapterCode());
  }
}
