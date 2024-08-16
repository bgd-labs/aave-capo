// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {GovV3Helpers} from 'aave-helpers/GovV3Helpers.sol';
import {ScrollScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {AaveV3Scroll, AaveV3ScrollAssets} from 'aave-address-book/AaveV3Scroll.sol';

import {CLRatePriceCapAdapter, IPriceCapAdapter} from '../src/contracts/CLRatePriceCapAdapter.sol';

library CapAdaptersCodeScroll {
  address public constant weETH_eETH_AGGREGATOR = 0x57bd9E614f542fB3d6FeF2B744f3B813f0cc1258;

  function weETHAdapterCode() internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        type(CLRatePriceCapAdapter).creationCode,
        abi.encode(
          IPriceCapAdapter.CapAdapterParams({
            aclManager: AaveV3Scroll.ACL_MANAGER,
            baseAggregatorAddress: AaveV3ScrollAssets.WETH_ORACLE,
            ratioProviderAddress: weETH_eETH_AGGREGATOR,
            pairDescription: 'Capped weETH / eETH(ETH) / USD',
            minimumSnapshotDelay: 7 days,
            priceCapParams: IPriceCapAdapter.PriceCapUpdateParams({
              snapshotRatio: 1043672014665104220,
              snapshotTimestamp: 1721839043, // 25th of July 2024
              maxYearlyRatioGrowthPercent: 8_75
            })
          })
        )
      );
  }
}

contract DeployWeEthScroll is ScrollScript {
  function run() external broadcast {
    GovV3Helpers.deployDeterministic(CapAdaptersCodeScroll.weETHAdapterCode());
  }
}
