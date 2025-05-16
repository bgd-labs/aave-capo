// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {GnosisScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Gnosis, AaveV3GnosisAssets} from 'aave-address-book/AaveV3Gnosis.sol';

import {sDAIGnosisPriceCapAdapter} from '../src/contracts/lst-adapters/sDAIGnosisPriceCapAdapter.sol';
import {IPriceCapAdapter} from '../src/interfaces/IPriceCapAdapter.sol';

library CapAdaptersCodeGnosis {
  address public constant DAI_PRICE_FEED = 0x678df3415fc31947dA4324eC63212874be5a82f8;

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
              snapshotRatio: 1_175603447581596870,
              snapshotTimestamp: 1746358275,
              maxYearlyRatioGrowthPercent: 9_69
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
